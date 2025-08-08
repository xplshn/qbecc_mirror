// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"bytes"
	"flag"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"runtime"
	"sort"
	"strings"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"modernc.org/ccorpus2"
)

const (
	assets   = "~/src/modernc.org/ccorpus2"
	gccBinTO = 40 * time.Second
	gccTO    = 40 * time.Second
	goTO     = 40 * time.Second
)

var (
	csmithTestLimit int
	csmithTimeLimit time.Duration
	disableVet      bool
	dumpSSA         bool
	extendedErrors  bool
	keep            bool
	re              *regexp.Regexp
	skipGoABI0      bool
	trcOutput       bool
	xtrc            bool

	enableGoABI0 = map[string]bool{
		"linux/amd64": true,
	}
)

func TestMain(m *testing.M) {
	if gcc == "" {
		panic(todo("host C compiler not found"))
	}

	oRE := flag.String("re", "", "")
	flag.BoolVar(&dbgInit, "dbginit", false, "")
	flag.BoolVar(&disableVet, "disable-vet", false, "")
	flag.BoolVar(&dumpSSA, "dump-ssa", false, "")
	flag.BoolVar(&extendedErrors, "extended-errors", false, "")
	flag.BoolVar(&keep, "keep", false, "")
	flag.BoolVar(&skipGoABI0, "skipgoabi0", !enableGoABI0[target], "")
	flag.BoolVar(&trcOutput, "trco", false, "")
	flag.BoolVar(&xtrc, "trc", false, "")
	flag.IntVar(&csmithTestLimit, "csmithn", 4000, "")
	flag.DurationVar(&csmithTimeLimit, "csmith", 4*time.Hour, "")
	flag.Parse()
	if s := *oRE; s != "" {
		re = regexp.MustCompile(s)
	}
	rc := m.Run()
	os.Exit(rc)
}

type parallelTest struct {
	sync.Mutex

	errs  []error
	limit chan struct{}
	wg    sync.WaitGroup

	failed   atomic.Int32
	files    atomic.Int32
	gccFails atomic.Int32
	passed   atomic.Int32
	skipped  atomic.Int32
}

func newParalelTest(max int) (r *parallelTest) {
	if max <= 0 {
		max = runtime.GOMAXPROCS(0)
	}
	return &parallelTest{
		limit: make(chan struct{}, max),
	}
}

func (p *parallelTest) exec(run func() error) {
	p.limit <- struct{}{}
	p.wg.Add(1)

	go func() {
		defer func() {
			p.wg.Done()
			<-p.limit
		}()

		p.err(run())
	}()
}

func (p *parallelTest) wait() (errs []error) {
	p.wg.Wait()
	sort.Slice(p.errs, func(i, j int) bool { return p.errs[i].Error() < p.errs[j].Error() })
	return p.errs
}

func (p *parallelTest) err(err error) {
	if err == nil {
		return
	}

	p.Lock()
	p.errs = append(p.errs, err)
	p.Unlock()
}

func TestExec(t *testing.T) {
	t.Logf("using C compiler at %s", gcc)
	const destDir = "tmp"
	os.RemoveAll(destDir)
	if err := os.Mkdir(destDir, 0770); err != nil {
		t.Fatal(err)
	}

	if !keep {
		defer os.RemoveAll(destDir)
	}

	id := 0
	for _, v := range []string{
		"CompCert-3.6/test/c",
		"gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute",
		"tcc-0.9.27/tests/tests2",
	} {
		t.Run(v, func(t *testing.T) {
			testExec(t, &id, destDir, v, re)
		})
	}
}

var (
	bad = []byte("require-effective-target int128")
)

func testExec(t *testing.T, id *int, destDir, suite string, re *regexp.Regexp) {
	srcDir := "assets/" + suite
	files, err := ccorpus2.FS.ReadDir(srcDir)
	if err != nil {
		t.Fatal(err)
	}

	p := newParalelTest(-1)
	for _, v := range files {
		nm := v.Name()
		if filepath.Ext(nm) != ".c" {
			continue
		}

		p.files.Add(1)
		switch {
		case re != nil:
			if !re.MatchString(nm) {
				continue
			}
		default:
			if _, ok := blacklist[filepath.Base(nm)]; ok {
				p.skipped.Add(1)
				continue
			}
		}

		fsName := srcDir + "/" + nm
		b, err := ccorpus2.FS.ReadFile(fsName)
		if err != nil {
			t.Fatal(err)
		}

		if bytes.Contains(b[:min(len(b), 1000)], bad) {
			p.skipped.Add(1)
			continue
		}

		sid := fmt.Sprintf("%04d", *id)
		(*id)++
		p.exec(func() error {
			fn := filepath.Join(destDir, fmt.Sprintf("main%s.c", sid))
			if err := os.WriteFile(fn, b, 0660); err != nil {
				return fmt.Errorf("%s: %s: %v", sid, nm, err)
			}

			return testExec2(t, p, suite, nm, fn, sid, assets+"/"+fsName)
		})
	}
	for _, v := range p.wait() {
		t.Error(v)
	}
	t.Logf("%s: files=%v gcc fails=%v skipped=%v failed=%v passed=%v",
		suite, p.files.Load(), p.gccFails.Load(), p.skipped.Load(), p.failed.Load(), p.passed.Load())
}

