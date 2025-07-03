// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of the source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package parser

import (
	"go/token"
	"reflect"
	"sort"
	"strings"
)

var (
	_ = []Node{
		(*AddNode)(nil),
		(*AllocNode)(nil),
		(*AndNode)(nil),
		(*BlitNode)(nil),
		(*BlockNode)(nil),
		(*CallNode)(nil),
		(*CastNode)(nil),
		(*CmpNode)(nil),
		(*CopyNode)(nil),
		(*DataDefNode)(nil),
		(*DataItemGlobalNode)(nil),
		(*DataItemZeroNode)(nil),
		(*DataItemsNode)(nil),
		(*DivNode)(nil),
		(*DtosiNode)(nil),
		(*DtouiNode)(nil),
		(*EnvArgNode)(nil),
		(*EnvParamNode)(nil),
		(*ExtNode)(nil),
		(*FieldNode)(nil),
		(*FieldsNode)(nil),
		(*FuncDefNode)(nil),
		(*InstPreambleNode)(nil),
		(*IntConstNode)(nil),
		(*ThreadVarNode)(nil),
		(*JmpNode)(nil),
		(*JnzNode)(nil),
		(*LoadNode)(nil),
		(*MulNode)(nil),
		(*OrNode)(nil),
		(*PhiNode)(nil),
		(*RegularArgNode)(nil),
		(*RegularParamNode)(nil),
		(*RemNode)(nil),
		(*RetNode)(nil),
		(*SarNode)(nil),
		(*ShlNode)(nil),
		(*ShrNode)(nil),
		(*SltofNode)(nil),
		(*StoreNode)(nil),
		(*StosiNode)(nil),
		(*StouiNode)(nil),
		(*SubNode)(nil),
		(*SwtofNode)(nil),
		(*TruncdNode)(nil),
		(*TruncldNode)(nil),
		(*TypeDefNode)(nil),
		(*UdivNode)(nil),
		(*UremNode)(nil),
		(*UwtofNode)(nil),
		(*VaArgNode)(nil),
		(*VaStartNode)(nil),
		(*VariadicMarkerNode)(nil),
		(*XorNode)(nil),
	}
)

// CST represents the complete syntax tree. It contains all the tokens of the
// input. The original source, or any part of it can be reconstructed from the
// CST or some part of it, including the original whitespace/comments.
type CST struct {
	Defs     []Node
	EOF      Tok
	source   *source
	firstSep []byte
}

// FirstSeparator reports the white space and comments preceding first token.
// The result must not be modified.
func (n *CST) FirstSeparator() []byte {
	return n.firstSep[:len(n.firstSep):len(n.firstSep)]
}

// Parse produces a CST or an error, of any. Positions are reported as if buf
// is coming from a file named name. The buffer becomes owned by the CST and
// must not be modified after calling Parse.
func Parse(buf []byte, name string, allErrros bool) (*CST, error) {
	p, err := newParser(buf, name, allErrros)
	if err != nil {
		return nil, err
	}

	r, err := p.parse()
	if err != nil {
		return nil, err
	}

	r.firstSep = p.firstSep
	r.EOF = p.Scanner.Tok
	return r, nil
}

type parser struct {
	*Scanner
	firstSep []byte
	tok      Tok
}

func newParser(buf []byte, name string, allErrros bool) (*parser, error) {
	s, err := NewScanner(buf, name, allErrros)
	if err != nil {
		return nil, err
	}

	return &parser{Scanner: s}, nil
}

func (p *parser) ch() Ch           { return p.tok.Ch }
func (p *parser) consume() (r Tok) { defer p.next(); return p.tok }
func (p *parser) next() Ch         { p.Scan(); p.tok = p.Scanner.Tok; return p.ch() }

func (p *parser) must(ch Ch) Tok {
	if p.ch() != ch {
		p.err(p.tok.off, 1, "expected %#U", ch)
	}
	defer p.next()
	return p.tok
}

func (p *parser) parse() (*CST, error) {
	p.next()
	p.firstSep = p.tok.Sep()
	r := &CST{source: p.source}
	for {
		switch p.ch() {
		case FUNCTION:
			r.Defs = append(r.Defs, p.funcDef(Tok{}))
		case eof:
			return r, p.Err()
		case EXPORT:
			linkage := p.consume()
			switch p.ch() {
			case FUNCTION:
				r.Defs = append(r.Defs, p.funcDef(linkage))
			case DATA:
				r.Defs = append(r.Defs, p.dataDef(linkage))
			default:
				p.err(p.tok.off, 0, "expected function or data")
				p.consume()
			}
		case THREAD:
			linkage := p.consume()
			switch p.ch() {
			case DATA:
				r.Defs = append(r.Defs, p.dataDef(linkage))
			default:
				p.err(p.tok.off, 0, "expected data")
				p.consume()
			}
		case DATA:
			r.Defs = append(r.Defs, p.dataDef(Tok{}))
		case TYPE:
			r.Defs = append(r.Defs, p.typeDef())
		default:
			p.err(p.tok.off, 0, "expected export, function, ro, data or type")
			p.consume()
		}
	}
}

