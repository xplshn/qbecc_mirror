// Copyright 2023 The qbecc Authors. All rights reserved.
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
	"strings"
	"time"
)

// origin returns caller's short position, skipping skip frames.
//
//lint:ignore U1000 debug helper
func origin(skip int) string {
	pc, fn, fl, _ := runtime.Caller(skip)
	f := runtime.FuncForPC(pc)
	var fns string
	if f != nil {
		fns = f.Name()
		if x := strings.LastIndex(fns, "."); x > 0 {
			fns = fns[x+1:]
		}
		if strings.HasPrefix(fns, "func") {
			num := true
			for _, c := range fns[len("func"):] {
				if c < '0' || c > '9' {
					num = false
					break
				}
			}
			if num {
				return origin(skip + 2)
			}
		}
	}
	return fmt.Sprintf("%s:%d:%s", filepath.Base(fn), fl, fns)
}

// todo prints and return caller's position and an optional message tagged with TODO. Output goes to stderr.
//
//lint:ignore U1000 debug helper
func todo(s string, args ...interface{}) string {
	switch {
	case s == "":
		s = fmt.Sprintf(strings.Repeat("%v ", len(args)), args...)
	default:
		s = fmt.Sprintf(s, args...)
	}
	r := fmt.Sprintf("%s\n\tTODO %s", origin(2), s)
	// fmt.Fprintf(os.Stderr, "%s\n", r)
	// os.Stdout.Sync()
	return r
}

// trc prints and return caller's position and an optional message tagged with TRC. Output goes to stderr.
//
//lint:ignore U1000 debug helper
func trc(s string, args ...interface{}) string {
	switch {
	case s == "":
		s = fmt.Sprintf(strings.Repeat("%v ", len(args)), args...)
	default:
		s = fmt.Sprintf(s, args...)
	}
	r := fmt.Sprintf("%s: TRC %s", origin(2), s)
	fmt.Fprintf(os.Stderr, "%s\n", r)
	os.Stderr.Sync()
	return r
}

// errorf constructs an error value. If extendedErrors is true, the error will
// contain its origin.
func errorf(extendedErrors bool, s string, args ...interface{}) error {
	switch {
	case s == "":
		s = fmt.Sprintf(strings.Repeat("%v ", len(args)), args...)
	default:
		s = fmt.Sprintf(s, args...)
	}
	if dmesgs {
		dmesg("ERRORF: %s (%v: %v: %v: %v: %v: %v:)", s, origin(7), origin(6), origin(5), origin(4), origin(3), origin(2))
	}
	switch {
	case extendedErrors:
		return fmt.Errorf("%s (%v: %v: %v: %v: %v: %v:)", s, origin(7), origin(6), origin(5), origin(4), origin(3), origin(2))
	default:
		return fmt.Errorf("%s", s)
	}
}

func osexec(timeout time.Duration, cmd string, args ...string) (stdout, stderr []byte, err error) {
	ctx, cancel := context.WithTimeout(context.Background(), timeout)

	defer cancel()

	c := exec.CommandContext(ctx, cmd, args...)
	c.WaitDelay = 5 * time.Second
	var outBuf, errBuf bytes.Buffer
	c.Stdout = &outBuf
	c.Stderr = &errBuf
	err = c.Run()
	return outBuf.Bytes(), errBuf.Bytes(), err
}

// func defaultStr(s, dflt string) string {
// 	if s != "" {
// 		return s
// 	}
//
// 	return dflt
// }
