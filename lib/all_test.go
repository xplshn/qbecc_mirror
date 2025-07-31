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
	disableVet     bool
	dumpSSA        bool
	extendedErrors bool
	keep           bool
	re             *regexp.Regexp
	skipGoABI0     bool
	trcOutput      bool
	xtrc           bool

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

func newParalelTest() (r *parallelTest) {
	return &parallelTest{
		limit: make(chan struct{}, runtime.GOMAXPROCS(0)),
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

	p := newParalelTest()
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
			trc("%s", fsName)
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
		trc("%s", fsName)
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