// TypeDefNode is a CST node for:
//
//	TYPEDEF :=
//	    # Regular type
//	    'type' :IDENT '=' ['align' NUMBER]
//	    '{'
//	        ( SUBTY [NUMBER] ),
//	    '}'
//	  | # Opaque type
//	    'type' :IDENT '=' 'align' NUMBER '{' NUMBER '}'
//
//	SUBTY := EXTTY | :IDENT
type TypeDefNode struct {
	Type   Tok
	Name   Tok
	Eq     Tok
	Align  Tok
	Number Tok
	Fields *FieldsNode
}

// Position implements Node.
func (n *TypeDefNode) Position() token.Position { return n.Type.Position() }

func (p *parser) typeDef() Node {
	r := &TypeDefNode{
		Type: p.must(TYPE),
		Name: p.must(TYPENAME),
		Eq:   p.must('='),
	}
	hasAlign := false
	if p.ch() == ALIGN {
		r.Align = p.consume()
		r.Number = p.must(INT_LIT)
		hasAlign = true
	}
	r.Fields = p.fields(hasAlign)
	return r
}

// FieldNode is a Node representing a field of a TypeDef.
type FieldNode struct {
	Type   Tok
	Number Tok
	Comma  Tok
}

// Position implements Node.
func (n *FieldNode) Position() token.Position { return n.Type.Position() }

// FieldsNode is a CST node for the fields of a TypeDef.
type FieldsNode struct {
	LBrace Tok
	Fields []Node
	RBrace Tok
}

// Position implements Node.
func (n *FieldsNode) Position() token.Position { return n.LBrace.Position() }

func (p *parser) fields(acceptOpaqueType bool) *FieldsNode {
	r := &FieldsNode{LBrace: p.must('{')}
	for {
		var typ Tok
		switch p.ch() {
		case L, W, S, D, B, H, TYPENAME: // SUBTY
			typ = p.consume()
		case '}':
			r.RBrace = p.consume()
			return r
		case INT_LIT:
			if !acceptOpaqueType {
				p.err(p.tok.off, 0, "unexpected opaque type")
			}

			if len(r.Fields) != 0 {
				p.err(p.tok.off, 0, "opaque type can specify only one number")
			}

			r.Fields = append(r.Fields, &FieldNode{Number: p.consume()})
			r.RBrace = p.must('}')
			return r
		case '{':
			r.Fields = append(r.Fields, p.fields(false))
			continue
		default:
			p.err(p.tok.off, 0, "syntax error, unexpected %#U", p.ch())
			p.consume()
			return r
		}

		m := &FieldNode{Type: typ}
		if p.ch() == INT_LIT {
			m.Number = p.consume()
		}

		switch p.ch() {
		case ',':
			m.Comma = p.consume()
			r.Fields = append(r.Fields, m)
		case '}':
			r.RBrace = p.consume()
			r.Fields = append(r.Fields, m)
			return r
		default:
			p.err(p.tok.off, 0, "syntax error, unexpected %#U", p.ch())
			p.consume()
			return r
		}
	}
}

// FuncDefNode is a CST node for:
//
//	FUNCDEF :=
//	    ['export'] 'function' [ABITY] $IDENT '(' (PARAM), ')'
//	    '{'
//	       BLOCK+
//	    '}'
type FuncDefNode struct {
	Export   Tok
	Function Tok
	ABIType  Tok
	Global   Tok
	LParen   Tok
	Params   []Node
	RParen   Tok
	LBrace   Tok
	Blocks   []*BlockNode
	RBrace   Tok
}

type MapInfo struct {
	To   string
	More string
}

// Position implements Node.
func (n *FuncDefNode) Position() token.Position {
	if n.Export.IsValid() {
		return n.Export.Position()
	}

	return n.Function.Position()
}

func (p *parser) funcDef(export Tok) (r *FuncDefNode) {
	return &FuncDefNode{
		Export:   export,
		Function: p.consume(),
		ABIType:  p.abiTypeOpt(),
		Global:   p.must(GLOBAL),
		LParen:   p.must('('),
		Params:   p.params(),
		RParen:   p.must(')'),
		LBrace:   p.must('{'),
		Blocks:   p.blocks(),
		RBrace:   p.must('}'),
	}
}

