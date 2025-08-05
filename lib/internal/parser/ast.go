// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of the source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package parser

import (
	"bytes"
	"encoding/binary"
	"go/token"
	"math"
	"strconv"

	mtoken "modernc.org/token"
)

var (
	_ = []Node{
		(*Token)(nil),
	}
	_ = []tokener{
		Token{},
		Tok{},
	}
)

type tokener interface {
	Off() int32
	IsValid() bool
	Sep() []byte
	Src() []byte
}

// Token is a terminal node of the abstract syntax tree.
type Token struct { // 24 bytes on 64 bit arch
	source *source

	next    int32
	off     int32
	valNext int32
	valOff  int32
}

func (n Token) IsValid() bool { return n.source != nil }

// Position implements Node.
func (n Token) Position() (r token.Position) {
	if n.IsValid() {
		return position(n.source.file, mtoken.Pos(n.off+1))
	}

	return r
}
func (n Token) Off() int32 { return n.off }

func (n Token) Sep() []byte { return n.source.buf[n.off:n.valOff] }

// Src reports the original textual form of n. The result is read only.
func (n Token) Src() []byte { return n.source.buf[n.off:n.next] }

func (n Token) value() []byte {
	if n.source == nil {
		return nil
	}

	if n.valOff == n.valNext {
		return n.Src()
	}

	return n.source.buf[n.valOff:n.valNext]
}

// Name is a Token that represents a name.
type Name Token

// Position implements Node.
func (n Name) Position() token.Position { return Token(n).Position() }

// Name returns the effective name n stands for. The result is read only and it
// includes the sigil in the first byte of the result. This automatically
// separates the namespaces of labels, locals, globals and types.
//
// Names other than gloabls ($name) have the effective value the same as is
// their source form, unchanged.
//
// Global names of the form $"foo" have the effective name `foo`.
func (n Name) Name() []byte { return Token(n).value() }

// Src reports the original textual form of n. The result is read only.
func (n Name) Src() []byte { return n.source.buf[n.off:n.next] }

var (
	dot         = []byte{'.'}
	underscore  = []byte{'_'}
	underscore2 = []byte("__")
)

func (n Name) cname() (r []byte) {
	defer func() {
		r = bytes.ReplaceAll(r, dot, underscore)
		for _, v := range r {
			if v >= 0x80 {
				s := strconv.QuoteToASCII(string(r))
				r = []byte(s[1 : len(s)-1])
				return
			}
		}
	}()

	switch b := n.Name(); b[0] {
	case '$':
		b = b[1:]
		if !isDigit(b[0]) {
			return b
		}

		return append(underscore2, b...)
	default:
		return b
	}
}

// Scope maps names to Nodes.
type Scope struct {
	Nodes map[string]Node
}

func (s *Scope) declare(a *AST, t Name, n Node) {
	if s.Nodes == nil {
		s.Nodes = map[string]Node{}
	}
	nm := t.Name()
	if ex := s.node(t); ex != nil {
		a.errs.err(t.off, 1, "%s redeclared, previous declaration at %v:", t.Src(), ex.Position())
	}

	s.Nodes[string(nm)] = n
}

func (s *Scope) node(n Name) Node { return s.Nodes[string(n.Name())] }

// AST represents the abstract syntax tree.
type AST struct {
	Defs        []Node // A FuncDef, DataDef of a TypeDef.
	EOF         Token
	ExternData  map[string]struct{} // Referenced but not defined.
	ExternFuncs map[string]Type     // Called but not defined. The value is the result type or nil if void.
	Funcs       map[string]Type     // Defined functions. The value is the result type or nil if void.
	Scope       Scope
	cptr        Type
	errs        msgList
	firstSep    []byte
	ptr         Type
	source      *source
	warnings    msgList

	binBuf [binary.MaxVarintLen64]byte
}

func newAST(source *source) *AST {
	var p, c Type
	p = VoidPointer{l}
	c = CharPointer{l}
	return &AST{
		ExternData:  map[string]struct{}{},
		ExternFuncs: map[string]Type{},
		Funcs:       map[string]Type{},
		cptr:        c,
		ptr:         p,
		source:      source,
	}
}

// FirstSeparator reports the white space and comments preceding first token.
// The result must not be modified.
func (a *AST) FirstSeparator() []byte {
	return a.firstSep[:len(a.firstSep):len(a.firstSep)]
}

// Err reports any error encountered during constructing of a.
func (a *AST) Err() error { return a.errs.Err(a.source) }

// Warnings reports any warning encountered during constructing of a.
func (a *AST) Warning() error { return a.warnings.Err(a.source) }

// AST produces the AST version of n or an error, if any.
func (n *CST) AST(os, arch string) (*AST, error) {
	r, err := n.ast()
	if err != nil {
		return nil, err
	}

	return r, nil
}

func (n *CST) ast() (*AST, error) {
	r := newAST(n.source)
	r.firstSep = n.firstSep
	if eof := &n.EOF; eof.source != nil {
		r.EOF.source = eof.source
		r.EOF.off = eof.sepOff
		r.EOF.next = eof.off
	}
	for _, v := range n.Defs {
		r.def(v)
	}
	for _, v := range r.Defs {
		switch x := v.(type) {
		case *DataDef:
			nm := x.Global.Name.cname()
			delete(r.ExternData, string(nm))
			delete(r.ExternFuncs, string(nm))
		case *FuncDef:
			nm := x.Global.Name.cname()
			delete(r.ExternData, string(nm))
			delete(r.ExternFuncs, string(nm))
		}
	}
	for k := range r.ExternFuncs {
		delete(r.ExternData, k)
	}
	return r, r.Err()
}

