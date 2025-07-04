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
	gccBinTO = 10 * time.Second
	gccTO    = 10 * time.Second
	goTO     = 10 * time.Second
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

// 2025-05-22
//	all_test.go:193: tcc-0.9.27/tests/tests2: gcc fails=0 files=1 skipped=0 failed=0 passed=1
//	all_test.go:193: CompCert-3.6/test/c: gcc fails=8 files=16 skipped=16 failed=0 passed=0
//	all_test.go:193: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: gcc fails=26 files=1479 skipped=1479 failed=1 passed=0
//	all_test.go:193: github.com/AbsInt/CompCert/test/c: gcc fails=8 files=16 skipped=16 failed=0 passed=0
//	all_test.go:193: tcc-0.9.27/tests/tests2: gcc fails=8 files=80 skipped=76 failed=0 passed=4

// 2025-06-17 incl. --goabi0
//	all_test.go:283: tcc-0.9.27/tests/tests2: gcc fails=0 files=7 skipped=81 failed=0 passed=7

// 2025-06-24
//	all_test.go:1657: CompCert-3.6/test/c: gcc fails=8 files=2 skipped=14 failed=0 passed=2
//	all_test.go:1657: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: gcc fails=26 files=81 skipped=1399 failed=0 passed=81
//	all_test.go:1657: tcc-0.9.27/tests/tests2: gcc fails=8 files=55 skipped=25 failed=0 passed=55

// 2025-06-25
//	all_test.go:219: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=14 failed=0 passed=2
//	all_test.go:219: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=1399 failed=0 passed=81
//	all_test.go:219: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=24 failed=0 passed=56

// 2025-06-26
//	all_test.go:219: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=14 failed=0 passed=2
//	all_test.go:219: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=1375 failed=0 passed=105
//	all_test.go:219: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=24 failed=0 passed=56

// 2025-06-28
//	all_test.go:234: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=13 failed=0 passed=3
//	all_test.go:234: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=1053 failed=0 passed=427
//	all_test.go:234: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=19 failed=0 passed=61

// 2025-06-29
//	all_test.go:244: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=13 failed=0 passed=3
//	all_test.go:244: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=827 failed=0 passed=653
//	all_test.go:244: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=19 failed=0 passed=61

// 2025-07-01
//	all_test.go:244: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=13 failed=0 passed=3
//	all_test.go:244: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=755 failed=0 passed=725
//	all_test.go:244: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=18 failed=0 passed=62

// 2025-07-02
//	all_test.go:244: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=10 failed=0 passed=6
//	all_test.go:244: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=676 failed=0 passed=804
//	all_test.go:244: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=18 failed=0 passed=62

// 2025-07-03
//	all_test.go:265: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=10 failed=0 passed=6
//	all_test.go:265: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=627 failed=0 passed=853
//	all_test.go:265: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=18 failed=0 passed=62

// 2025-07-04
//	all_test.go:262: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=9 failed=0 passed=7
//	all_test.go:262: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=625 failed=0 passed=855
//	all_test.go:262: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=18 failed=0 passed=62

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

func testExec2(t *testing.T, p *parallelTest, suite, testNm, fn, sid, fsName string) (err error) {
	gccBin := binPath(fmt.Sprintf("%s.cc.out", fn))
	args := []string{gcc, fn, "-o", gccBin}

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
		p.passed.Add(1)
		return
	}

	qbeccAsm := filepath.Join(dir, fmt.Sprintf("%s.s", filepath.Base(fn)))
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

	mainGo := filepath.Join(dir, fmt.Sprintf("%s.go", filepath.Base(fn)))
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
			out := renameGParam(in[len(in)-1])
			in = in[:len(in)-1]
			for i, v := range in {
				in[i] = renameGParam(v)
			}
			switch k {
			case "main":
				fmt.Fprintf(b, "func __qbe_main(%s) int32", strings.Join(in, ", "))
			default:
				fmt.Fprintf(b, "func %s(%s)", k, strings.Join(in, ", "))
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
		return fmt.Errorf("output differs\ngot\n%s\nwant\n%s", gccBinOut, goOut)
	}

	if xtrc {
		trc("%s", fsName)
	}
	p.passed.Add(1)
	return nil
}

func renameGParam(s string) string {
	a := strings.Fields(s)
	if len(a) == 0 {
		return s
	}
	switch a[0] {
	case "g":
		return "__qbe_g " + a[1]
	default:
		return s
	}
}