// DataDefNode is a CST node for:
//
//	DATADEF :=
//	    ['export' | 'thread' ] 'data' $IDENT '=' ['align' NUMBER]
//	    '{'
//	        ( EXTTY DATAITEM+
//	        | 'z'   NUMBER ),
//	    '}';
type DataDefNode struct {
	Linkage Tok
	Data    Tok
	Global  Tok
	Eq      Tok
	Align   Tok
	Number  Tok
	LBrace  Tok
	Items   []Node
	RBrace  Tok
}

// Position implements Node.
func (n *DataDefNode) Position() token.Position {
	if n.Linkage.IsValid() {
		return n.Linkage.Position()
	}

	return n.Data.Position()
}

func (p *parser) dataDef(export Tok) *DataDefNode {
	r := &DataDefNode{
		Linkage: export,
		Data:    p.consume(),
		Global:  p.must(GLOBAL),
		Eq:      p.must('='),
	}
	if p.ch() == ALIGN {
		r.Align = p.consume()
		r.Number = p.must(INT_LIT)
	}
	r.LBrace = p.must('{')
	r.Items = p.dataDefItems()
	r.RBrace = p.must('}')
	return r
}

// DataItemZeroNode is a CST node for zero data item of a data definition.
type DataItemZeroNode struct {
	Z      Tok
	Number Tok
}

// Position implements Node.
func (n *DataItemZeroNode) Position() token.Position { return n.Z.Position() }

// ( EXTTY DATAITEM+
// | 'z'   NUMBER ),
func (p *parser) dataDefItems() (r []Node) {
	for {
		switch p.ch() {
		case L, W, S, D, B, H: // EXTTY
			r = append(r, p.dataItems(p.consume()))
		case Z:
			r = append(r, &DataItemZeroNode{p.consume(), p.must(INT_LIT)})
		case '}':
			return r
		default:
			p.err(p.tok.off, 0, "syntax error, unexpected %#U", p.ch())
			p.consume()
			return r
		}

		if p.ch() != ',' {
			return r
		}

		t := p.consume()
		r = append(r, &t)
	}
}

// DataItemsNode is a CST node for the data items of a data definition.
type DataItemsNode struct {
	Items []Node
}

// Position implements Node.
func (n DataItemsNode) Position() token.Position { return n.Items[0].Position() }

// DataItemStringNode represents a CST node for a string literal data
// initializer.
type DataItemStringNode struct {
	Type Tok
	Val  Tok
}

// Position implements Node.
func (n *DataItemStringNode) Position() token.Position { return n.Type.Position() }

// DataItemConstNode represents a CST node for a numeric/pointer initializer.
type DataItemConstNode struct {
	Type  Tok
	Const Node
}

// Position implements Node.
func (n *DataItemConstNode) Position() token.Position { return n.Type.Position() }

// DataItemGlobalNode is a Node representing an address of a global with optional
// offset.
type DataItemGlobalNode struct {
	Type   Tok
	Global Tok
	Plus   Tok
	Number Tok
}

// Position implements Node.
func (n *DataItemGlobalNode) Position() token.Position { return n.Type.Position() }

// DATAITEM :=
//
//	  $IDENT ['+' NUMBER]  # Symbol and offset
//	|  '"' ... '"'         # String
//	|  CONST               # Constant
func (p *parser) dataItems(typ Tok) (r DataItemsNode) {
	for {
		switch p.ch() {
		case GLOBAL:
			ident := p.consume()
			switch p.ch() {
			case '+':
				r.Items = append(r.Items, &DataItemGlobalNode{Type: typ, Global: ident, Plus: p.consume(), Number: p.must(INT_LIT)})
			default:
				r.Items = append(r.Items, &DataItemGlobalNode{Type: typ, Global: ident})
			}
		case STRING_LIT:
			r.Items = append(r.Items, &DataItemStringNode{typ, p.consume()})
		case '-', INT_LIT, FLOAT32_LIT, FLOAT64_LIT, LONG_DOUBLE_LIT:
			r.Items = append(r.Items, &DataItemConstNode{typ, p.constant()})
		default:
			if len(r.Items) == 0 {
				p.err(p.tok.off, 0, "expected data item")
			}
			return r
		}
	}
}

// ThreadVarNode is a Node representing a thread-local variable.
type ThreadVarNode struct {
	Thread Tok
	Global Tok // eg $foo
}

// Position implements Node.
func (n *ThreadVarNode) Position() token.Position {
	return n.Global.Position()
}

// IntConstNode is a Node representing a integer literal with an optional negative sign.
type IntConstNode struct {
	Sign   Tok
	Number Tok
}

// Position implements Node.
func (n *IntConstNode) Position() token.Position {
	if n.Sign.IsValid() {
		return n.Sign.Position()
	}

	return n.Number.Position()
}