func binPath(s string) string {
	switch goos {
	case "windows":
		return s + ".exe"
	default:
		return "./" + s
	}
}

// These tests use gcc-specific enum signedness
var gccEnums = map[string]struct{}{
	"20030714-1.c":       {},
	"92_enum_bitfield.c": {},
	"20000914-1.c":       {},
}

func testExec2(t *testing.T, p *parallelTest, suite, testNm, fn, sid, fsName string) (err error) {
	gccBin := binPath(fmt.Sprintf("%s.cc.out", fn))
	args := []string{gcc, fn, "-o", gccBin, "-lm"}

	if _, err = shell(gccTO, args[0], args[1:]...); err != nil {
		p.gccFails.Add(1)
		return nil
	}

	gccBinOut, err := shell(gccBinTO, gccBin)
	if err != nil {
		p.gccFails.Add(1)
		return nil
	}

	if trcOutput {
		t.Logf("gcc out:\n%s", gccBinOut)
	}

	if goos == "windows" {
		t.Skip("windows targets not supported")
	}

	qbeccBin := binPath(fmt.Sprintf("%s.out", fn))
	args = []string{
		os.Args[0],
		"-o", qbeccBin,
		"--keep-ssa",
		"--ssa-header", fmt.Sprintf("# %s\n\n", fsName),
		fn,
		"-lm",
	}
	if extendedErrors {
		args = append(args, "--extended-errors")
	}
	if dumpSSA {
		args = append(args, "--dump-ssa")
	}
	if _, ok := gccEnums[filepath.Base(fsName)]; ok {
		args = append(args, "--unsigned-enums")
	}
	task, err := NewTask(&Options{
		Stdout:     io.Discard,
		Stderr:     io.Discard,
		GOMAXPROCS: 1, // Test is already parallel
	}, args...)
	if err != nil {
		t.Logf("C COMPILE FAIL: %s\nerr=%v", fsName, err)
		p.failed.Add(1)
		return err
	}

	if err = task.Main(); err != nil {
		t.Logf("C COMPILE FAIL: %s\nerr=%v", fsName, err)
		p.failed.Add(1)
		return err
	}

	qbeccBinOut, err := shell(gccBinTO, qbeccBin)
	if err != nil {
		t.Logf("C EXEC FAIL: %s\nerr=%v\n%s", fsName, err, qbeccBinOut)
		p.failed.Add(1)
		return err
	}

	if !bytes.Equal(gccBinOut, qbeccBinOut) {
		t.Logf("C EQUAL FAIL: %s", fsName)
		p.failed.Add(1)
		return fmt.Errorf("output differs\ngot\n%s\nwant\n%s", qbeccBinOut, gccBinOut)
	}

	dir := fmt.Sprintf("%s.dir", fn)
	if err = os.Mkdir(dir, 0770); err != nil {
		t.Logf("C COMPILE FAIL: %s\nerr=%v", fsName, err)
		p.failed.Add(1)
		return err
	}

	if !keep {
		defer os.RemoveAll(dir)
	}

	if skipGoABI0 {
		if xtrc {
			trc("%v: %s", sid, fsName)
		}
		p.passed.Add(1)
		return
	}

	base := filepath.Base(fn)
	qbeccAsm := filepath.Join(dir, fmt.Sprintf("%s.s", base))
	args = []string{
		os.Args[0],
		"-o", qbeccAsm,
		"--goabi0",
		qbeccBin,
	}
	if extendedErrors {
		args = append(args, "--extended-errors")
	}
	if dumpSSA {
		args = append(args, "--dump-ssa")
	}
	if task, err = NewTask(&Options{
		Stdout:     io.Discard,
		Stderr:     io.Discard,
		GOMAXPROCS: 1, // Test is already parallel
	}, args...); err != nil {
		t.Logf("GO COMPILE FAIL: %s\nerr=%v", fsName, err)
		p.failed.Add(1)
		return err
	}
	if err = task.Main(); err != nil {
		t.Logf("GO COMPILE FAIL: %s\nerr=%v", fsName, err)
		p.failed.Add(1)
		return err
	}

	mainGo := filepath.Join(dir, fmt.Sprintf("%s.go", base))
	b := bytes.NewBuffer([]byte(`package main

import (
	"modernc.org/libc"
)

func main() {
	libc.Start(__qbe_main)
}

`))
	for _, v := range task.linkerObjects {
		var a []string
		for k := range v.signatures {
			a = append(a, k)
		}
		sort.Strings(a)
		for _, k := range a {
			in := v.signatures[k]
			out := renameParam(in[len(in)-1])
			in = in[:len(in)-1]
			for i, v := range in {
				in[i] = renameParam(v)
			}
			prefix := ""
			switch v.defines[k] {
			case symbolExportedData, symbolExportedFunction:
				prefix = "Y"
			}
			switch k {
			case "main":
				fmt.Fprintf(b, "func __qbe_main(%s) int32", strings.Join(in, ", "))
			default:
				fmt.Fprintf(b, "func %s%s(%s)", prefix, unquote(k), strings.Join(in, ", "))
				if out != "" {
					fmt.Fprintf(b, " %s", out)
				}
			}
			fmt.Fprintf(b, "\n")
		}
	}
	if err = os.WriteFile(mainGo, b.Bytes(), 0660); err != nil {
		t.Logf("GO COMPILE FAIL: %s\nerr=%v", fsName, err)
		p.failed.Add(1)
		return err
	}

	if !disableVet {
		goOut, err := shell(goTO, "go", "vet", "./"+dir)
		if err != nil {
			t.Logf("GO VET FAIL: %s\nerr=%v\n%s", fsName, err, goOut)
			p.failed.Add(1)
			return err
		}
	}

	goOut, err := shell(goTO, "go", "run", "./"+dir)
	if err != nil {
		t.Logf("GO EXEC FAIL: %s\nerr=%v\n%s", fsName, err, goOut)
		p.failed.Add(1)
		return err
	}

	if !bytes.Equal(gccBinOut, goOut) {
		t.Logf("GO EQUAL FAIL: %s", fsName)
		p.failed.Add(1)
		return fmt.Errorf("output differs\ngot\n%s\nwant\n%s", goOut, gccBinOut)
	}

	if xtrc {
		trc("%v: %s", sid, fsName)
	}
	p.passed.Add(1)
	return nil
}

