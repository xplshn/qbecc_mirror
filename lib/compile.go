// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"modernc.org/cc/v4"
)

// fn is .c or .h
func (t *Task) sourcesFor(cfg *cc.Config, fn string) (r []cc.Source, err error) {
	r = []cc.Source{
		{Name: "<predefined>", Value: cfg.Predefined + predefined},
		{Name: "<builtin>", Value: builtin},
	}
	return append(r, cc.Source{Name: fn}), nil
}

// fn is .c or .h
func (t *Task) compile(fn string) error {
	panic(todo(""))
}
