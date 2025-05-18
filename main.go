// Copyright 2023 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Command qbecc is a [QBE] based C compiler. (WIP)
//
// [QBE]: https://c9x.me/compile/
package main // import "modernc.org/qbecc"

import (
	"fmt"
	"os"
	"runtime"

	"modernc.org/qbecc/lib"
)

func main() {
	if err := qbecc.NewTask(&qbecc.Options{
		Stdout: os.Stdout,
		Stderr: os.Stderr,
	}, runtime.GOOS, runtime.GOARCH, os.Args...).Main(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