func renameParam(s string) string {
	a := strings.Fields(s)
	if len(a) == 0 {
		return s
	}
	const prefix = "__qbe_"
	switch a[0] {
	case
		"g",
		"map",
		"type",
		"var":

		return prefix + s
	default:
		return s
	}
}

var csmithFixedBugs = []string{
	// ccgo/v4
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 1110506964",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 1338573550",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 1416441494",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 15739796933983044010",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 169375684",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 1833258637",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 1885311141",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 2205128324",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 2273393378",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 241244373",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 2517344771",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 2648215054",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 2876930815",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 2877850218",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 2949258094",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 3043990076",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 3100949894",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 3126091077",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 3130410542",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 3329111231",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 3363122597",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 3365074920",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 3578720023",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 3645367888",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 3919255949",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 3980073540",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 4058772172",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 4101947480",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 4130344133",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 4146870674",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 424465590",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 517639208",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 56498550",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 890611563",
	"--bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 963985971",
	"--bitfields --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid --max-nested-struct-level 10 -s 1236173074",
	"--bitfields --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid --max-nested-struct-level 10 -s 1906742816",
	"--bitfields --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid --max-nested-struct-level 10 -s 3629008936",
	"--bitfields --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid --max-nested-struct-level 10 -s 612971101",
	"--max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid --bitfields -s 1701143130",
	"--max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid --bitfields -s 1714958724",
	"--max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid --bitfields -s 20004725738999789",
	"--max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid --bitfields -s 3088696074888013",
	"--max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid --bitfields -s 3654957324",
	"--max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid --bitfields -s 8032246412188002",
	"--no-bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 1302111308",
	"--no-bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 3285852464",
	"--no-bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 3609090094",
	"--no-bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 3720922579",
	"--no-bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 4263172072",
	"--no-bitfields --max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 572192313",

	// qbecc
	"--max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 15024275419590464623",
	"--max-nested-struct-level 10 --no-const-pointers --no-consts --no-packed-struct --no-volatile-pointers --no-volatiles --paranoid -s 16158483724416576105",
}