// LongDoubleLitNode is a Node representing a long double literal.
type LongDoubleLitNode Tok

// Position implements Node.
func (n LongDoubleLitNode) Position() token.Position { return Tok(n).Position() }

// Float64LitNode is a Node representing a float64 literal.
type Float64LitNode Tok

// Position implements Node.
func (n Float64LitNode) Position() token.Position { return Tok(n).Position() }

// Float32LitNode is a Node representing a float32 literal.
type Float32LitNode Tok

// Position implements Node.
func (n Float32LitNode) Position() token.Position { return Tok(n).Position() }

// CONST :=
//
//	  ['-'] NUMBER  # Decimal integer
//	| 's_' FP       # Single-precision float
//	| 'd_' FP       # Double-precision float
//	| $IDENT        # Global symbol
func (p *parser) constant() Node {
	switch p.ch() {
	case '-':
		return &IntConstNode{Sign: p.consume(), Number: p.must(INT_LIT)}
	case INT_LIT:
		return &IntConstNode{Number: p.consume()}
	case FLOAT32_LIT:
		return Float32LitNode(p.consume())
	case FLOAT64_LIT:
		return Float64LitNode(p.consume())
	case LONG_DOUBLE_LIT:
		return LongDoubleLitNode(p.consume())
	case GLOBAL:
		t := p.tok
		return &t
	default:
		p.err(p.tok.off, 0, "syntax error, unexpected %#U", p.ch())
		p.consume()
		return nil
	}
}

// BlockNode is a CST node for:
//
//	BLOCK :=
//	    @IDENT    # Block label
//	    PHI*      # Phi instructions
//	    INST*     # Regular instructions
//	    JUMP      # Jump or return
type BlockNode struct {
	Label Tok
	Phis  []*PhiNode
	Insts []Node
	Jump  Node
}

// Position implements Node.
func (n *BlockNode) Position() token.Position { return n.Label.Position() }

func (p *parser) blocks() (r []*BlockNode) {
	for {
		b := &BlockNode{}
		switch p.ch() {
		case LABEL:
			b.Label = p.consume()
		case '}', eof:
			return r
		default:
			p.err(p.tok.off, 0, "expected label")
		}

		var x Node
		b.Phis, x = p.phis()
		b.Insts = p.insts(x)
		b.Jump = p.jump()
		r = append(r, b)
	}
}

// JnzNode is a CST node for the jnz instruction.
type JnzNode struct {
	Inst    Tok
	Val     Node
	Comma   Tok
	LabelNZ Tok
	Comma2  Tok
	LabelZ  Tok
}

// Position implements Node.
func (n *JnzNode) Position() token.Position { return n.Inst.Position() }

// RetNode is a CST node for the ret instruction with an optional return value.
type RetNode struct {
	Inst Tok
	Val  Node
}

// Position implements Node.
func (n *RetNode) Position() token.Position { return n.Inst.Position() }

// JmpNode is a CST node for the jmp instruction.
type JmpNode struct {
	Inst  Tok
	Label Tok
}

// Position implements Node.
func (n *JmpNode) Position() token.Position { return n.Inst.Position() }

// JUMP :=
//
//	  'jmp' @IDENT               # Unconditional
//	| 'jnz' VAL, @IDENT, @IDENT  # Conditional
//	| 'ret' [VAL]                # Return
func (p *parser) jump() Node {
	switch p.ch() {
	case JMP:
		return &JmpNode{p.consume(), p.must(LABEL)}
	case JNZ:
		return &JnzNode{
			p.consume(),
			p.val(),
			p.must(','),
			p.must(LABEL),
			p.must(','),
			p.must(LABEL),
		}
	case RET:
		return &RetNode{p.consume(), p.valOpt()}
	default:
		return nil
	}
}

// StoreNode is a CST node for the store instruction.
type StoreNode struct {
	Inst  Tok
	Dst   Node
	Comma Tok
	Src   Node
}

// Position implements Node.
func (n *StoreNode) Position() token.Position { return n.Inst.Position() }

// VaStartNode is a CST node for the vastart instruction.
type VaStartNode struct {
	Inst Tok
	Arg  Node
}

// Position implements Node.
func (n *VaStartNode) Position() token.Position { return n.Inst.Position() }

type BlitNode struct {
	Inst   Tok
	Src    Node
	Comma  Tok
	Dst    Node
	Comma2 Tok
	N      Node
}

// Position implements Node.
func (n *BlitNode) Position() token.Position { return n.Inst.Position() }

