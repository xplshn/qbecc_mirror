// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

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

// 2025-07-05
//	all_test.go:267: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=9 failed=0 passed=7
//	all_test.go:267: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=618 failed=0 passed=862
//	all_test.go:267: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=18 failed=0 passed=62

// 2025-07-06
//	all_test.go:272: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=6 failed=0 passed=10
//	all_test.go:272: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=607 failed=0 passed=873
//	all_test.go:272: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=19 failed=0 passed=61

// 2025-07-07
//	all_test.go:269: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=5 failed=0 passed=11
//	all_test.go:269: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=568 failed=0 passed=912
//	all_test.go:269: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=18 failed=0 passed=62

// 2025-07-08
//	all_test.go:278: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=3 failed=0 passed=13
//	all_test.go:278: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=527 failed=0 passed=953
//	all_test.go:278: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=16 failed=0 passed=64

// 2025-07-09
//	all_test.go:287: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=3 failed=0 passed=13
//	all_test.go:287: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=475 failed=0 passed=1005
//	all_test.go:287: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=16 failed=0 passed=64

// 2025-07-10
//	all_test.go:292: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=3 failed=0 passed=13
//	all_test.go:292: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=457 failed=0 passed=1023
//	all_test.go:292: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=16 failed=0 passed=64

// 2025-07-11
//	all_test.go:301: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=3 failed=0 passed=13
//	all_test.go:301: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=447 failed=0 passed=1033
//	all_test.go:301: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=16 failed=0 passed=64

// 2025-07-13
//	all_test.go:289: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=3 failed=0 passed=13
//	all_test.go:289: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=444 failed=0 passed=1036
//	all_test.go:289: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=16 failed=0 passed=64

// 2025-07-14
//	all_test.go:307: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=3 failed=0 passed=13
//	all_test.go:307: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=428 failed=0 passed=1052
//	all_test.go:307: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=16 failed=0 passed=64

// 2025-07-15
//	all_test.go:304: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=3 failed=0 passed=13
//	all_test.go:304: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=425 failed=0 passed=1055
//	all_test.go:304: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=16 failed=0 passed=64

// 2025-07-16
//	all_test.go:313: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=2 failed=0 passed=14
//	all_test.go:313: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=423 failed=0 passed=1057
//	all_test.go:313: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=15 failed=0 passed=65

// 2025-07-17
//	all_test.go:311: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=1 failed=0 passed=15
//	all_test.go:311: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=418 failed=0 passed=1062
//	all_test.go:311: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=15 failed=0 passed=65

// 2025-07-21
//	all_test.go:319: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=1 failed=0 passed=15
//	all_test.go:319: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=418 failed=0 passed=1062
//	all_test.go:319: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=15 failed=0 passed=65

// 2025-07-22
//	all_test.go:328: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=1 failed=0 passed=15
//	all_test.go:328: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=355 failed=0 passed=1125
//	all_test.go:328: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=15 failed=0 passed=65

// 2025-07-23
//	all_test.go:341: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=1 failed=0 passed=15
//	all_test.go:341: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=334 failed=0 passed=1146
//	all_test.go:341: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=15 failed=0 passed=65

// 2025-07-24
//	all_test.go:199: CompCert-3.6/test/c: files=24 gcc fails=8 skipped=1 failed=0 passed=15
//	all_test.go:199: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=26 skipped=322 failed=0 passed=1158
//	all_test.go:199: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=15 failed=0 passed=65

// 2025-07-25
//	all_test.go:200: CompCert-3.6/test/c: files=24 gcc fails=1 skipped=1 failed=0 passed=22
//	all_test.go:200: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=24 skipped=321 failed=0 passed=1161
//	all_test.go:200: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=14 failed=0 passed=66

// 2025-07-26
//	all_test.go:200: CompCert-3.6/test/c: files=24 gcc fails=1 skipped=1 failed=0 passed=22
//	all_test.go:200: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=24 skipped=321 failed=0 passed=1161
//	all_test.go:200: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=14 failed=0 passed=66

// 2025-07-27
//	all_test.go:200: CompCert-3.6/test/c: files=24 gcc fails=1 skipped=1 failed=0 passed=22
//	all_test.go:200: gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute: files=1506 gcc fails=24 skipped=317 failed=0 passed=1165
//	all_test.go:200: tcc-0.9.27/tests/tests2: files=88 gcc fails=8 skipped=14 failed=0 passed=66

