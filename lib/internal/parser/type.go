// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of the source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package parser

var (
	_ = []Type{
		CharPointer{},
		Float32{},
		Float64{},
		Int16{},
		Int32{},
		Int64{},
		Int8{},
		TypeName{},
		VoidPointer{},
	}

	b Type = Int8{}
	d Type = Float64{}
	h Type = Int16{}
	l Type = Int64{}
	s Type = Float32{}
	w Type = Int32{}
)

// Type represents a QBE type.
type Type interface {
	String() string
	isCompatible(Type) bool
	size() uintptr // In bytes.
}

// Int8 represents type 'b'.
type Int8 struct{}

func (t Int8) String() string           { return "b" }
func (t Int8) isCompatible(u Type) bool { return t == u }
func (t Int8) size() uintptr            { return 1 }

// Int16 represents type 'h'.
type Int16 struct{}

func (t Int16) String() string           { return "h" }
func (t Int16) isCompatible(u Type) bool { return t == u }
func (t Int16) size() uintptr            { return 2 }

// Int32 represents type 'w'.
type Int32 struct{}

func (t Int32) String() string { return "w" }
func (t Int32) size() uintptr  { return 4 }

func (t Int32) isCompatible(u Type) bool {
	switch x := u.(type) {
	case CharPointer:
		return t.isCompatible(x.Type)
	case VoidPointer:
		return t.isCompatible(x.Type)
	default:
		return t == u
	}
}

// Int64 represents type 'l'.
type Int64 struct{}

func (Int64) String() string { return "l" }
func (Int64) size() uintptr  { return 8 }

func (t Int64) isCompatible(u Type) bool {
	switch x := u.(type) {
	case CharPointer:
		return t.isCompatible(x.Type)
	case VoidPointer:
		return t.isCompatible(x.Type)
	default:
		return t == u
	}
}

type CharPointer struct {
	Type
}

func (t CharPointer) String() string           { return "c" }
func (t CharPointer) isCompatible(u Type) bool { return t.Type.isCompatible(u) }

type VoidPointer struct {
	Type
}

func (t VoidPointer) String() string           { return "p" }
func (t VoidPointer) isCompatible(u Type) bool { return t.Type.isCompatible(u) }

// Float32 represents type 's'.
type Float32 struct{}

func (t Float32) String() string           { return "s" }
func (t Float32) isCompatible(u Type) bool { return t == u }
func (r Float32) size() uintptr            { return 4 }

// Float64 represents type 'd'.
type Float64 struct{}

func (t Float64) String() string           { return "d" }
func (t Float64) isCompatible(u Type) bool { return t == u }
func (t Float64) size() uintptr            { return 8 }

// TypeName represents a named type of the form :name.
type TypeName struct {
	Name
}

func (t TypeName) String() string           { return string(t.Name.Src()) }
func (t TypeName) isCompatible(u Type) bool { return t == u }
func (t TypeName) size() uintptr            { panic(todo("")) }