func TestCSmith(t *testing.T) {
	if testing.Short() {
		t.Skip("skipped: -short")
	}

	csmithBin, err := exec.LookPath("csmith")
	if err != nil {
		t.Skip("csmith not found in $PATH")
	}

	p := newParalelTest(-1)

	t.Logf("using C compiler at %s", gcc)
	const destDir = "tmp"
	os.RemoveAll(destDir)
	if err := os.Mkdir(destDir, 0770); err != nil {
		t.Fatal(err)
	}

	if !keep {
		defer os.RemoveAll(destDir)
	}

	csmithDefaultArgs := strings.Join([]string{
		"--max-nested-struct-level", "10", // --max-nested-struct-level <num>: limit maximum nested level of structs to <num>(default 0). Only works in the exhaustive mode.
		"--no-const-pointers",    // --const-pointers | --no-const-pointers: enable | disable const pointers (enabled by default).
		"--no-consts",            // --consts | --no-consts: enable | disable const qualifier (enabled by default).
		"--no-packed-struct",     // --packed-struct | --no-packed-struct: enable | disable packed structs by adding #pragma pack(1) before struct definition (disabled by default).
		"--no-volatile-pointers", // --volatile-pointers | --no-volatile-pointers: enable | disable volatile pointers (enabled by default).
		"--no-volatiles",         // --volatiles | --no-volatiles: enable | disable volatiles (enabled by default).
		"--paranoid",             // --paranoid | --no-paranoid: enable | disable pointer-related assertions (disabled by default).
	}, " ")

	t0 := time.Now()
	fixedBugs := csmithFixedBugs
	var stop atomic.Bool
	for id := 0; !stop.Load() && id < csmithTestLimit; id++ {
		if time.Since(t0) > csmithTimeLimit {
			break
		}

		hasSeed := false
		var csmithArgs string
		switch {
		case len(fixedBugs) != 0:
			csmithArgs = fixedBugs[0]
			fixedBugs = fixedBugs[1:]
			hasSeed = true
		default:
			csmithArgs = csmithDefaultArgs
		}

		if re != nil {
			if !re.MatchString(csmithArgs) {
				continue
			}

			stop.Store(true) // single shot, eg. -re 1110506964 to run the fixed bugs '... -s 1110506964'
		}

		func(id int) {
			p.exec(func() (err error) {
				dir := filepath.Join(destDir, fmt.Sprintf("csmith%v", id))
				if err := os.MkdirAll(dir, 0770); err != nil {
					t.Fatal(err)
				}

				if !keep {
					defer os.RemoveAll(dir)
				}
				if err = execCSmith(t, p, dir, csmithBin, csmithArgs, hasSeed, fmt.Sprintf("%06d", id)); err != nil {
					stop.Store(true)
				}
				return err
			})
		}(id)
	}
	for _, v := range p.wait() {
		t.Error(v)
	}
	t.Logf("files=%v gcc fails=%v skipped=%v failed=%v passed=%v",
		p.files.Load(), p.gccFails.Load(), p.skipped.Load(), p.failed.Load(), p.passed.Load())
}

var (
	seed = []byte("* Seed:")
)

