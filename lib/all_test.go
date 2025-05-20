// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"bytes"
	"context"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"sort"
	"strings"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"modernc.org/cc/v4"
	"modernc.org/ccorpus2"
)

const (
	assets   = "~/src/modernc.org/ccorpus2/assets"
	gccBinTO = 10 * time.Second
	gccTO    = 10 * time.Second
)

var (
	ccCfg *cc.Config
)

func TestMain(m *testing.M) {
	if gcc == "" {
		panic(todo("host C compiler not found"))
	}

	var err error
	if ccCfg, err = cc.NewConfig(goos, goarch); err != nil {
		panic(todo("cannot acquire host C compiler configuration"))
	}

	rc := m.Run()
	os.Exit(rc)
}

type parallel struct {
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

func newParalel() (r *parallel) {
	return &parallel{
		limit: make(chan struct{}, runtime.GOMAXPROCS(0)),
	}
}

func (p *parallel) exec(run func() error) {
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

func (p *parallel) wait() (errs []error) {
	p.wg.Wait()
	sort.Slice(p.errs, func(i, j int) bool { return p.errs[i].Error() < p.errs[j].Error() })
	return p.errs
}

func (p *parallel) err(err error) {
	if err == nil {
		return
	}

	s := strings.TrimSpace(err.Error())
	a := strings.Split(s, "\n")
	if len(a) == 0 {
		a = append(a, "<empty error>")
	}
	p.Lock()
	p.errs = append(p.errs, fmt.Errorf("%s", a[0]))
	p.Unlock()
}

func TestExec(t *testing.T) {
	t.Logf("using C compiler at %s", gcc)
	const destDir = "tmp"
	os.RemoveAll(destDir)
	if err := os.Mkdir(destDir, 0770); err != nil {
		t.Fatal(err)
	}

	defer os.RemoveAll(destDir)

	id := 0
	for _, v := range []string{
		"CompCert-3.6/test/c",
		"gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute",
		"github.com/AbsInt/CompCert/test/c",
		"tcc-0.9.27/tests/tests2",
	} {
		t.Run(v, func(t *testing.T) {
			testExec(t, &id, destDir, v)
		})
	}
}

var bad = []byte("require-effective-target int128")

func testExec(t *testing.T, id *int, destDir, suite string) {
	srcDir := "assets/" + suite
	files, err := ccorpus2.FS.ReadDir(srcDir)
	if err != nil {
		t.Fatal(err)
	}

	p := newParalel()
	for _, v := range files {
		nm := v.Name()
		if filepath.Ext(nm) != ".c" {
			continue
		}

		b, err := ccorpus2.FS.ReadFile(srcDir + "/" + nm)
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

			return testExec2(t, p, suite, nm, fn, sid)
		})
	}
	for _, v := range p.wait() {
		t.Error(v)
	}
	t.Logf("%s: gcc fails=%v files=%v skipped=%v failed=%v passed=%v",
		suite, p.gccFails.Load(), p.tested.Load(), p.failed.Load(), p.skipped.Load(), p.passed.Load())
}

func shell(to time.Duration, cmd string, args ...string) (out []byte, err error) {
	ctx, cancel := context.WithTimeout(context.Background(), to)
	defer cancel()

	return exec.CommandContext(ctx, cmd, args...).CombinedOutput()
}

func testExec2(t *testing.T, p *parallel, suite, testNm, fn, sid string) (err error) {
	gccBin := fmt.Sprintf("%s.cc.out", fn)
	if goos == "windows" {
		gccBin += ".exe"
	}
	args := []string{gcc, fn, "-o", gccBin}

	gccOut, err := shell(gccTO, args[0], args[1:]...)
	if err != nil {
		// t.Logf("%s: host C compiler fails err=%v out=%s", testNm, err, gccOut)
		_ = gccOut
		p.gccFails.Add(1)
		return nil
	}

	if goos != "windows" {
		gccBin = "./" + gccBin
	}

	gccBinOut, err := shell(gccBinTO, gccBin)
	if err != nil {
		// t.Logf("%s: host C compiled binary fails err=%v out=%s", testNm, err, gccBinOut)
		p.gccFails.Add(1)
		return nil
	}

	p.tested.Add(1)
	task := NewTask(nil, os.Args[0], fn)
	srcs, err := task.sourcesFor(ccCfg, fn)
	if err != nil {
		p.failed.Add(1)
		return fmt.Errorf("%s: %v", fn, err)
	}

	_, err = cc.Translate(ccCfg, srcs)
	if err != nil {
		p.failed.Add(1)
		return fmt.Errorf("%s/%s/%s: %v", assets, suite, testNm, err)
	}

	_ = gccBinOut
	p.passed.Add(1)
	return nil
}