func (a *AST) name(t *Tok) (r Name) {
	r = Name{
		source: t.source,
		next:   t.next,
		off:    t.off,
	}
	switch t.Ch {
	case GLOBAL:
		if src := t.Src(); src[1] == '"' {
			r.valOff = r.off + 1
			r.valNext = r.next - 1
		}
	case LABEL, TYPENAME, LOCAL:
		// ok
	default:
		a.errs.err(t.off, 0, "internal error: %v", t)
	}
	return r
}

// FuncDef represents a function definition
type FuncDef struct {
	Blocks []*Block // In order of appearance in source code. Read only.
	Global          // $name
	Params []Node
	Result Type
	Scope  Scope
	Map    map[string]*MapInfo

	IsExported bool
	IsVariadic bool
	locals     int
}

func newFuncDef(isExported bool, g Global) *FuncDef {
	return &FuncDef{
		Global:     g,
		IsExported: isExported,
	}
}

func (n *FuncDef) newLocalInfo(nd Node, nm Name, typ Type, rd, wr int) *LocalInfo {
	r := &LocalInfo{N: n.locals, Name: nm, Type: typ, Read: rd, Written: wr}
	_, r.IsStruct = typ.(TypeName)
	n.locals++
	return r
}

func (n *FuncDef) preamble(a *AST, preamble *InstPreambleNode) InstPreamble {
	nm := a.name(&preamble.Dst)
	typ := a.typ(&preamble.Type)
out:
	switch info := n.Scope.node(nm); {
	case info == nil:
		info := n.newLocalInfo(preamble.Dst, nm, typ, 0, 1)
		n.Scope.declare(a, nm, info)
	default:
		info := info.(*LocalInfo)
		info.Written++
		if ex := info.Type; !typ.isCompatible(ex) {
			switch ex {
			case l, w:
				if _, ok := typ.(TypeName); ok {
					break out
				}
			}
			a.errs.err(nm.off, 0, "type of %s (%s) does not match its type at %v (%s):", nm.Name(), typ, info.Position(), ex)
		}
	}
	return InstPreamble{Local{nm}, typ}
}

func (n *FuncDef) phi(a *AST, phi *PhiNode) *Phi {
	r := &Phi{InstPreamble: n.preamble(a, &phi.InstPreambleNode)}
	for _, v := range phi.Args {
		r.Args = append(r.Args, a.phiArg(&v))
	}
	return r
}

