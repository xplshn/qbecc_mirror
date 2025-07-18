// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

//go:build ignore

package main

import (
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

var re *regexp.Regexp

func fail(rc int, s string, args ...any) {
	fmt.Fprintf(os.Stderr, s, args...)
	os.Exit(rc)
}

func main() {
	if len(os.Args) != 2 {
		fail(2, "expected 1 argument")
	}

	re = regexp.MustCompile(os.Args[1])
	b, err := os.ReadFile("log")
	if err != nil {
		fail(1, "%s\n", err)
	}

	a := strings.Split(string(b), "\n")
	for i, v := range a {
		if i != 0 && re.MatchString(v) && strings.Contains(a[i-1], "all_test.go:") {
			f := strings.Fields(a[i-1])
			if base := filepath.Base(f[len(f)-1]); strings.HasSuffix(base, ".c") {
				fmt.Printf("%q: {},\n", base)
			}
		}
	}
}
