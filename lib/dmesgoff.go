// Copyright 2023 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

//go:build !qbecc.dmesg
// +build !qbecc.dmesg

package qbecc // import "modernc.org/qbecc/lib"

//lint:ignore U1000 debug support
const dmesgs = false

//lint:ignore U1000 debug support
func dmesg(s string, args ...interface{}) {}