func execCSmith(t *testing.T, p *parallelTest, dir, csmithBin, csmithArgs string, hasSeed bool, sid string) (err error) {
	// trc("run csmith")
	csOut, err := exec.Command(csmithBin, strings.Split(csmithArgs, " ")...).Output()
	if err != nil {
		p.gccFails.Add(1)
		return fmt.Errorf("csmith: %s", err)
	}

	if !hasSeed {
		x := bytes.Index(csOut, seed)
		b := csOut[x+len(seed):]
		x = bytes.IndexByte(b, '\n')
		csmithArgs += " -s " + strings.TrimSpace(string(b[:x]))
	}

	// trc("write main.c")
	cfile := filepath.Join(dir, "main.c")
	b := []byte("//go:build ingore\n\n")
	if err := os.WriteFile(cfile, append(b, csOut...), 0660); err != nil {
		p.gccFails.Add(1)
		return fmt.Errorf("os.WriteFile: %s", err)
	}

	// trc("run gcc")
	gccBin := binPath(filepath.Join(dir, "gcc.out"))
	csp := fmt.Sprintf("-I%s", filepath.FromSlash("/usr/include/csmith"))
	if s := os.Getenv("CSMITH_PATH"); s != "" {
		csp = fmt.Sprintf("-I%s", s)
	}
	args := []string{gcc, cfile, csp, "-o", gccBin, "-lm", "-lpthread"}
	if _, err = shell(gccTO, args[0], args[1:]...); err != nil {
		p.gccFails.Add(1)
		return nil
	}

	// trc("run gcc bin")
	gccBinOut, err := shell(gccBinTO, gccBin)
	if err != nil {
		p.gccFails.Add(1)
		return nil
	}

	qbeccBin := binPath(filepath.Join(dir, "qbecc.out"))
	args = []string{
		os.Args[0],
		"-o", qbeccBin,
		"--keep-ssa",
		cfile,
		csp,
		"-lm",
		//TODO "-lpthread",
	}
	task, err := NewTask(&Options{
		Stdout:     io.Discard,
		Stderr:     io.Discard,
		GOMAXPROCS: 1, // Test is already parallel
	}, args...)
	if err != nil {
		err = fmt.Errorf("C COMPILE FAIL: args=%s err=%v", csmithArgs, err)
		p.failed.Add(1)
		return err
	}

	// trc("run qbecc")
	if err = task.Main(); err != nil {
		err = fmt.Errorf("C COMPILE FAIL: args=%s err=%v", csmithArgs, err)
		p.failed.Add(1)
		return err
	}

	// trc("run qbecc bin")
	qbeccBinOut, err := shell(gccBinTO, qbeccBin)
	if err != nil {
		err = fmt.Errorf("C EXEC FAIL: args=%s err=%v", csmithArgs, err)
		p.failed.Add(1)
		return err
	}

	if !bytes.Equal(gccBinOut, qbeccBinOut) {
		err = fmt.Errorf("C EQUAL FAIL: args=%s", csmithArgs)
		p.failed.Add(1)
		return err
	}

	if skipGoABI0 {
		if xtrc {
			trc("%s: %s %s", sid, dir, csmithArgs)
		}
		p.passed.Add(1)
		return nil
	}

	qbeccAsm := filepath.Join(dir, "main.s")
	args = []string{
		os.Args[0],
		"-o", qbeccAsm,
		"--goabi0",
		qbeccBin,
	}
	if task, err = NewTask(&Options{
		Stdout:     io.Discard,
		Stderr:     io.Discard,
		GOMAXPROCS: 1, // Test is already parallel
	}, args...); err != nil {
		err = fmt.Errorf("GO COMPILE FAIL: args=%s", csmithArgs)
		p.failed.Add(1)
		return err
	}

	if err = task.Main(); err != nil {
		err = fmt.Errorf("GO COMPILE FAIL: args=%s", csmithArgs)
		p.failed.Add(1)
		return err
	}

	mainGo := filepath.Join(dir, "main.go")
	buf := bytes.NewBuffer([]byte(`package main

import (
	"modernc.org/libc"
)

func main() {
	libc.Start(__qbe_main)
}

`))
	for _, v := range task.linkerObjects {
		var a []string
		for k := range v.signatures {
			a = append(a, k)
		}
		sort.Strings(a)
		for _, k := range a {
			in := v.signatures[k]
			out := renameParam(in[len(in)-1])
			in = in[:len(in)-1]
			for i, v := range in {
				in[i] = renameParam(v)
			}
			prefix := ""
			switch v.defines[k] {
			case symbolExportedData, symbolExportedFunction:
				prefix = "Y"
			}
			switch k {
			case "main":
				fmt.Fprintf(buf, "func __qbe_main(%s) int32", strings.Join(in, ", "))
			default:
				fmt.Fprintf(buf, "func %s%s(%s)", prefix, unquote(k), strings.Join(in, ", "))
				if out != "" {
					fmt.Fprintf(buf, " %s", out)
				}
			}
			fmt.Fprintf(buf, "\n")
		}
	}
	if err = os.WriteFile(mainGo, buf.Bytes(), 0660); err != nil {
		err = fmt.Errorf("GO COMPILE FAIL: args=%s", csmithArgs)
		p.failed.Add(1)
		return err
	}

	if !disableVet {
		if _, err := shell(goTO, "go", "vet", "./"+dir); err != nil {
			err = fmt.Errorf("GO VET FAIL: args=%s", csmithArgs)
			p.failed.Add(1)
			return err
		}
	}

	goOut, err := shell(goTO, "go", "run", "./"+dir)
	if err != nil {
		err = fmt.Errorf("GO EXEC FAIL: args=%s\ndir=%s err=%s", csmithArgs, dir, err)
		p.failed.Add(1)
		return err
	}

	if !bytes.Equal(gccBinOut, goOut) {
		err = fmt.Errorf("GO EQUAL FAIL: args=%s", csmithArgs)
		p.failed.Add(1)
		return err
	}

	if xtrc {
		trc("%s: %s %s", sid, dir, csmithArgs)
	}
	p.passed.Add(1)
	return nil
}
