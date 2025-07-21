// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of the source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package parser

import (
	"sort"
	"strings"
)

func isQBEExported(nm string) bool {
	return strings.HasPrefix(nm, "$") && !strings.HasPrefix(nm, "$.")
}

// RweriteSource returns the source form of nodes using a rewriter.
func RewriteSource(rewriter func(s string) string, nodes ...Node) string {
	var a []tokener
	for _, n := range nodes {
		nodeSource(n, &a)
	}
	sort.Slice(a, func(i, j int) bool { return a[i].Off() < a[j].Off() })
	w := 0
	off := int32(-1)
	for _, v := range a {
		if v.Off() == off {
			continue
		}

		a[w] = v
		w++
		off = v.Off()
	}
	a = a[:w]
	var b strings.Builder
	for _, t := range a {
		b.Write(t.Sep())
		src := string(t.Src())
		// if isQBEExported(src) {
		src = rewriter(src)
		// }
		b.WriteString(src)
	}
	return b.String()
}