func (p *parser) insts(x Node) (r []Node) {
	if x != nil {
		r = append(r, x)
	}
	for {
		switch p.ch() {
		case LOCAL:
			r = append(r, p.inst())
		case LABEL, JMP, JNZ, RET:
			return r
		case STOREB, STORED, STOREH, STOREL, STORES, STOREW:
			r = append(r, &StoreNode{Inst: p.consume(), Src: p.val(), Comma: p.must(','), Dst: p.val()})
		case CALL:
			r = append(r, p.call(InstPreambleNode{Inst: p.consume()}))
		case VASTART:
			r = append(r, &VaStartNode{p.consume(), p.val()})
		case BLIT:
			r = append(r, &BlitNode{Inst: p.consume(), Src: p.val(), Comma: p.must(','), Dst: p.val(), Comma2: p.must(','), N: p.val()})
		case eof, '}':
			return r
		default:
			p.err(p.tok.off, 0, "syntax error, unexpected %#U", p.ch())
			p.consume()
			return r
		}
	}
}

// PhiNode is a CST node for the PhiNode instruction.
//
//	PHI := %IDENT '=' BASETY 'phi' ( @IDENT VAL ),
type PhiNode struct {
	InstPreambleNode
	Args []PhiArgNode
}

func (p *parser) phis() (r []*PhiNode, xtra Node) {
	for p.ch() == LOCAL {
		switch x := p.inst().(type) {
		case *PhiNode:
			r = append(r, x)
		default:
			return r, x
		}
	}
	return r, nil
}

// InstPreambleNode represents the common part of a 3-address instruction.
type InstPreambleNode struct {
	Dst  Tok
	Eq   Tok
	Type Tok
	Inst Tok
}

// Position implements Node.
func (n *InstPreambleNode) Position() token.Position {
	if n.Dst.IsValid() {
		return n.Dst.Position()
	}

	return n.Inst.Position()
}

func (p *parser) inst() Node {
	pre := InstPreambleNode{
		Dst:  p.dst(),
		Eq:   p.must('='),
		Type: p.abiType(),
	}
	return p.op(pre)
}

// CopyNode is a CST node for the copy instruction.
type CopyNode struct {
	InstPreambleNode
	Val Node
}

// DeclareNode is a CST node for the declare instruction.
type DeclareNode struct {
	InstPreambleNode
}

// SltofNode is a CST node for the sltof instruction.
type SltofNode struct {
	InstPreambleNode
	Val Node
}

// StosiNode is a CST node for the stosi instruction.
type StosiNode struct {
	InstPreambleNode
	Val Node
}

// StouiNode is a CST node for the stoui instruction.
type StouiNode struct {
	InstPreambleNode
	Val Node
}

// VaArgNode is a CST node for the vaarg instruction.
type VaArgNode struct {
	InstPreambleNode
	Val Node
}

// TruncdNode is a CST node for the truncd instruction.
type TruncdNode struct {
	InstPreambleNode
	Val Node
}

// TruncldNode is a CST node for the truncld instruction.
type TruncldNode struct {
	InstPreambleNode
	Val Node
}

// SwtofNode is a CST node for the swtof instruction.
type SwtofNode struct {
	InstPreambleNode
	Val Node
}

// UltofNode is a CST node for the ultof instruction.
type UltofNode struct {
	InstPreambleNode
	Val Node
}

// UwtofNode is a CST node for the uwtof instruction.
type UwtofNode struct {
	InstPreambleNode
	Val Node
}

// AddNode is a CST node for the add instruction.
type AddNode struct {
	InstPreambleNode
	BinaryOperandsNode
}

// ShlNode is a CST node for the shl instruction.
type ShlNode struct {
	InstPreambleNode
	BinaryOperandsNode
}

// ShrNode is a CST node for the shr instruction.
type ShrNode struct {
	InstPreambleNode
	BinaryOperandsNode
}

// SarNode is a CST node for the sar instruction.
type SarNode struct {
	InstPreambleNode
	BinaryOperandsNode
}

// DivNode is a CST node for the div instruction.
type DivNode struct {
	InstPreambleNode
	BinaryOperandsNode
}

// UdivNode is a CST node for the udiv instruction.
type UdivNode struct {
	InstPreambleNode
	BinaryOperandsNode
}

// SubNode is a CST node for the sub instruction.
type SubNode struct {
	InstPreambleNode
	BinaryOperandsNode
}

// MulNode is a CST node for the mul instruction.
type MulNode struct {
	InstPreambleNode
	BinaryOperandsNode
}

// AndNode is a CST node for the and instruction.
type AndNode struct {
	InstPreambleNode
	BinaryOperandsNode
}

// OrNode is a CST node for the or instruction.
type OrNode struct {
	InstPreambleNode
	BinaryOperandsNode
}