func (n *FuncDef) inst(a *AST, inst Node) Node {
	switch x := inst.(type) {
	case *TruncdNode:
		return &Truncd{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
	case *TruncldNode:
		return &Truncld{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
	case *SltofNode:
		return &Sltof{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
	case *VaArgNode:
		va := a.value(x.Val)
		return &VaArg{n.preamble(a, &x.InstPreambleNode), va}
	case *VaStartNode:
		va := a.value(x.Arg)
		return &VaStart{va, x.Inst.off}
	case *DtosiNode:
		return &Dtosi{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
	case *LdtosiNode:
		return &Ldtosi{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
	case *DtouiNode:
		return &Dtoui{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
	case *LdtouiNode:
		return &Ldtoui{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
	case *CastNode:
		return &Cast{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
	case *OrNode:
		return &Or{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
	case *StosiNode:
		return &Stosi{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
	case *StouiNode:
		return &Stoui{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
	case *SwtofNode:
		return &Swtof{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
	case *UltofNode:
		return &Ultof{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
	case *UwtofNode:
		return &Uwtof{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
	case *UdivNode:
		return &Udiv{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
	case *UremNode:
		return &Urem{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
	case *ShlNode:
		return &Shl{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
	case *SarNode:
		return &Sar{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
	case *ShrNode:
		return &Shr{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
	case *DivNode:
		return &Div{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
	case *AndNode:
		return &And{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
	case *XorNode:
		return &Xor{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
	case *ExtNode:
		switch x.InstPreambleNode.Inst.Ch {
		case EXTS:
			return &Exts{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
		case EXTD:
			return &Extd{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
		case EXTSB:
			return &Extsb{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
		case EXTSH:
			return &Extsh{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
		case EXTSW:
			return &Extsw{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
		case EXTUB:
			return &Extub{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
		case EXTUH:
			return &Extuh{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
		case EXTUW:
			return &Extuw{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
		default:
			a.errs.err(x.Dst.off, 0, "internal error: %v", x)
			return nil
		}
	case *RemNode:
		return &Rem{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
	case *MulNode:
		return &Mul{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
	case *CmpNode:
		switch x.InstPreambleNode.Inst.Ch {
		case CEQD:
			return &Ceqd{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CEQL:
			return &Ceql{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CEQS:
			return &Ceqs{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CEQW:
			return &Ceqw{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CGED:
			return &Cged{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CGES:
			return &Cges{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CGTD:
			return &Cgtd{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CGTS:
			return &Cgts{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CLED:
			return &Cled{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CLES:
			return &Cles{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CLTD:
			return &Cltd{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CLTS:
			return &Clts{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CNED:
			return &Cned{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CNEL:
			return &Cnel{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CNES:
			return &Cnes{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CNEW:
			return &Cnew{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CSGEL:
			return &Csgel{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CSGEW:
			return &Csgew{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CSGTL:
			return &Csgtl{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CSGTW:
			return &Csgtw{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CSLEL:
			return &Cslel{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CSLEW:
			return &Cslew{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CSLTL:
			return &Csltl{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CSLTW:
			return &Csltw{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CUGEL:
			return &Cugel{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CUGEW:
			return &Cugew{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CUGTL:
			return &Cugtl{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CUGTW:
			return &Cugtw{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CULEL:
			return &Culel{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CULEW:
			return &Culew{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CULTL:
			return &Cultl{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CULTW:
			return &Cultw{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CUOD:
			return &Cuod{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case CUOS:
			return &Cuos{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case COD:
			return &Cod{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		case COS:
			return &Cos{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
		default:
			a.errs.err(x.Dst.off, 0, "internal error: %v", x)
			return nil
		}
	case *StoreNode:
		switch x.Inst.Ch {
		case STOREL:
			return &Storel{a.value(x.Dst), a.value(x.Src)}
		case STOREB:
			return &Storeb{a.value(x.Dst), a.value(x.Src)}
		case STORED:
			return &Stored{a.value(x.Dst), a.value(x.Src)}
		case STOREH:
			return &Storeh{a.value(x.Dst), a.value(x.Src)}
		case STORES:
			return &Stores{a.value(x.Dst), a.value(x.Src)}
		case STOREW:
			return &Storew{a.value(x.Dst), a.value(x.Src)}
		default:
			a.errs.err(x.Inst.off, 0, "internal error: %v", x)
			return nil
		}
	case *LoadNode:
		switch x.InstPreambleNode.Inst.Ch {
		case LOAD:
			switch x.InstPreambleNode.Type.Ch {
			case L:
				return &Loadl{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
			case W:
				return &Loadsw{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
			case S:
				return &Loads{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
			case D:
				return &Loadd{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
			default:
				a.errs.err(x.Type.off, 0, "internal error: %v", x)
				return nil
			}
		case LOADD:
			return &Loadd{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
		case LOADL:
			return &Loadl{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
		case LOADS:
			return &Loads{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
		case LOADSB:
			return &Loadsb{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
		case LOADSH:
			return &Loadsh{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
		case LOADW, LOADSW:
			// A loadw instruction is provided as syntactic sugar for loadsw to make
			// explicit that the extension mechanism used is irrelevant.
			return &Loadsw{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
		case LOADUB:
			return &Loadub{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
		case LOADUH:
			return &Loaduh{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
		case LOADUW:
			return &Loaduw{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
		default:
			a.errs.err(x.Inst.off, 0, "internal error: %v", x)
			return nil
		}
	case *CallNode:
		var args []Node
		variadic := false
		for _, v := range x.Args {
			switch x := v.(type) {
			case *RegularArgNode:
				args = append(args, &RegularArg{a.typ(&x.Type), a.value(x.Val)})
			case *EnvArgNode:
				args = append(args, &EnvArg{a.value(x.Val)})
			case *VariadicMarkerNode:
				variadic = true
			default:
				a.errs.err(0, 0, "%v: internal error: %v", v.Position(), x)
				return nil
			}
		}
		val := a.value(x.Val)
		if y, ok := val.(Global); ok {
			var typ Type
			if x.InstPreambleNode.Dst.IsValid() {
				typ = a.typ(&x.InstPreambleNode.Type)
			}
			cname := string(y.cname())
			if _, ok := a.ExternFuncs[cname]; !ok {
				a.ExternFuncs[cname] = typ
			}
		}
		switch {
		case x.InstPreambleNode.Dst.IsValid():
			if y, ok := val.(Global); ok {
				if def, ok := a.Scope.node(y.Name).(*FuncDef); ok {
					if def.Result == nil {
						a.errs.err(y.off, 0, "void function result used as value: %s", def.Name.Name())
					}
				}
			}
			return &Call{n.preamble(a, &x.InstPreambleNode), VoidCall{val, args, variadic}}
		default:
			return &VoidCall{a.value(x.Val), args, variadic}
		}
	case *AllocNode:
		va := a.value(x.Val)
		pre := n.preamble(a, &x.InstPreambleNode)
		switch x.Inst.Ch {
		case ALLOC16:
			return &Alloc16{pre, va}
		case ALLOC4:
			return &Alloc4{pre, va}
		case ALLOC8:
			return &Alloc8{pre, va}
		default:
			a.errs.err(x.Inst.off, 0, "internal error: %v", x)
			return nil
		}
	case *AddNode:
		return &Add{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
	case *SubNode:
		return &Sub{n.preamble(a, &x.InstPreambleNode), a.binary(&x.BinaryOperandsNode)}
	case *CopyNode:
		return &Copy{n.preamble(a, &x.InstPreambleNode), a.value(x.Val)}
	case *DeclareNode:
		return &Declare{n.preamble(a, &x.InstPreambleNode)}
	case *PhiNode:
		a.errs.err(x.InstPreambleNode.Dst.off, 1, "phi instructions cannot be preceded by non-phi instructions within a block")
		return n.phi(a, x)
	default:
		a.errs.err(0, 0, "%v: internal error: %v", n.Position(), x)
		return nil
	}
}

// LocalInfo desribes properties of a SSA temporary variable.
type LocalInfo struct {
	N int // Zero-based local number.
	Name
	Read int // Static number of times the local is used as an operand.
	Type
	Written int // Static number of times the local is defined (assigned to). Parameters start with 1.

	IsParameter bool
	IsStruct    bool
}

// RegularParameter represents a regular formal parameter of a function
// definition.
type RegularParameter struct {
	Local // %name
	Type
}

// EnvParameter represents the environmental formal parameter of a function
// definition.
type EnvParameter struct {
	Local
}

// DataDef represents a data definition, static initialized data.
type DataDef struct {
	Align  uintptr // Non zero only if explicitly specified.
	Global         // $name
	Items  []Node
	Size   uintptr // Packed size in bytes.
	Type   Type    // Non-nil iff all items are of the same type.

	IsExported bool
	IsReadOnly bool
}

// StringInitializer is a DataDef item representing a string literal.
type StringInitializer struct {
	StringLit
	Type Type
}

// ZeroInitializer is a DataDef item representing zeroed data.
type ZeroInitializer IntLit

// Position implements Node.
func (n ZeroInitializer) Position() token.Position { return IntLit(n).Position() }

// Size returns the declared size of n in bytes.
func (n ZeroInitializer) Size() uintptr { return uintptr(IntLit(n).Value()) }

// IntInitializer is a DataDef item representing an integer literal.
type IntInitializer struct {
	IntLit
	Type
}

// Float32Initializer is a DataDef item representing a float32 literal.
type Float32Initializer struct {
	Float32Lit
	Type
}

// Float64Initializer is a DataDef item representing a float64 literal.
type Float64Initializer struct {
	Float64Lit
	Type
}

// LongDoubleLitInitializer is a DataDef item representing a long double literal.
type LongDoubleLitInitializer struct {
	LongDoubleLit
	Type
}

// GlobalInitializer is a DataDef item representing the address of a function
// of data definition, with an optional offset.
type GlobalInitializer struct {
	Global // $name
	Offset uintptr
	Type
}

// TypeDef represents a named type.
type TypeDef struct {
	Align    uintptr // Non zero only if explicitly specified.
	Fields   []Node
	TypeName // :name
}

func (t *TypeDef) fields(a *AST, n []Node) (r []Node) {
	for i, v := range n {
		switch x := v.(type) {
		case *FieldNode:
			switch {
			case x.Number.IsValid():
				num := uintptr(a.uint64(&x.Number))
				switch {
				case !x.Type.IsValid():
					if len(r) != 0 || i != len(n)-1 {
						a.errs.err(x.Number.off, 0, "internal error")
					}
					return append(r, UnionField(a.intValue(nil, &x.Number)))
				default:
					r = append(r, ArrayField{Field{a.typ(&x.Type), x.Type.pos()}, num})
				}
			default:
				r = append(r, Field{a.typ(&x.Type), x.Type.pos()})
			}
		case *FieldsNode:
			r = append(r, StructField{t.fields(a, x.Fields), x.LBrace.pos()})
		default:
			a.errs.err(0, 0, "%v: internale error: %T", v.Position(), x)
		}
	}
	return r
}

// UnionField represents an opaque data type.
type UnionField IntLit

// Size returns the declared size of n in bytes.
func (n UnionField) Size() uintptr { return uintptr(IntLit(n).Value()) }

// Position implements Node.
func (n UnionField) Position() token.Position { return IntLit(n).Position() }

// Field represents field type.
type Field struct {
	Type
	pos
}

// ArrayField represents an array-shaped field.
type ArrayField struct {
	Field
	Len uintptr
}

// StructField represents a struct-shaped field.
type StructField struct {
	Fields []Node
	pos
}

func (a *AST) def(n Node) {
	switch x := n.(type) {
	case *TypeDefNode:
		a.newTypeDef(x)
	case *DataDefNode:
		a.newDataDef(x)
	case *FuncDefNode:
		a.newFuncDef(x)
	default:
		a.errs.err(0, 0, "%v: internal error: %T", n.Position(), x)
	}
}

func (a *AST) newTypeDef(n *TypeDefNode) {
	nm := a.name(&n.Name)
	var align uintptr
	if n.Number.IsValid() {
		align = uintptr(a.uint64(&n.Number))
	}
	r := &TypeDef{
		Align:    align,
		TypeName: TypeName{nm},
	}
	a.Scope.declare(a, nm, r)
	r.Fields = r.fields(a, n.Fields.Fields)
	a.Defs = append(a.Defs, r)
}

type singleType struct {
	typ   Type
	valid bool
}

func (s *singleType) set(t Type) {
	switch {
	case s.valid:
		if t != s.typ {
			s.typ = nil
		}
	default:
		s.typ = t
		s.valid = true
	}
}

func (a *AST) newDataDef(n *DataDefNode) {
	nm := a.name(&n.Global)
	var align uintptr
	if n.Number.IsValid() {
		align = uintptr(a.uint64(&n.Number))
	}
	r := &DataDef{
		Align:      align,
		IsExported: n.Linkage.IsValid(),
		Global:     Global{nm},
	}
	a.Scope.declare(a, nm, r)
	var allType singleType
	for _, v := range n.Items {
		switch x := v.(type) {
		case *DataItemZeroNode:
			val := a.intValue(nil, &x.Number)
			r.Items = append(r.Items, ZeroInitializer(val))
			allType.set(b)
			r.Size += uintptr(val.Value())
		case DataItemsNode:
			for _, v := range x.Items {
				switch x := v.(type) {
				case *DataItemGlobalNode:
					typ := a.typ(&x.Type)
					allType.set(typ)
					r.Size += uintptr(typ.size())
					var off uintptr
					if x.Number.IsValid() {
						off = uintptr(a.uint64(&x.Number))
					}
					nm := a.name(&x.Global)
					a.ExternData[string(nm.cname())] = struct{}{}
					r.Items = append(r.Items, GlobalInitializer{Global{a.name(&x.Global)}, off, typ})
				case *DataItemConstNode:
					typ := a.typ(&x.Type)
					allType.set(typ)
					r.Size += uintptr(typ.size())
					switch y := x.Const.(type) {
					case *IntConstNode:
						r.Items = append(r.Items, IntInitializer{a.intValue(&y.Sign, &y.Number), typ})
					//TODO case *CSTFloat32Lit:
					//TODO 	r.Items = append(r.Items, Float32Initializer{a.float32Value((*CSTToken)(y)), typ})
					//TODO case *CSTFloat64Lit:
					//TODO 	r.Items = append(r.Items, Float64Initializer{a.float64Value((*CSTToken)(y)), typ})
					case LongDoubleLitNode:
						r.Items = append(r.Items, LongDoubleLitInitializer{a.longDoubleValue((*Tok)(&y)), typ})
					default:
						a.errs.err(0, 0, "%v: internal error: %T", x.Position(), y)
					}
				case *DataItemStringNode:
					val := a.stringValue(&x.Val)
					r.Size += uintptr(len(val.Value()))
					typ := a.typ(&x.Type)
					allType.set(typ)
					r.Items = append(r.Items, StringInitializer{val, typ})
				default:
					a.errs.err(0, 0, "%v: internal error: %T", v.Position(), x)
				}
			}
		case *Tok:
			switch x.Ch {
			case ',':
				// nop
			default:
				a.errs.err(x.off, 0, "internal error: %v", x)
			}
		default:
			a.errs.err(0, 0, "%v: internal error: %T", v.Position(), x)
		}
	}
	r.Type = allType.typ
	a.Defs = append(a.Defs, r)
}

func (a *AST) newFuncDef(n *FuncDefNode) {
	nm := a.name(&n.Global)
	r := newFuncDef(n.Export.IsValid(), Global{nm})
	a.Scope.declare(a, nm, r)
	if n.ABIType.IsValid() {
		r.Result = a.typ(&n.ABIType)
	}
	a.Funcs[string(nm.cname())] = r.Result
	for _, v := range n.Params {
		switch x := v.(type) {
		case *RegularParamNode:
			nm := a.name(&x.Local)
			typ := a.typ(&x.Type)
			info := r.newLocalInfo(x, nm, typ, 0, 1)
			info.IsParameter = true
			r.Scope.declare(a, nm, info)
			r.Params = append(r.Params, &RegularParameter{Local{nm}, typ})
		case *EnvParamNode:
			nm := a.name(&x.Local)
			info := r.newLocalInfo(x, nm, nil, 0, 1)
			info.IsParameter = true
			r.Scope.declare(a, nm, info)
			r.Params = append(r.Params, &EnvParameter{Local{nm}})
		case *VariadicMarkerNode:
			r.IsVariadic = true
		default:
			a.errs.err(0, 0, "%v: internal error: %T", v.Position(), x)
		}
	}
	for _, v := range n.Blocks {
		r.Blocks = append(r.Blocks, a.block(r, v, len(r.Blocks)))
	}
	a.Defs = append(a.Defs, r)
}

// Label reprents a label name in the form @name.
type Label struct {
	Name
}

// Block is a linear piece of QBE code with a single entry point and a single
// exit point.
type Block struct {
	Label // @name
	Phis  []*Phi
	Insts []Node
	// Jmp, Jnz, Ret or nil indicating fallthrough into the lexically following block.
	Jump Node

	num int32 // Zero based ordinal = index into FuncDef.Blocks
}

func (a *AST) block(f *FuncDef, n *BlockNode, num int) *Block {
	nm := a.name(&n.Label)
	r := &Block{Label: Label{nm}, num: int32(num)}
	f.Scope.declare(a, nm, r)
	for _, v := range n.Phis {
		r.Phis = append(r.Phis, f.phi(a, v))
	}
	for _, v := range n.Insts {
		r.Insts = append(r.Insts, f.inst(a, v))
	}
	r.Jump = a.jump(n.Jump)
	return r
}

// Jnz represents the 'jnz' instruction.
type Jnz struct {
	Value Node
	NZ    Label // @name
	Z     Label // @name
}

// Position implements Node.
func (n Jnz) Position() token.Position { return n.Value.Position() }

// Ret represent the 'ret' instruction.
type Ret struct {
	Value Node
	pos
}

// Jmp represents the 'jmp' instruction.
type Jmp Label // @name

// Position implements Node.
func (n Jmp) Position() token.Position { return Label(n).Position() }

func (a *AST) jump(n Node) Node {
	switch x := n.(type) {
	case *JmpNode:
		return Jmp(Label{a.name(&x.Label)})
	case *RetNode:
		return Ret{a.value(x.Val), x.Inst.pos()}
	case *JnzNode:
		return Jnz{a.value(x.Val), Label{a.name(&x.LabelNZ)}, Label{a.name(&x.LabelZ)}}
	case nil:
		return nil
	default:
		a.errs.err(0, 0, "%v: internal error: %T", n.Position(), x)
		return nil
	}
}

// InstPreamble represents the common part of a 3-address instruction.
type InstPreamble struct {
	Dst     Local // %name
	DstType Type
}

// Position implements Node.
func (n *InstPreamble) Position() token.Position { return n.Dst.Position() }

func (a *AST) typ(t *Tok) Type {
	switch t.Ch {
	case W:
		return w
	case L:
		return l
	case P:
		return a.ptr
	case C:
		return a.cptr
	case S:
		return s
	case D:
		return d
	case B:
		return b
	case H:
		return h
	case TYPENAME:
		return TypeName{a.name(t)}
	default:
		a.errs.err(t.off, 0, "internal error: %v", t)
		return nil
	}
}

// Copy represents the 'copy' instruction.
type Copy struct {
	InstPreamble
	Value Node
}

// Declare represents the 'declare' instruction.
type Declare struct {
	InstPreamble
}

// Binary represents the operands of a binary operation.
type Binary struct {
	A    Node
	B    Node
	foff int32
}

// Sub represents the 'sub' instruction.
type Sub struct {
	InstPreamble
	Binary
}

// Add represents the 'add' instruction.
type Add struct {
	InstPreamble
	Binary
}

// Alloc16 represents the 'alloc16' instruction.
type Alloc16 struct {
	InstPreamble
	Value Node
}

// Alloc4 represents the 'alloc4' instruction.
type Alloc4 struct {
	InstPreamble
	Value Node
}

// Alloc8 represents the 'alloc8' instruction.
type Alloc8 struct {
	InstPreamble
	Value Node
}

// VoidCall represents a call of a void function.
type VoidCall struct {
	Value Node
	Args  []Node

	IsVariadic bool
}

// Position implements Node.
func (n *VoidCall) Position() token.Position { return n.Value.Position() }

// Call represents a call of a non-void function.
type Call struct {
	InstPreamble
	VoidCall
}

// Position implements Node.
func (n *Call) Position() token.Position { return n.Value.Position() }

// RegularArg represents the actual parameter of a function call.
type RegularArg struct {
	Type  Type
	Value Node
}

// Position implements Node.
func (n *RegularArg) Position() token.Position { return n.Value.Position() }

// EnvArg represents the actual environment parameter of a function call.
type EnvArg struct {
	Value Node
}

// Position implements Node.
func (n *EnvArg) Position() token.Position { return n.Value.Position() }

// Loadd represents the 'loadd' instruction.
type Loadd struct {
	InstPreamble
	Value Node
}

// Loadld represents the 'loadld' instruction.
type Loadld struct {
	InstPreamble
	Value Node
}

// Loads represents the 'loads' instruction.
type Loads struct {
	InstPreamble
	Value Node
}

// Loadsb represents the 'loadsb' instruction.
type Loadsb struct {
	InstPreamble
	Value Node
}

// Loadsh represents the 'loadsh' instruction.
type Loadsh struct {
	InstPreamble
	Value Node
}

// Loadsw represents the 'loadsw' and 'loadw' instructions.
type Loadsw struct {
	InstPreamble
	Value Node
}

// Loadl represents the 'loadl' instruction.
type Loadl struct {
	InstPreamble
	Value Node
}

// Loadub represents the 'loadub' instruction.
type Loadub struct {
	InstPreamble
	Value Node
}

// Loaduh represents the 'loaduh' instruction.
type Loaduh struct {
	InstPreamble
	Value Node
}

// Loaduw represents the 'loaduw' instruction.
type Loaduw struct {
	InstPreamble
	Value Node
}

// Storel represents the 'storel' instruction.
type Storel struct {
	Dst Node
	Src Node
}

// Position implements Node.
func (n *Storel) Position() token.Position { return n.Dst.Position() }

// Storeb represents the 'storeB' instruction.
type Storeb struct {
	Dst Node
	Src Node
}

// Position implements Node.
func (n *Storeb) Position() token.Position { return n.Dst.Position() }

// Storeh represents the 'storeh' instruction.
type Storeh struct {
	Dst Node
	Src Node
}

// Position implements Node.
func (n *Storeh) Position() token.Position { return n.Dst.Position() }

// Storew represents the 'storew' instruction.
type Storew struct {
	Dst Node
	Src Node
}

// Position implements Node.
func (n *Storew) Position() token.Position { return n.Dst.Position() }

// Stored represents the 'stored' instruction.
type Stored struct {
	Dst Node
	Src Node
}

// Position implements Node.
func (n *Stored) Position() token.Position { return n.Dst.Position() }

// Storeld represents the 'storeld' instruction.
type Storeld struct {
	Dst Node
	Src Node
}

// Position implements Node.
func (n *Storeld) Position() token.Position { return n.Dst.Position() }

// Stores represents the 'stores' instruction.
type Stores struct {
	Dst Node
	Src Node
}

// Position implements Node.
func (n *Stores) Position() token.Position { return n.Dst.Position() }

// Ceqd represents the 'ceqd' instruction.
type Ceqd struct {
	InstPreamble
	Binary
}

// Ceqld represents the 'ceqld' instruction.
type Ceqld struct {
	InstPreamble
	Binary
}

// Ceqs represents the 'ceqs' instruction.
type Ceqs struct {
	InstPreamble
	Binary
}

// Ceql represents the 'ceql' instruction.
type Ceql struct {
	InstPreamble
	Binary
}

// Ceqw represents the 'ceqw' instruction.
type Ceqw struct {
	InstPreamble
	Binary
}

// Cged represents the 'cged' instruction.
type Cged struct {
	InstPreamble
	Binary
}

// Cgeld represents the 'cgeld' instruction.
type Cgeld struct {
	InstPreamble
	Binary
}

// Cges represents the 'cges' instruction.
type Cges struct {
	InstPreamble
	Binary
}

// Cgtd represents the 'cgtd' instruction.
type Cgtd struct {
	InstPreamble
	Binary
}

// Cgtld represents the 'cgtld' instruction.
type Cgtld struct {
	InstPreamble
	Binary
}

// Cgts represents the 'cgts' instruction.
type Cgts struct {
	InstPreamble
	Binary
}

// Cled represents the 'cled' instruction.
type Cled struct {
	InstPreamble
	Binary
}

// Cleld represents the 'cleld' instruction.
type Cleld struct {
	InstPreamble
	Binary
}

// Cles represents the 'cles' instruction.
type Cles struct {
	InstPreamble
	Binary
}

// Cltd represents the 'cltd' instruction.
type Cltd struct {
	InstPreamble
	Binary
}

// Cltld represents the 'cltld' instruction.
type Cltld struct {
	InstPreamble
	Binary
}

// Clts represents the 'clts' instruction.
type Clts struct {
	InstPreamble
	Binary
}

// Cned represents the 'cned' instruction.
type Cned struct {
	InstPreamble
	Binary
}

// Cneld represents the 'cneld' instruction.
type Cneld struct {
	InstPreamble
	Binary
}

// Cnes represents the 'cnes' instruction.
type Cnes struct {
	InstPreamble
	Binary
}

// Cnel represents the 'cnel' instruction.
type Cnel struct {
	InstPreamble
	Binary
}

// Cnew represents the 'cnew' instruction.
type Cnew struct {
	InstPreamble
	Binary
}

// Csgel represents the 'csgel' instruction.
type Csgel struct {
	InstPreamble
	Binary
}

// Csgew represents the 'csgew' instruction.
type Csgew struct {
	InstPreamble
	Binary
}

// Csgtl represents the 'csgtl' instruction.
type Csgtl struct {
	InstPreamble
	Binary
}

// Csgtw represents the 'csgtw' instruction.
type Csgtw struct {
	InstPreamble
	Binary
}

// Cslel represents the 'cslel' instruction.
type Cslel struct {
	InstPreamble
	Binary
}

// Cslew represents the 'cslew' instruction.
type Cslew struct {
	InstPreamble
	Binary
}

// Csltl represents the 'csltl' instruction.
type Csltl struct {
	InstPreamble
	Binary
}

// Csltw represents the 'csltw' instruction.
type Csltw struct {
	InstPreamble
	Binary
}

// Cugel represents the 'cugel' instruction.
type Cugel struct {
	InstPreamble
	Binary
}

// Cugew represents the 'cugew' instruction.
type Cugew struct {
	InstPreamble
	Binary
}

// Cugtl represents the 'cugtl' instruction.
type Cugtl struct {
	InstPreamble
	Binary
}

// Cugtw represents the 'cugtw' instruction.
type Cugtw struct {
	InstPreamble
	Binary
}

// Culel represents the 'culel' instruction.
type Culel struct {
	InstPreamble
	Binary
}

// Culew represents the 'culew' instruction.
type Culew struct {
	InstPreamble
	Binary
}

// Cultl represents the 'cultl' instruction.
type Cultl struct {
	InstPreamble
	Binary
}

// Cultw represents the 'cultw' instruction.
type Cultw struct {
	InstPreamble
	Binary
}

// Cuod represents the 'cuod' instruction.
type Cuod struct {
	InstPreamble
	Binary
}

// Cuos represents the 'cuos' instruction.
type Cuos struct {
	InstPreamble
	Binary
}

// Cod represents the 'cod' instruction.
type Cod struct {
	InstPreamble
	Binary
}

// Cos represents the 'cos' instruction.
type Cos struct {
	InstPreamble
	Binary
}

// Mul represents the 'mul' instruction.
type Mul struct {
	InstPreamble
	Binary
}

// Rem represents the 'rem' instruction.
type Rem struct {
	InstPreamble
	Binary
}

// Stosi represents the 'stosi' instruction.
type Stosi struct {
	InstPreamble
	Value Node
}

// Stoui represents the 'stoui' instruction.
type Stoui struct {
	InstPreamble
	Value Node
}

// Exts represents the 'exts' instruction.
type Exts struct {
	InstPreamble
	Value Node
}

// Extd represents the 'extd' instruction.
type Extd struct {
	InstPreamble
	Value Node
}

// Extsb represents the 'extsb' instruction.
type Extsb struct {
	InstPreamble
	Value Node
}

// Extsh represents the 'extsh' instruction.
type Extsh struct {
	InstPreamble
	Value Node
}

// Extsw represents the 'extsw' instruction.
type Extsw struct {
	InstPreamble
	Value Node
}

// Extub represents the 'extub' instruction.
type Extub struct {
	InstPreamble
	Value Node
}

// Extuh represents the 'extuh' instruction.
type Extuh struct {
	InstPreamble
	Value Node
}

// Extuw represents the 'extuw' instruction.
type Extuw struct {
	InstPreamble
	Value Node
}

// Xor represents the 'xor' instruction.
type Xor struct {
	InstPreamble
	Binary
}

// And represents the 'and' instruction.
type And struct {
	InstPreamble
	Binary
}

// Div represents the 'div' instruction.
type Div struct {
	InstPreamble
	Binary
}

// Sar represents the 'sar' instruction.
type Sar struct {
	InstPreamble
	Binary
}

// Shl represents the 'shl' instruction.
type Shl struct {
	InstPreamble
	Binary
}

// Urem represents the 'urem' instruction.
type Urem struct {
	InstPreamble
	Binary
}

// Udiv represents the 'udiv' instruction.
type Udiv struct {
	InstPreamble
	Binary
}

// Shr represents the 'shr' instruction.
type Shr struct {
	InstPreamble
	Binary
}

// Or represents the 'or' instruction.
type Or struct {
	InstPreamble
	Binary
}

// Cast represents the 'cast' instruction.
type Cast struct {
	InstPreamble
	Value Node
}

// VaStart represents the 'vastart' instruction.
type VaStart struct {
	Value Node
	off   int32
}

// Position implements Node.
func (n VaStart) Position() token.Position { return n.Value.Position() }

// VaArg represents the 'vaarg' instruction.
type VaArg struct {
	InstPreamble
	Value Node
}

// Swtof represents the 'swtof' instruction.
type Swtof struct {
	InstPreamble
	Value Node
}

// Ultof represents the 'ultof' instruction.
type Ultof struct {
	InstPreamble
	Value Node
}

// Uwtof represents the 'uwtof' instruction.
type Uwtof struct {
	InstPreamble
	Value Node
}

// Ldtosi represents the 'ldtosi' instruction.
type Ldtosi struct {
	InstPreamble
	Value Node
}

// Dtosi represents the 'dtosi' instruction.
type Dtosi struct {
	InstPreamble
	Value Node
}

// Ldtoui represents the 'ldtoui' instruction.
type Ldtoui struct {
	InstPreamble
	Value Node
}

// Dtoui represents the 'dtoui' instruction.
type Dtoui struct {
	InstPreamble
	Value Node
}

// Sltof represents the 'sltof' instruction.
type Sltof struct {
	InstPreamble
	Value Node
}

// Truncd represents the 'truncd' instruction.
type Truncd struct {
	InstPreamble
	Value Node
}

// Truncld represents the 'truncld' instruction.
type Truncld struct {
	InstPreamble
	Value Node
}

// IntLit represents a integer literal.
type IntLit Token

// Position implements Node.
func (n IntLit) Position() token.Position { return Token(n).Position() }

// Value return the number n stands for.
func (n IntLit) Value() uint64 {
	if n.valOff == n.valNext {
		return 0
	}

	switch r, ln := binary.Uvarint(Token(n).value()); {
	case ln < 0:
		panic(todo("%v: internal error: %v", n.Position(), ln))
	default:
		return r
	}
}

// StringLit represents a string literal.
type StringLit Token

// Position implements Node.
func (n StringLit) Position() token.Position { return Token(n).Position() }

// Value returns the unquoted value of n.
func (n StringLit) Value() []byte { return n.source.buf[n.valOff:n.valNext] }

// Local represents a SSA temporary variable name of the form %name.
type Local struct {
	Name
}

// Global represents an address of a function or data definition of the form
// $name.
type Global struct {
	Name
}

func (a *AST) value(n Node) Node {
	switch x := n.(type) {
	case *IntConstNode:
		return a.intValue(&x.Sign, &x.Number)
	case *Tok:
		switch x.Ch {
		case FLOAT32_LIT:
			return a.float32Value(x)
		case FLOAT64_LIT:
			return a.float64Value(x)
		case LONG_DOUBLE_LIT:
			return a.longDoubleValue(x)
		case STRING_LIT:
			return a.stringValue(x)
		case GLOBAL:
			nm := a.name(x)
			a.ExternData[string(nm.cname())] = struct{}{}
			return Global{nm}
		case LOCAL:
			return Local{a.name(x)}
		case INT_LIT:
			return a.intValue(nil, x)
		default:
			a.errs.err(x.off, 0, "internal error: %T", x)
			return nil
		}
	case nil:
		return nil
	default:
		a.errs.err(0, 0, "%v: internal error: %T", n.Position(), x)
		return nil
	}
}

// Float32Lit represents a float32 literal.
type Float32Lit struct {
	Token
}

// Value returns the float32 value represented by n.
func (n Float32Lit) Value() float32 {
	if n.valOff == n.valNext {
		return 0
	}

	switch r, ln := binary.Uvarint(n.value()); {
	case ln < 0:
		panic(todo("%v: internal error: %v", n.Position(), ln))
	default:
		return math.Float32frombits(uint32(r))
	}
}

func (a *AST) float32Value(t *Tok) Float32Lit {
	const tag = "s_"
	n, err := strconv.ParseFloat(string(t.Src()[len(tag):]), 32)
	if err != nil {
		a.errs.err(t.off, 0, "%s", err)
	}
	r := Float32Lit{Token{source: t.source, off: t.off, next: t.next}}
	switch {
	case n == 0:
		// nop
	default:
		ln := binary.PutUvarint(a.binBuf[:], uint64(math.Float32bits(float32(n))))
		r.valOff, r.valNext = a.alloc(a.binBuf[:ln])
	}
	return r
}

// LongDoubleLit represents a long double literal.
type LongDoubleLit Token

// Position implements Node.
func (n LongDoubleLit) Position() token.Position { return Token(n).Position() }

// Value returns the long double value represented by n.
func (n LongDoubleLit) Value() string { return string(Token(n).value()) }

func (a *AST) longDoubleValue(t *Tok) (r LongDoubleLit) {
	const tag = "ld_"
	s := string(t.Src()[len(tag):])
	switch s {
	case "nan":
		panic(todo(""))
	case "inf":
		panic(todo(""))
	case "-inf":
		panic(todo(""))
	default:
		r = LongDoubleLit(Token{source: t.source, off: t.off, next: t.next})
		r.valOff, r.valNext = a.alloc([]byte(s))
	}
	return r
}

// Float64Lit represents a float64 literal.
type Float64Lit struct {
	Token
}

// Value returns the float64 value represented by n.
func (n Float64Lit) Value() float64 {
	if n.valOff == n.valNext {
		return 0
	}

	switch r, ln := binary.Uvarint(n.value()); {
	case ln < 0:
		panic(todo("%v: internal error: %v", n.Position(), ln))
	default:
		return math.Float64frombits(r)
	}
}

func (a *AST) float64Value(t *Tok) Float64Lit {
	const tag = "d_"
	n, err := strconv.ParseFloat(string(t.Src()[len(tag):]), 64)
	if err != nil {
		a.errs.err(t.off, 0, "%s", err)
	}
	r := Float64Lit{Token{source: t.source, off: t.off, next: t.next}}
	switch {
	case n == 0:
		// nop
	default:
		ln := binary.PutUvarint(a.binBuf[:], math.Float64bits(n))
		r.valOff, r.valNext = a.alloc(a.binBuf[:ln])
	}
	return r
}

func (a *AST) stringValue(t *Tok) StringLit {
	s, err := strconv.Unquote(string(t.Src()))
	if err != nil {
		a.errs.err(t.off, 0, "%s", err)
	}
	r := StringLit{source: t.source, off: t.off, next: t.next}
	r.valOff, r.valNext = a.alloc([]byte(s))
	return r
}

func (a *AST) uint64(t *Tok) uint64 {
	n, err := strconv.ParseUint(string(t.Src()), 10, 64)
	if err != nil {
		a.errs.err(t.off, 0, "%s", err)
	}
	return n
}

func (a *AST) intValue(sign, t *Tok) IntLit {
	neg := sign != nil && sign.IsValid()
	n, err := strconv.ParseUint(string(t.Src()), 10, 64)
	if err != nil {
		a.errs.err(t.off, 0, "%s", err)
	}
	if neg {
		n = -n
	}
	r := IntLit{source: t.source, off: t.off, next: t.next}
	switch {
	case n == 0:
		// nop
	default:
		ln := binary.PutUvarint(a.binBuf[:], n)
		r.valOff, r.valNext = a.alloc(a.binBuf[:ln])
	}
	return r
}

func (a *AST) alloc(b []byte) (off, next int32) {
	off = int32(len(a.source.buf))
	a.source.buf = append(a.source.buf, b...)
	return off, int32(len(a.source.buf))
}

func (a *AST) binary(n *BinaryOperandsNode) Binary {
	return Binary{a.value(n.A), a.value(n.B), n.Comma.off}
}

// PhiArg represents an argument of a 'phi' instruction.
type PhiArg struct {
	Label
	Value Node
}

func (a *AST) phiArg(n *PhiArgNode) PhiArg {
	return PhiArg{Label{a.name(&n.Label)}, a.value(n.Val)}
}

// Phi represents the 'phi' instruction.
type Phi struct {
	InstPreamble
	Args []PhiArg
}
