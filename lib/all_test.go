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
)

var (
	extendedErrors bool
	keep           bool
	re             *regexp.Regexp
	xtrc           bool
)

func TestMain(m *testing.M) {
	if gcc == "" {
		panic(todo("host C compiler not found"))
	}

	oRE := flag.String("re", "", "")
	flag.BoolVar(&keep, "keep", false, "")
	flag.BoolVar(&extendedErrors, "extended-errors", false, "")
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
	gccFails atomic.Int32
	passed   atomic.Int32
	skipped  atomic.Int32
	tested   atomic.Int32
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

func TestPOC(t *testing.T) {
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
		"tcc-0.9.27/tests/tests2",
	} {
		t.Run(v, func(t *testing.T) {
			testExec(t, &id, destDir, v, regexp.MustCompile("00_"))
		})
	}
}

// 2025-05-22
//	all_test.go:193: tcc-0.9.27/tests/tests2: gcc fails=0 files=1 skipped=0 failed=0 passed=1
//	all_test.go:193: CompCert-3.6/test/c: gcc fails=8 files=16 skipped=16 failed=0 passed=0
//	all_test.go:193: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: gcc fails=26 files=1479 skipped=1479 failed=1 passed=0
//	all_test.go:193: github.com/AbsInt/CompCert/test/c: gcc fails=8 files=16 skipped=16 failed=0 passed=0
//	all_test.go:193: tcc-0.9.27/tests/tests2: gcc fails=8 files=80 skipped=76 failed=0 passed=4

// func TestExec(t *testing.T) {
// 	t.Logf("using C compiler at %s", gcc)
// 	const destDir = "tmp"
// 	os.RemoveAll(destDir)
// 	if err := os.Mkdir(destDir, 0770); err != nil {
// 		t.Fatal(err)
// 	}
//
// 	if !keep {
// 		defer os.RemoveAll(destDir)
// 	}
//
// 	id := 0
// 	for _, v := range []string{
// 		"CompCert-3.6/test/c",
// 		"gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute",
// 		"github.com/AbsInt/CompCert/test/c",
// 		"tcc-0.9.27/tests/tests2",
// 	} {
// 		t.Run(v, func(t *testing.T) {
// 			testExec(t, &id, destDir, v, re)
// 		})
// 	}
// }

var bad = []byte("require-effective-target int128")

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

		if re != nil && !re.MatchString(nm) {
			continue
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
	t.Logf("%s: gcc fails=%v files=%v skipped=%v failed=%v passed=%v",
		suite, p.gccFails.Load(), p.tested.Load(), p.failed.Load(), p.skipped.Load(), p.passed.Load())
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

	if goos == "windows" {
		t.Skip("windows targets are not supported")
	}

	p.tested.Add(1)
	if xtrc {
		trc("%s %s/%s", sid, assets, fsName)
	}
	ccBin := binPath(fmt.Sprintf("%s.out", fn))
	args = []string{
		os.Args[0],
		"-o", ccBin,
		"--ssa-header", fmt.Sprintf("# %s\n\n", fsName),
		fn,
	}
	if extendedErrors {
		args = append(args, "--extended-errors")
	}
	task, err := NewTask(&Options{
		Stdout:     io.Discard,
		Stderr:     io.Discard,
		GOMAXPROCS: 1, // Test is already parallel
	}, args...)
	if err != nil {
		t.Logf("COMPILE FAIL: %s", fsName)
		p.failed.Add(1)
		return err
	}

	if err = task.Main(); err != nil {
		t.Logf("COMPILE FAIL: %s", fsName)
		p.failed.Add(1)
		return err
	}

	ccBinOut, err := shell(gccBinTO, ccBin)
	if err != nil {
		t.Logf("EXEC FAIL: %s", fsName)
		p.failed.Add(1)
		return err
	}

	if !bytes.Equal(gccBinOut, ccBinOut) {
		t.Logf("EQUAL FAIL: %s", fsName)
		p.failed.Add(1)
		return fmt.Errorf("output differs")
	}

	p.passed.Add(1)
	return nil
}