// XorNode is a CST node for the xor instruction.
type XorNode struct {
	InstPreambleNode
	BinaryOperandsNode
}

// RemNode is a CST node for the rem instruction.
type RemNode struct {
	InstPreambleNode
	BinaryOperandsNode
}

// UremNode is a CST node for the urem instruction.
type UremNode struct {
	InstPreambleNode
	BinaryOperandsNode
}

// AllocNode is a CST node for the various alloc* instructions.
type AllocNode struct {
	InstPreambleNode
	Val Node
}

// LoadNode is a CST node for the various load* instructions.
type LoadNode struct {
	InstPreambleNode
	Val Node
}

// ExtNode is a CST node for the various ext* instructions.
type ExtNode struct {
	InstPreambleNode
	Val Node
}

// CastNode is a CST node for the cast instruction.
type CastNode struct {
	InstPreambleNode
	Val Node
}

// DtosiNode is a CST node for the dtosi instruction.
type DtosiNode struct {
	InstPreambleNode
	Val Node
}

// LdtosiNode is a CST node for the ldtosi instruction.
type LdtosiNode struct {
	InstPreambleNode
	Val Node
}

// LdtouiNode is a CST node for the ldtoui instruction.
type LdtouiNode struct {
	InstPreambleNode
	Val Node
}

// DtouiNode is a CST node for the dtoui instruction.
type DtouiNode struct {
	InstPreambleNode
	Val Node
}

// CmpNode is a CST node for the various cmp* instructions.
type CmpNode struct {
	InstPreambleNode
	BinaryOperandsNode
}

func (p *parser) op(pre InstPreambleNode) Node {
	pre.Inst = p.consume()
	if pre.Type.Ch == TYPENAME && pre.Inst.Ch != CALL && pre.Inst.Ch != VAARG {
		p.err(pre.Type.off, 0, "expected base type")
	}
	switch pre.Inst.Ch {
	case ADD:
		return &AddNode{pre, p.binary()}
	case ALLOC16, ALLOC4, ALLOC8:
		return &AllocNode{pre, p.val()}
	case AND:
		return &AndNode{pre, p.binary()}
	case CALL:
		return p.call(pre)
	case CAST:
		return &CastNode{pre, p.val()}
	case
		CEQD, CEQL, CEQS, CEQW,
		CGED, CGES,
		CGTD, CGTS,
		CLED, CLES,
		CLTD, CLTS,
		CNED, CNEL, CNES, CNEW,
		CSGEL, CSGEW,
		CSGTL, CSGTW,
		CSLEL, CSLEW,
		CSLTL, CSLTW,
		CUGEL, CUGEW,
		CUGTL, CUGTW,
		CULEL, CULEW,
		CULTL, CULTW,
		CUOD, CUOS,
		COD, COS:
		return &CmpNode{pre, p.binary()}
	case COPY:
		return &CopyNode{pre, p.val()}
	case DECLARE:
		return &DeclareNode{pre}
	case DIV:
		return &DivNode{pre, p.binary()}
	case DTOSI:
		return &DtosiNode{pre, p.val()}
	case DTOUI:
		return &DtouiNode{pre, p.val()}
	case EXTS, EXTD, EXTSB, EXTSH, EXTSW, EXTUB, EXTUH, EXTUW:
		return &ExtNode{pre, p.val()}
	case LOAD, LOADD, LOADL, LOADS, LOADSB, LOADSH, LOADSW, LOADUB, LOADUH, LOADUW, LOADW:
		return &LoadNode{pre, p.val()}
	case MUL:
		return &MulNode{pre, p.binary()}
	case NEG:
		return &NegNode{pre, p.val()}
	case OR:
		return &OrNode{pre, p.binary()}
	case PHI:
		return &PhiNode{pre, p.phiArgs()}
	case REM:
		return &RemNode{pre, p.binary()}
	case SAR:
		return &SarNode{pre, p.binary()}
	case SHL:
		return &ShlNode{pre, p.binary()}
	case SHR:
		return &ShrNode{pre, p.binary()}
	case SLTOF:
		return &SltofNode{pre, p.val()}
	case SUB:
		return &SubNode{pre, p.binary()}
	case STOSI:
		return &StosiNode{pre, p.val()}
	case STOUI:
		return &StouiNode{pre, p.val()}
	case SWTOF:
		return &SwtofNode{pre, p.val()}
	case ULTOF:
		return &UltofNode{pre, p.val()}
	case UWTOF:
		return &UwtofNode{pre, p.val()}
	case TRUNCD:
		return &TruncdNode{pre, p.val()}
	case UDIV:
		return &UdivNode{pre, p.binary()}
	case UREM:
		return &UremNode{pre, p.binary()}
	case VAARG:
		return &VaArgNode{pre, p.val()}
	case XOR:
		return &XorNode{pre, p.binary()}
	default:
		p.err(pre.Inst.off, 0, "expected operation")
		p.consume()
		return nil
	}
}