var blacklist = map[string]struct{}{
	// ---------------------------------------------- "CompCert-3.6/test/c"

	// GO EXEC FAIL

	"qsort.c": {}, //TODO rework func ptrs

	// ------------------------------------------ "tcc-0.9.27/tests/tests2"

	// C COMPILE FAIL

	// Wont'fix: unsupported type
	"78_vla_label.c":    {},
	"79_vla_continue.c": {},
	"80_flexarray.c":    {},
	"90_struct-init.c":  {},

	// C EQUAL FAIL

	"92_enum_bitfield.c": {}, // Won't fix: Depends on GCC-specific unsigned enums

	// -------------------- "gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute"

	// C COMPILE FAIL

	// Wont'fix: assembler statements not supported
	"20001009-2.c":              {},
	"20030222-1.c":              {},
	"20050203-1.c":              {},
	"20061031-1.c":              {},
	"20071211-1.c":              {},
	"20071220-1.c":              {},
	"20071220-2.c":              {},
	"20080122-1.c":              {},
	"85_asm-outside-function.c": {},
	"960312-1.c":                {},
	"98_al_ax_extend.c":         {},
	"990130-1.c":                {},
	"990413-2.c":                {},
	"bitfld-5.c":                {},
	"pr38533.c":                 {},
	"pr40022.c":                 {},
	"pr40657.c":                 {},
	"pr41239.c":                 {},
	"pr43385.c":                 {},
	"pr43560.c":                 {},
	"pr44852.c":                 {},
	"pr45695.c":                 {},
	"pr46309.c":                 {},
	"pr47925.c":                 {},
	"pr49218.c":                 {},
	"pr49279.c":                 {},
	"pr51581-1.c":               {},
	"pr51581-2.c":               {},
	"pr51877.c":                 {},
	"pr51933.c":                 {},
	"pr52286.c":                 {},
	"pr56205.c":                 {},
	"pr56866.c":                 {},
	"pr56982.c":                 {},
	"pr57344-1.c":               {},
	"pr57344-2.c":               {},
	"pr57344-3.c":               {},
	"pr57344-4.c":               {},
	"pr58277-1.c":               {},
	"pr58419.c":                 {},
	"pr63641.c":                 {},
	"pr65053-1.c":               {},
	"pr65053-2.c":               {},
	"pr65648.c":                 {},
	"pr65956.c":                 {},
	"pr68328.c":                 {},
	"pr69320-2.c":               {},
	"pr69691.c":                 {},
	"pr78438.c":                 {},
	"pr78726.c":                 {},
	"pr79354.c":                 {},
	"pr79737-2.c":               {},
	"pr80421.c":                 {},
	"pr81588.c":                 {},
	"pr82954.c":                 {},
	"pr84478.c":                 {},
	"pr84524.c":                 {},
	"pr85156.c":                 {},
	"pr85756.c":                 {},
	"pr88904.c":                 {},
	"stkalign.c":                {},

	// Wont'fix: assembler not supported
	"pr51447.c": {},

	// Wont'fix: unsupported type
	"20010209-1.c":                 {},
	"20010904-1.c":                 {},
	"20010904-2.c":                 {},
	"20020412-1.c":                 {},
	"20040308-1.c":                 {},
	"20040411-1.c":                 {},
	"20040423-1.c":                 {},
	"20040811-1.c":                 {},
	"20041218-2.c":                 {},
	"20050316-1.c":                 {},
	"20050316-2.c":                 {},
	"20050316-3.c":                 {},
	"20050604-1.c":                 {},
	"20050607-1.c":                 {},
	"20060420-1.c":                 {},
	"20070919-1.c":                 {},
	"920721-2.c":                   {},
	"920929-1.c":                   {},
	"921017-1.c":                   {},
	"align-3.c":                    {},
	"align-nest.c":                 {},
	"builtin-types-compatible-p.c": {},
	"pr22061-1.c":                  {},
	"pr22061-4.c":                  {},
	"pr23135.c":                    {},
	"pr41935.c":                    {},
	"pr42570.c":                    {},
	"pr43220.c":                    {},
	"pr53645-2.c":                  {},
	"pr53645.c":                    {},
	"pr60960.c":                    {},
	"pr65369.c":                    {},
	"pr65427.c":                    {},
	"pr70903.c":                    {},
	"pr71626-1.c":                  {},
	"pr79286.c":                    {},
	"pr82210.c":                    {},
	"pr85169.c":                    {},
	"scal-to-vec1.c":               {},
	"scal-to-vec2.c":               {},
	"scal-to-vec3.c":               {},
	"simd-1.c":                     {},
	"simd-2.c":                     {},
	"simd-4.c":                     {},
	"simd-5.c":                     {},
	"simd-6.c":                     {},
	"vla-dealloc-1.c":              {},

	// Wont'fix: nested functions not supported
	"20000822-1.c":   {},
	"20010605-1.c":   {},
	"20030501-1.c":   {},
	"20040520-1.c":   {},
	"20061220-1.c":   {},
	"20090219-1.c":   {},
	"920612-2.c":     {},
	"921215-1.c":     {},
	"931002-1.c":     {},
	"nest-align-1.c": {},
	"nest-stdar-1.c": {},
	"nestfunc-1.c":   {},
	"nestfunc-3.c":   {},
	"nestfunc-2.c":   {},
	"nestfunc-7.c":   {},
	"pr22061-3.c":    {},

	// Wont'fix: taking address of a label not supported
	"920302-1.c":    {},
	"920501-5.c":    {},
	"990208-1.c":    {},
	"comp-goto-1.c": {},
	"pr70460.c":     {},
	"pr71494.c":     {},

	// Wont'fix: indirect goto statements not supported
	"20040302-1.c": {},
	"20041214-1.c": {},
	"20071210-1.c": {},
	"920501-3.c":   {},
	"920501-4.c":   {},

	// Wont'fix: arguments ... do not match signature ... (missing prototype?)
	"20010122-1.c":       {},
	"20030323-1.c":       {},
	"20030330-1.c":       {},
	"20030811-1.c":       {},
	"20051012-1.c":       {},
	"20080502-1.c":       {},
	"81_types.c":         {},
	"920501-1.c":         {},
	"921202-1.c":         {},
	"921208-2.c":         {},
	"built-in-setjmp.c":  {},
	"builtin-bitops-1.c": {},
	"builtin-constant.c": {},
	"ffs-1.c":            {},
	"ffs-2.c":            {},
	"frame-address.c":    {},
	"pr17377.c":          {},
	"pr19449.c":          {},
	"pr35456.c":          {},
	"pr39228.c":          {},
	"pr47237.c":          {},
	"pr60003.c":          {},
	"pr61725.c":          {},
	"pr64006.c":          {},
	"pr64242.c":          {},
	"pr67037.c":          {},
	"pr68381.c":          {},
	"pr71554.c":          {},
	"pr84169.c":          {},
	"pr85095.c":          {},
	"pr89434.c":          {},

	// Wont'fix: label declarations not supported
	"920415-1.c":    {},
	"920428-2.c":    {},
	"920501-7.c":    {},
	"920721-4.c":    {},
	"930406-1.c":    {},
	"980526-1.c":    {},
	"comp-goto-2.c": {},
	"nestfunc-5.c":  {},
	"nestfunc-6.c":  {},
	"pr24135.c":     {},

	// Wont'fix: case ranges not supported
	"pr34154.c": {},

	// C EXEC FAIL

	"20000914-1.c": {}, // Won't fix: Depends on GCC-specific unsigned enums
	"20021127-1.c": {}, // Won't fix: linker specific resolution order
	"20031003-1.c": {}, // Won't fix: platform specific floating point handling
	"20090113-2.c": {}, // Won't fix: https://g.co/gemini/share/bcd5c858c626
	"970217-1.c":   {}, // Won't fix: unsupported type
	"pr32244-1.c":  {}, // Won't fix: https://g.co/gemini/share/46d2317fe36d
	"pr34971.c":    {}, // Won't fix: https://g.co/gemini/share/46d2317fe36d
	"pr77767.c":    {}, // Won't fix: unsupported type

	// GO EXEC FAIL

	"20101011-1.c": {}, // Won't fix: unsupported signal handling
	"va-arg-14.c":  {}, // Won't fix: artificially complex variadics, not seen in the wild

	"conversion.c": {}, //TODO dtoui fails
	"pr34456.c":    {}, //TODO rework func ptrs

	// ====================================================================

	// "tcc-0.9.27/tests/tests2",
	"73_arm64.c":                  {},
	"76_dollars_in_identifiers.c": {},
	"83_utf8_in_identifiers.c":    {},
	"87_dead_code.c":              {},
	"88_codeopt.c":                {},
	"93_integer_promotion.c":      {},

	// "gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute",
	"20000113-1.c":         {},
	"20000917-1.c":         {},
	"20010325-1.c":         {},
	"20010605-2.c":         {},
	"20010924-1.c":         {},
	"20011113-1.c":         {},
	"20020206-1.c":         {},
	"20020227-1.c":         {},
	"20020314-1.c":         {},
	"20020320-1.c":         {},
	"20020404-1.c":         {},
	"20020411-1.c":         {},
	"20020418-1.c":         {},
	"20020611-1.c":         {},
	"20021113-1.c":         {},
	"20030109-1.c":         {},
	"20030714-1.c":         {},
	"20031201-1.c":         {},
	"20031211-1.c":         {},
	"20040223-1.c":         {},
	"20040307-1.c":         {},
	"20040331-1.c":         {},
	"20040707-1.c":         {},
	"20040709-1.c":         {},
	"20040709-2.c":         {},
	"20041124-1.c":         {},
	"20041201-1.c":         {},
	"20050121-1.c":         {},
	"20050929-1.c":         {},
	"20060929-1.c":         {},
	"20070614-1.c":         {},
	"20080529-1.c":         {},
	"20081117-1.c":         {},
	"20180921-1.c":         {},
	"920501-2.c":           {},
	"920625-1.c":           {},
	"920908-1.c":           {},
	"930513-1.c":           {},
	"931004-10.c":          {},
	"931004-12.c":          {},
	"931004-14.c":          {},
	"931004-2.c":           {},
	"931004-4.c":           {},
	"931004-6.c":           {},
	"931004-8.c":           {},
	"941202-1.c":           {},
	"960416-1.c":           {},
	"960512-1.c":           {},
	"980604-1.c":           {},
	"990326-1.c":           {},
	"991118-1.c":           {},
	"alias-2.c":            {},
	"alias-3.c":            {},
	"alias-4.c":            {},
	"bf-sign-1.c":          {},
	"bf64-1.c":             {},
	"bitfld-3.c":           {},
	"bitfld-4.c":           {},
	"bitfld-6.c":           {},
	"bitfld-7.c":           {},
	"bswap-1.c":            {},
	"builtin-prefetch-1.c": {},
	"builtin-prefetch-2.c": {},
	"builtin-prefetch-3.c": {},
	"builtin-prefetch-4.c": {},
	"builtin-prefetch-5.c": {},
	"builtin-prefetch-6.c": {},
	"complex-1.c":          {},
	"complex-2.c":          {},
	"complex-4.c":          {},
	"complex-5.c":          {},
	"complex-6.c":          {},
	"complex-7.c":          {},
	"compndlit-1.c":        {},
	"const-addr-expr-1.c":  {},
	"lto-tbaa-1.c":         {},
	"pr22098-1.c":          {},
	"pr22098-2.c":          {},
	"pr22098-3.c":          {},
	"pr23324.c":            {},
	"pr28865.c":            {},
	"pr31448-2.c":          {},
	"pr33382.c":            {},
	"pr37780.c":            {},
	"pr38151.c":            {},
	"pr38969.c":            {},
	"pr39339.c":            {},
	"pr42248.c":            {},
	"pr42691.c":            {},
	"pr43784.c":            {},
	"pr43987.c":            {},
	"pr44575.c":            {},
	"pr49390.c":            {},
	"pr49644.c":            {},
	"pr49768.c":            {},
	"pr52979-1.c":          {},
	"pr52979-2.c":          {},
	"pr53084.c":            {},
	"pr54937.c":            {},
	"pr56837.c":            {},
	"pr57568.c":            {},
	"pr58984.c":            {},
	"pr60017.c":            {},
	"pr65215-3.c":          {},
	"pr66556.c":            {},
	"pr68249.c":            {},
	"pr70127.c":            {},
	"pr70602.c":            {},
	"pr71700.c":            {},
	"pr78170.c":            {},
	"pr79737-1.c":          {},
	"pr80692.c":            {},
	"pr81281.c":            {},
	"pr83383.c":            {},
	"pr85331.c":            {},
	"pr85529-1.c":          {},
	"pr88739.c":            {},
	"pr89195.c":            {},
	"pr89826.c":            {},
	"pr90025.c":            {},
	"stdarg-3.c":           {},
	"strct-stdarg-1.c":     {},
	"strct-varg-1.c":       {},
	"struct-ini-2.c":       {},
	"struct-ini-3.c":       {},
	"va-arg-22.c":          {},
	"va-arg-pack-1.c":      {},
	"widechar-3.c":         {},
	"zero-struct-2.c":      {},
}
