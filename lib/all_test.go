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
	goTO     = 10 * time.Second
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

// 2025-05-22
//	all_test.go:193: tcc-0.9.27/tests/tests2: gcc fails=0 files=1 skipped=0 failed=0 passed=1
//	all_test.go:193: CompCert-3.6/test/c: gcc fails=8 files=16 skipped=16 failed=0 passed=0
//	all_test.go:193: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: gcc fails=26 files=1479 skipped=1479 failed=1 passed=0
//	all_test.go:193: github.com/AbsInt/CompCert/test/c: gcc fails=8 files=16 skipped=16 failed=0 passed=0
//	all_test.go:193: tcc-0.9.27/tests/tests2: gcc fails=8 files=80 skipped=76 failed=0 passed=4

// 2025-06-17 incl. --goabi0
//	all_test.go:283: tcc-0.9.27/tests/tests2: gcc fails=0 files=7 skipped=81 failed=0 passed=7

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
		// "CompCert-3.6/test/c",
		// "gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute",
		// "github.com/AbsInt/CompCert/test/c",
		"tcc-0.9.27/tests/tests2",
	} {
		t.Run(v, func(t *testing.T) {
			testExec(t, &id, destDir, v, re)
		})
	}
}

var (
	bad       = []byte("require-effective-target int128")
	blacklist = map[string]struct{}{
		"03_struct.c":                  {},
		"05_array.c":                   {},
		"06_case.c":                    {},
		"07_function.c":                {},
		"08_while.c":                   {},
		"09_do_while.c":                {},
		"10_pointer.c":                 {},
		"11_precedence.c":              {},
		"12_hashdefine.c":              {},
		"14_if.c":                      {},
		"15_recursion.c":               {},
		"16_nesting.c":                 {},
		"17_enum.c":                    {},
		"18_include.c":                 {},
		"19_pointer_arithmetic.c":      {},
		"20_pointer_comparison.c":      {},
		"21_char_array.c":              {},
		"22_floating_point.c":          {},
		"23_type_coercion.c":           {},
		"24_math_library.c":            {},
		"25_quicksort.c":               {},
		"27_sizeof.c":                  {},
		"28_strings.c":                 {},
		"29_array_address.c":           {},
		"30_hanoi.c":                   {},
		"31_args.c":                    {},
		"32_led.c":                     {},
		"33_ternary_op.c":              {},
		"34_array_assignment.c":        {},
		"35_sizeof.c":                  {},
		"36_array_initialisers.c":      {},
		"37_sprintf.c":                 {},
		"38_multiple_array_index.c":    {},
		"39_typedef.c":                 {},
		"40_stdio.c":                   {},
		"42_function_pointer.c":        {},
		"43_void_param.c":              {},
		"44_scoped_declarations.c":     {},
		"45_empty_for.c":               {},
		"46_grep.c":                    {},
		"47_switch_return.c":           {},
		"48_nested_break.c":            {},
		"49_bracket_evaluation.c":      {},
		"50_logical_second_arg.c":      {},
		"51_static.c":                  {},
		"52_unnamed_enum.c":            {},
		"54_goto.c":                    {},
		"55_lshift_type.c":             {},
		"60_errors_and_warnings.c":     {},
		"64_macro_nesting.c":           {},
		"67_macro_concat.c":            {},
		"70_floating_point_literals.c": {},
		"71_macro_empty_arg.c":         {},
		"72_long_long_constant.c":      {},
		"73_arm64.c":                   {},
		"75_array_in_struct_init.c":    {},
		"76_dollars_in_identifiers.c":  {},
		"77_push_pop_macro.c":          {},
		"78_vla_label.c":               {},
		"79_vla_continue.c":            {},
		"80_flexarray.c":               {},
		"81_types.c":                   {},
		"82_attribs_position.c":        {},
		"83_utf8_in_identifiers.c":     {},
		"84_hex-float.c":               {},
		"85_asm-outside-function.c":    {},
		"86_memory-model.c":            {},
		"87_dead_code.c":               {},
		"88_codeopt.c":                 {},
		"89_nocode_wanted.c":           {},
		"90_struct-init.c":             {},
		"91_ptr_longlong_arith32.c":    {},
		"92_enum_bitfield.c":           {},
		"93_integer_promotion.c":       {},
		"94_generic.c":                 {},
		"95_bitfields.c":               {},
		"95_bitfields_ms.c":            {},
		"96_nodata_wanted.c":           {},
		"97_utf8_string_literal.c":     {},
		"98_al_ax_extend.c":            {},
		"99_fastcall.c":                {},
	}
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
	t.Logf("%s: gcc fails=%v files=%v skipped=%v failed=%v passed=%v",
		suite, p.gccFails.Load(), p.tested.Load(), p.skipped.Load(), p.failed.Load(), p.passed.Load())
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
		trc("%s %s", sid, fsName)
	}
	qbeccBin := binPath(fmt.Sprintf("%s.out", fn))
	args = []string{
		os.Args[0],
		"-o", qbeccBin,
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

	qbeccBinOut, err := shell(gccBinTO, qbeccBin)
	if err != nil {
		t.Logf("EXEC FAIL: %s", fsName)
		p.failed.Add(1)
		return err
	}

	if !bytes.Equal(gccBinOut, qbeccBinOut) {
		t.Logf("EQUAL FAIL: %s", fsName)
		p.failed.Add(1)
		return fmt.Errorf("output differs")
	}

	dir := fmt.Sprintf("%s.dir", fn)
	if err = os.Mkdir(dir, 0770); err != nil {
		t.Logf("COMPILE FAIL: %s err=%v", fsName, err)
		p.failed.Add(1)
		return err
	}

	if !keep {
		defer os.RemoveAll(dir)
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
	if task, err = NewTask(&Options{
		Stdout:     io.Discard,
		Stderr:     io.Discard,
		GOMAXPROCS: 1, // Test is already parallel
	}, args...); err != nil {
		t.Logf("COMPILE FAIL: %s", fsName)
		p.failed.Add(1)
		return err
	}
	if err = task.Main(); err != nil {
		t.Logf("COMPILE FAIL: %s", fsName)
		p.failed.Add(1)
		return err
	}

	mainGo := filepath.Join(dir, fmt.Sprintf("%s.go", filepath.Base(fn)))
	if err = os.WriteFile(mainGo, []byte(`package main

import (
	"modernc.org/libc"
)

func __qbe_main(*libc.TLS, int32, uintptr) int32

func main() {
	libc.Start(__qbe_main)
}
`), 0660); err != nil {
		t.Logf("COMPILE FAIL: %s", fsName)
		trc("%q", testNm)
		p.failed.Add(1)
		return err
	}

	goOut, err := shell(goTO, "go", "run", "./"+dir)
	if err != nil {
		t.Logf("EXEC FAIL: %s", fsName)
		trc("%q", testNm)
		p.failed.Add(1)
		return err
	}

	if !bytes.Equal(gccBinOut, goOut) {
		t.Logf("EQUAL FAIL: %s", fsName)
		trc("%q", testNm)
		p.failed.Add(1)
		return fmt.Errorf("output differs")
	}

	p.passed.Add(1)
	return nil
}