// NegNode is a CST node for the neg instruction.
type NegNode struct {
	InstPreambleNode
	Val Node
}

// CallNode is a CST node for the call instruction.
//
//	CALL := [%IDENT '=' ABITY] 'call' VAL '(' (ARG), ')'
type CallNode struct {
	InstPreambleNode
	Val    Node
	LParen Tok
	Args   []Node
	RParen Tok
}

func (p *parser) call(pre InstPreambleNode) *CallNode {
	return &CallNode{
		pre,
		p.val(),
		p.must('('),
		p.args(),
		p.must(')'),
	}
}

// RegularArgNode is a Node representing a regular argument of a call instruction.
//
//	ABITY VAL  # Regular argument
type RegularArgNode struct {
	Type  Tok
	Val   Node
	Comma Tok
}

// Position implements Node.
func (n *RegularArgNode) Position() token.Position { return n.Type.Position() }

// EnvArgNode is a Node representing a environment argument of a call instruction.
//
//	| 'env' VAL     # Environment argument (first)
type EnvArgNode struct {
	Env   Tok
	Val   Node
	Comma Tok
}

// Position implements Node.
func (n *EnvArgNode) Position() token.Position { return n.Env.Position() }

// VariadicMarkerNode is a Node representing a variadic argument of a call instruction.
//
//	| '...'         # Variadic marker (last)
type VariadicMarkerNode struct {
	Ellipsis Tok
	Comma    Tok
}

// Position implements Node.
func (n *VariadicMarkerNode) Position() token.Position { return n.Ellipsis.Position() }

// ARG :=
//
//	  ABITY VAL  # Regular argument
//	| 'env' VAL     # Environment argument (first)
//	| '...'         # Variadic marker (last)
func (p *parser) args() (r []Node) {
	seenDots := false
	for {
		comma := false
		switch p.ch() {
		case W, L, P, C, S, D, TYPENAME:
			r = append(r, &RegularArgNode{p.consume(), p.val(), p.commaOpt(&comma)})
		case ENV:
			r = append(r, &EnvArgNode{p.consume(), p.val(), p.commaOpt(&comma)})
		case ELLIPSIS:
			off := p.tok.off
			r = append(r, &VariadicMarkerNode{p.consume(), p.commaOpt(&comma)})
			if seenDots {
				p.err(off, 0, "variadic can appear only once")
			}
			seenDots = true
		case ')':
			return r
		case eof:
			p.err(p.tok.off, 0, "unexpected end of file")
			return r
		default:
			p.err(p.tok.off, 0, "expected argument specification")
			return r
		}

		switch p.ch() {
		case ')':
			return r
		case eof:
			p.err(p.tok.off, 0, "unexpected end of file")
			return r
		}

		if !comma {
			p.err(p.off, 0, "expected ','")
			return r
		}
	}
}

// RegularParamNode is a Node representing a regular parameter of a function
// definition.
//
//	ABITY %IDENT  # Regular parameter
type RegularParamNode struct {
	Type  Tok
	Local Tok
	Comma Tok
}

// Position implements Node.
func (n *RegularParamNode) Position() token.Position { return n.Type.Position() }

// EnvParamNode is a CST node for the environment parameter of a function
// definition.
//
//	| 'env' %IDENT  # Environment parameter (first)
type EnvParamNode struct {
	Env   Tok
	Local Tok
	Comma Tok
}

// Position implements Node.
func (n *EnvParamNode) Position() token.Position { return n.Env.Position() }

// PARAM :=
//
//	  ABITY %IDENT  # Regular parameter
//	| 'env' %IDENT  # Environment parameter (first)
//	| '...'         # Variadic marker (last)
func (p *parser) params() (r []Node) {
	for {
		comma := false
		switch p.ch() {
		case W, L, P, C, S, D, TYPENAME:
			r = append(r, &RegularParamNode{p.consume(), p.must(LOCAL), p.commaOpt(&comma)})
		case ENV:
			r = append(r, &EnvParamNode{p.consume(), p.must(LOCAL), p.commaOpt(&comma)})
		case ELLIPSIS:
			off := p.tok.off
			r = append(r, &VariadicMarkerNode{p.consume(), p.commaOpt(&comma)})
			if p.ch() != ')' {
				p.err(off, 0, "variadic marker must be last")
			}
		case ')':
			return r
		case eof:
			p.err(p.tok.off, 0, "unexpected end of file")
			return r
		default:
			p.err(p.tok.off, 0, "expected parameter")
			return r
		}

		switch p.ch() {
		case ')':
			return r
		case eof:
			p.err(p.tok.off, 0, "unexpected end of file")
			return r
		}

		if !comma {
			p.err(p.off, 0, "expected ','")
			return r
		}
	}
}

