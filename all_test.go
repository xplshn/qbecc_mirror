// Copyright 2023 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package main // import "modernc.org/qbecc"

import (
	"os"
	"testing"
)

//lint:ignore U1000 debug helper
func use(...interface{}) {}

// ============================================================================

func TestMain(m *testing.M) {
	rc := m.Run()
	os.Exit(rc)
}

func Test(t *testing.T) {
	t.Logf("TODO")
}