func (p *parser) commaOpt(ok *bool) (r Tok) {
	if p.ch() == ',' {
		*ok = true
		return p.consume()
	}

	return r
}

// BinaryOperandsNode represents the operands of a binary operation.
type BinaryOperandsNode struct {
	A     Node
	Comma Tok
	B     Node
}

func (p *parser) binary() BinaryOperandsNode {
	return BinaryOperandsNode{p.val(), p.must(','), p.val()}
}

// PhiArgNode is a Node representing an argument of a phi instruction.
type PhiArgNode struct {
	Label Tok
	Val   Node
	Comma Tok
}

func (p *parser) phiArgs() (r []PhiArgNode) {
	for {
		arg := PhiArgNode{Label: p.must(LABEL), Val: p.val()}
		if p.ch() != ',' {
			return append(r, arg)
		}

		arg.Comma = p.consume()
		r = append(r, arg)
	}
}

func (p *parser) val() Node {
	switch p.ch() {
	case INT_LIT, LOCAL, GLOBAL, FLOAT32_LIT, FLOAT64_LIT, LONG_DOUBLE_LIT, STRING_LIT:
		tok := p.consume()
		return &tok
	case '-':
		return &IntConstNode{p.consume(), p.must(INT_LIT)}
	case THREAD:
		return &ThreadVarNode{p.consume(), p.must(GLOBAL)}
	default:
		p.err(p.tok.off, 0, "syntax error, unexpected %#U", p.ch())
		p.consume()
		return nil
	}
}

func (p *parser) valOpt() Node {
	switch p.ch() {
	case INT_LIT, LOCAL, GLOBAL, FLOAT32_LIT, FLOAT64_LIT, LONG_DOUBLE_LIT, STRING_LIT:
		tok := p.consume()
		return &tok
	case '-':
		return &IntConstNode{p.consume(), p.must(INT_LIT)}
	case THREAD:
		return &ThreadVarNode{p.consume(), p.must(GLOBAL)}
	default:
		return nil
	}
}

func (p *parser) dst() Tok {
	switch p.ch() {
	case GLOBAL, LOCAL:
		// ok
	default:
		p.err(p.tok.off, 0, "expected destination operand")
	}
	return p.consume()
}

// ABITY := BASETY | :IDENT
func (p *parser) abiType() Tok {
	switch p.ch() {
	case W, L, P, C, S, D, TYPENAME:
	default:
		p.err(p.tok.off, 0, "expected ABI type")
	}
	return p.consume()
}

// ABITY := BASETY | :IDENT
func (p *parser) abiTypeOpt() Tok {
	switch p.ch() {
	case W, L, P, C, S, D, TYPENAME:
		return p.consume()
	}

	return Tok{}
}

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

// NodeSource returns the source form of nodes.
func NodeSource(nodes ...Node) string {
	var a []tokener
	for _, n := range nodes {
		nodeSource(n, &a)
	}
	sort.Slice(a, func(i, j int) bool { return a[i].Off() < a[j].Off() })
	var b strings.Builder
	for _, t := range a {
		b.Write(t.Sep())
		b.Write(t.Src())
	}
	return b.String()
}

func nodeSource(n any, a *[]tokener) {
	if n == nil {
		return
	}

	switch x := n.(type) {
	case tokener:
		if x.IsValid() {
			*a = append(*a, x)
		}
		return
	}

	t := reflect.TypeOf(n)
	v := reflect.ValueOf(n)
	switch t.Kind() {
	case reflect.Ptr:
		et := t.Elem()
		ev := v.Elem()
		switch et.Kind() {
		case reflect.Struct:
			for i := 0; i < et.NumField(); i++ {
				ft := et.Field(i)
				if !ft.IsExported() {
					continue
				}

				nodeSource(ev.Field(i).Interface(), a)
			}
		default:
			panic(todo("", t.Kind()))
		}
	case reflect.Struct:
		for i := 0; i < t.NumField(); i++ {
			ft := t.Field(i)
			if !ft.IsExported() {
				continue
			}

			nodeSource(v.Field(i).Interface(), a)
		}
	case reflect.Slice:
		for i := 0; i < v.Len(); i++ {
			nodeSource(v.Index(i).Interface(), a)
		}
	default:
		// ~/src/modernc.org/ccorpus2/assets/gcc-9.1.0/gcc/testsuite/gcc.c-torture/execute/20030216-1.c
		panic(todo("", t.Kind()))
	}
}
