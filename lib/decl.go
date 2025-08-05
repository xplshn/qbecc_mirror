// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package qbecc // import "modernc.org/qbecc/lib"

import (
	"fmt"
	"sort"
	"strings"

	"modernc.org/cc/v4"
)

const (
	maxInlineDepth = 10
	maxQBEName     = nString - 1
	nString        = 80 // qbe/all.h:43
)

var renamed = map[string]struct{}{
	// Go keywords not reserved by C and Go assembler reserved names
	"chan":      {},
	"defer":     {},
	"func":      {},
	"g":         {},
	"go":        {},
	"import":    {},
	"init":      {},
	"interface": {},
	"map":       {},
	"package":   {},
	"range":     {},
	"select":    {},
	"type":      {},
	"var":       {},

	// Go keywords reserved by C

	// "break":       {},
	// "case":        {},
	// "const":       {},
	// "continue":    {},
	// "default":     {},
	// "else":        {},
	// "fallthrough": {},
	// "for":         {},
	// "goto":        {},
	// "if":          {},
	// "return":      {},
	// "struct":      {},
	// "switch":      {},
}

type variable interface {
	isVarinfo()
	String() string
}

type varinfo struct{}

func (varinfo) isVarinfo() {}

// declared in function scope, storage duration automatic
type localVar struct {
	varinfo
	d    *cc.Declarator
	name string
}

func (n *localVar) String() string {
	return fmt.Sprintf("%v: %T %s %s", n.d.Position(), n, n.d.Name(), n.name)
}

// Declared in function scope, storage duration automatic, escaped to TLSAlloc.
// Also used for the non-declared storage required for "return structFunc();"
// or "func(structFunc());" etc. (d == nil)
type escapedVar struct {
	varinfo
	d      *cc.Declarator
	offset int64 // into %.bp.
}

func (n *escapedVar) String() string {
	return fmt.Sprintf("%v: %T %s", n.d.Position(), n, n.d.Name())
}

type complitVar struct {
	varinfo
	n      *cc.PostfixExpression
	offset int64 // into %.bp.
}

func (n *complitVar) String() string {
	return fmt.Sprintf("%v: %T", n.n.Position(), n)
}

// storage duration static
type staticVar struct {
	varinfo
	d    *cc.Declarator
	name string
}

func shortName(prefix, nm string, id int) (r string) {
	var suffix string
	if id >= 0 {
		suffix = fmt.Sprintf(".%v", id)
	}
	switch lp, ln, ls := len(prefix), len(nm), len(suffix); {
	case lp+ln+ls <= maxQBEName:
		return prefix + nm + suffix
	default:
		r = prefix + nm
		return r[:len(r)-len(suffix)] + suffix
	}
}

type variables map[cc.Node]variable

func (v *variables) register(n cc.Node, f *fnCtx, c *ctx, inlineLevel int) {
	m := *v
	if m == nil {
		m = variables{}
		*v = m
	}
	if n == nil || m[n] != nil {
		return
	}

	// if !strings.Contains(n.Position().String(), "<") {
	// 	defer func() { trc("%v: %s n=%T@%p m=%v", n.Position(), cc.NodeSource(n), n, n, m[n]) }()
	// }
	switch x := n.(type) {
	case nil:
		return
	case *cc.Declarator:
		if x == nil || m[x] != nil {
			return
		}

		dt := x.Type()
		if c.isUnsupportedType(dt) && !x.IsExtern() {
			c.err(x, "unsupported type: %s", dt)
			return
		}

		k := dt.Kind()
		switch x.StorageDuration() {
		case cc.Static:
			switch sc := x.ResolvedIn(); sc {
			case nil:
				if strings.HasPrefix(x.Name(), "__builtin_") {
					m[x] = &staticVar{
						d:    x,
						name: fmt.Sprintf("$%q", x.Name()[len("__builtin_"):]),
					}
					break
				}

				if k == cc.Function || x.IsExtern() {
					m[x] = &staticVar{
						d:    x,
						name: fmt.Sprintf("$%q", c.rename(x.Name())),
					}
				}
			default:
				switch {
				case sc.Parent == nil || x.Type().Kind() == cc.Function || x.IsExtern():
					m[x] = &staticVar{
						d:    x,
						name: fmt.Sprintf("$%q", c.rename(x.Name())),
					}
				default:
					m[x] = &staticVar{
						d:    x,
						name: shortName("$\".", c.rename(x.Name()), f.ctx.id()) + `"`,
					}
				}
			}
		case cc.Automatic:
			switch {
			case x.AddressTaken() || k == cc.Array || k == cc.Struct || k == cc.Union || c.isComplexType(dt):
				if x.IsParam() && c.isVaList(x) {
					panic(todo("", x.Position(), x.Type()))
				}
				m[x] = &escapedVar{
					d:      x,
					offset: f.alloc(x, int64(dt.Align()), c.sizeof(x, dt)),
				}
			default:
				var prefix string
				suffix := -1
				if !x.IsParam() || inlineLevel != 0 {
					suffix = f.id()
				}
				if x.IsParam() && c.isVaList(x) {
					prefix = "__qbe_va_list_"
				}
				m[x] = &localVar{
					d:    x,
					name: shortName("%"+prefix, c.rename(x.Name()), suffix),
				}
			}
		default:
			panic(todo("", x.StorageDuration()))
		}
	case *cc.PostfixExpression:
		switch x.Case {
		case cc.PostfixExpressionComplit: // '(' TypeName ')' '{' InitializerList ',' '}'
			t := x.TypeName.Type()
			m[x] = &complitVar{
				n:      x,
				offset: f.alloc(x, int64(t.Align()), c.sizeof(x, t)),
			}
		case cc.PostfixExpressionCall: // PostfixExpression '(' ArgumentExpressionList ')'
			m[x] = &escapedVar{
				offset: f.alloc(x, c.wordSize, c.sizeof(x, x.Type())),
			}
		}
	case cc.ExpressionNode:
		m[x] = &escapedVar{
			offset: f.alloc(x, c.wordSize, c.sizeof(x, x.Type())),
		}
	case *cc.JumpStatement: // return agg type
		m[x] = &escapedVar{
			offset: f.alloc(x, c.wordSize, c.sizeof(x, x.ExpressionList.Type())),
		}
	default:
		c.err(n, "internal error %T", x)
	}
}

func (c *ctx) rename(s string) (r string) {
	if _, ok := renamed[s]; !ok {
		return s
	}

	return "__qbe__" + s
}

func (n *staticVar) String() string {
	return fmt.Sprintf("%v: %T %s %s", n.d.Position(), n, n.d.Name(), n.name)
}

type breakContinueCtx struct {
	label string
	prev  *breakContinueCtx
}

type switchCase struct {
	*cc.LabeledStatement
	label string
	val0  any
	val   int64

	isDefault bool
}

type switchCtx struct {
	defaultCase *switchCase
	case2index  map[*cc.LabeledStatement]int // index into the sorted cases slice
	cases       []*switchCase
	expr        any
	prev        *switchCtx
	sign        string // "s" or "u"
	suff        string // "w" or "l"
	typ         cc.Type

	isSigned bool
}

// ({ stmt; ... expr; })
type exprStatementCtx struct {
	expr any
	prev *exprStatementCtx
	typ  cc.Type
}

type inlineStackItem struct {
	outerResult cc.Type
	returnVar   any
	next        *inlineStackItem
}

// Function compile context
type fnCtx struct {
	allocs           int64
	breakCtx         *breakContinueCtx
	continueCtx      *breakContinueCtx
	ctx              *ctx
	exprStatementCtx *exprStatementCtx
	inlineStack      *inlineStackItem
	nextID           int
	returns          cc.Type
	static           []*cc.InitDeclarator
	switchCtx        *switchCtx
	variables        variables
}

func (c *ctx) newFnCtx(n *cc.FunctionDefinition) (r *fnCtx) {
	r = &fnCtx{
		ctx: c,
	}
	r.fill(c, n, 0)
	return r
}

func (fn *fnCtx) fill(c *ctx, n *cc.FunctionDefinition, inlineLevel int) {
	if inlineLevel == maxInlineDepth {
		c.err(n, "max inline depth reached")
		return
	}

	ignore := 0
	walk(n, func(n cc.Node, mode int) {
		switch mode {
		case walkPre:
			switch x := n.(type) {
			case *cc.StructDeclarator:
				ignore++
			case *cc.Declarator:
				if ignore == 0 {
					fn.variables.register(x, fn, c, inlineLevel)
					if x.IsParam() {
						ignore++
					}
				}
			case *cc.PostfixExpression:
				switch x.Case {
				case cc.PostfixExpressionComplit: // '(' TypeName ')' '{' InitializerList ',' '}'
					fn.variables.register(x, fn, c, inlineLevel)
				case cc.PostfixExpressionCall: // PostfixExpression '(' ArgumentExpressionList ')'
					if c.isAggType(x.Type()) {
						fn.variables.register(x, fn, c, inlineLevel)
					}
					if d := c.funcDeclarator(x.PostfixExpression); d != nil && d.IsInline() && c.isHeader(d) {
						fn.fill(c, c.inlineFns[d], inlineLevel+1)
					}
				}
			case *cc.PrimaryExpression:
				switch x.Case {
				case cc.PrimaryExpressionIdent: // IDENTIFIER
					if d, ok := x.ResolvedTo().(*cc.Declarator); ok {
						fn.variables.register(d, fn, c, inlineLevel)
					}
				case cc.PrimaryExpressionFloat: // FLOATCONST
					switch x.Value().(type) {
					case cc.Complex64Value, cc.Complex128Value:
						fn.variables.register(x, fn, c, inlineLevel)
					}
				}
			case *cc.JumpStatement:
				switch x.Case {
				case cc.JumpStatementReturn: // "return" ExpressionList ';'
					if x.ExpressionList != nil && c.isAggType(x.ExpressionList.Type()) {
						fn.variables.register(x, fn, c, inlineLevel)
					}
				}
			case
				*cc.MultiplicativeExpression,
				*cc.AdditiveExpression,
				*cc.UnaryExpression:

				if c.isComplexType(x.(cc.ExpressionNode).Type()) {
					fn.variables.register(x, fn, c, inlineLevel)
				}
			}
		case walkPost:
			switch x := n.(type) {
			case *cc.StructDeclarator:
				ignore--
			case *cc.Declarator:
				if x.IsParam() {
					ignore--
				}
			}
		}
	})
}

func (f *fnCtx) id() (r int) {
	r = f.nextID
	f.nextID++
	return r
}

func (f *fnCtx) newBreakCtx(label string) string {
	f.breakCtx = &breakContinueCtx{label: label, prev: f.breakCtx}
	return label
}

func (f *fnCtx) restoreBreakCtx() {
	f.breakCtx = f.breakCtx.prev
}

func (f *fnCtx) newContinueCtx(label string) string {
	f.continueCtx = &breakContinueCtx{label: label, prev: f.continueCtx}
	return label
}

func (f *fnCtx) restoreContinueCtx() {
	f.continueCtx = f.continueCtx.prev
}

func (f *fnCtx) newSwitchCtx(expr any, typ cc.Type, cases0 []*cc.LabeledStatement) *switchCtx {
	isSigned := cc.IsSignedInteger(typ)
	defaultCase := &switchCase{
		isDefault: true,
		label:     f.ctx.label(),
	}
	cases := []*switchCase{defaultCase}
	for _, v := range cases0 {
		switch v.Case {
		case cc.LabeledStatementDefault:
			defaultCase.LabeledStatement = v
		case cc.LabeledStatementCaseLabel:
			var val0 any
			var val int64
			switch x := v.ConstantExpression.Value().(type) {
			case cc.Int64Value:
				val0 = int64(x)
				val = int64(x)
			case cc.UInt64Value:
				val0 = uint64(x)
				val = int64(x)
			default:
				panic(todo("%v: %T %s", v.ConstantExpression, x, cc.NodeSource(v.ConstantExpression)))
			}
			cases = append(cases, &switchCase{
				LabeledStatement: v,
				label:            f.ctx.label(),
				val0:             val0,
				val:              val,
			})
		}
	}
	cases1 := cases[1:]
	sort.Slice(cases1, func(i, j int) bool {
		switch {
		case isSigned:
			return cases1[i].val < cases1[j].val
		default:
			return uint64(cases1[i].val) < uint64(cases1[j].val)
		}
	})
	cases2index := map[*cc.LabeledStatement]int{}
	for i, v := range cases {
		cases2index[v.LabeledStatement] = i
	}
	cases = append(cases, defaultCase)
	sign := "u"
	if isSigned {
		sign = "s"
	}
	f.switchCtx = &switchCtx{
		defaultCase: defaultCase,
		case2index:  cases2index,
		cases:       cases,
		expr:        expr,
		isSigned:    isSigned,
		prev:        f.switchCtx,
		sign:        sign,
		suff:        f.ctx.baseType(nil, typ),
		typ:         typ,
	}
	return f.switchCtx
}

func (f *fnCtx) alloc(n cc.Node, align, size int64) (r int64) {
	if align <= 0 || size < 0 {
		f.ctx.err(n, "unsupported type")
		align = 1
	}
	size = max(size, 1)
	r = round(f.allocs, align)
	f.allocs = r + size
	// trc("%v: (align=%v size=%v)=%v", n.Position(), align, size, r)
	return r
}

func (c *ctx) signature(l []*cc.Parameter, isVariadic bool) {
	c.w("(")
	for _, v := range l {
		if v.Type().Kind() == cc.Void {
			break
		}

		c.w("%s ", c.abiType(v, v.Type()))
		switch nm := v.Name(); nm {
		case "":
			c.w("%%.param.%d, ", c.id())
		default:
			prefix := ""
			switch {
			case c.isVaList(v.Declarator):
				prefix = "__qbe_va_list_"
			}
			c.w("%%%s%s, ", prefix, c.rename(nm))
		}
	}
	if isVariadic {
		c.w("...")
	}
	c.w(")")
}

// FunctionDefinition:
//	DeclarationSpecifiers Declarator DeclarationList CompoundStatement

func (c *ctx) externalDeclarationFuncDef(n *cc.FunctionDefinition) {
	f := c.newFnCtx(n)
	if c.failed {
		return
	}

	c.fn = f

	defer func() {
		c.fn = nil
	}()

	d := n.Declarator
	if d.IsInline() && c.isHeader(d) {
		c.inlineFns[d] = n
		return
	}

	ft := d.Type().(*cc.FunctionType)
	ntypes := len(c.typesInDeclOrder)
	switch f.returns = ft.Result(); f.returns.Kind() {
	case cc.Struct, cc.Union:
		c.registerQType(n, "", f.returns)
	}
	for _, v := range ft.Parameters() {
		switch v.Type().Kind() {
		case cc.Struct, cc.Union:
			c.registerQType(n, "", v.Type())
		}
	}
	for _, v := range c.typesInDeclOrder[ntypes:len(c.typesInDeclOrder)] {
		c.emitType(v)
	}

	c.pos(n)
	c.w("\n")
	if d.Linkage() == cc.External {
		c.w("export ")
	}
	c.w("function ")
	if f.returns.Kind() != cc.Void {
		c.w("%s ", c.abiType(d, f.returns))
	}
	_, info := c.variable(d)
	nm := info.(*staticVar).name
	c.w("%s", nm)
	c.signature(ft.Parameters(), ft.IsVariadic())
	c.w(" {\n")
	c.w("@start.0\n")
	if f.allocs != 0 {
		c.w("\t%%.bp. =%s alloc8 %v\n", c.wordTag, f.allocs)
	}
	for _, v := range ft.Parameters() {
		if d := v.Declarator; d != nil && c.isVLA(d.Type()) {
			f.ctx.err(v.Declarator, "unsupported type: %s", d.Type())
			return
		}

		switch d, info := c.variable(v.Declarator); x := info.(type) {
		case *escapedVar:
			c.w("\t%%._l =%s add %%.bp., %v\n", c.wordTag, x.offset)
			switch {
			case c.isAggType(d.Type()):
				c.w("\tblit %%%s, %%._l, %v\n", c.rename(d.Name()), d.Type().Size())
			default:
				c.w("\tstore%s %%%s, %%._l\n", c.extType(d, d.Type()), d.Name())
			}
		}
	}
	c.compoundStatement(n.CompoundStatement)
	switch {
	case c.fn.returns.Kind() != cc.Void:
		c.w("%s\n\tret 0\n", c.label())
	default:
		c.w("%s\n\tret\n", c.label())
	}
	c.w("}\n\n")
	for _, v := range c.fn.static {
		d := v.Declarator
		// trc("%v: %p %s", d.Position(), d, d.Name())
		if d.ReadCount()+d.WriteCount() == 0 {
			continue
		}

		_, info := c.variable(d)
		if info == nil {
			continue
		}

		c.w("data %s = align %d ", info.(*staticVar).name, d.Type().Align())
		switch {
		case v.Initializer != nil:
			c.w("{")
			c.initializer(v.Initializer, info, d.Type())
			c.w("}\n\n")
		default:
			c.w("{ z %d }\n\n", c.sizeof(d, d.Type()))
		}
	}
}

// DeclarationSpecifiers InitDeclaratorList AttributeSpecifierList ';'
func (c *ctx) externalDeclarationDeclFull(n *cc.Declaration) {
	for l := n.InitDeclaratorList; l != nil; l = l.InitDeclaratorList {
		d := l.InitDeclarator.Declarator
		if d.IsTypename() { // typedef int i;
			continue
		}

		if d.IsExtern() { // extern int foo;
			continue
		}

		if d.Type().Kind() == cc.Function { // int foo(int);
			continue
		}

		if l.InitDeclarator.Asm != nil {
			c.err(n, "assembler not supported")
			continue
		}

		var sel *cc.Declarator
		for _, v := range c.ast.Scope.Nodes[d.Name()] {
			x, ok := v.(*cc.Declarator)
			if !ok {
				continue
			}

			if sel == nil {
				sel = x
				continue
			}

			switch {
			case sel.HasInitializer():
				switch {
				case x.HasInitializer():
					c.err(x, "declarator has multiple initializers: %v and %v", sel.Position(), x.Position())
					return
				}
			default:
				switch {
				case x.HasInitializer():
					sel = x
				}
			}
		}
		if sel != d {
			continue
		}

		var nm string
		switch _, info := c.variable(d); {
		case info == nil:
			nm = fmt.Sprintf("$%q", c.rename(d.Name()))
		default:
			nm = info.(*staticVar).name
		}
		c.pos(n)
		c.w("\n")
		if d.Linkage() == cc.External {
			c.w("export ")
		}
		switch n := l.InitDeclarator; n.Case {
		case cc.InitDeclaratorDecl: // Declarator Asm
			c.w("data %s = align %d { z %d }", nm, d.Type().Align(), max(c.sizeof(d, d.Type()), 1))
		case cc.InitDeclaratorInit: // Declarator Asm '=' Initializer
			c.w("data %s = align %d {\n", nm, d.Type().Align())
			c.initializer(n.Initializer, &staticVar{
				d:    d,
				name: nm,
			}, d.Type())
			c.w("}\n")
		default:
			panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
		}
		c.w("\n")
	}
}

// Declaration
func (c *ctx) externalDeclarationDecl(n *cc.Declaration) {
	switch n.Case {
	case cc.DeclarationDecl: // DeclarationSpecifiers InitDeclaratorList AttributeSpecifierList ';'
		c.externalDeclarationDeclFull(n)
	case cc.DeclarationAssert: // StaticAssertDeclaration
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	case cc.DeclarationAuto: // "__auto_type" Declarator '=' Initializer ';'
		panic(todo("%v: %v %s", n.Position(), n.Case, cc.NodeSource(n)))
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
	}
}

func (c *ctx) externalDeclaration(n *cc.ExternalDeclaration) {
	switch n.Case {
	case cc.ExternalDeclarationFuncDef: // FunctionDefinition
		c.externalDeclarationFuncDef(n.FunctionDefinition)
	case cc.ExternalDeclarationDecl: // Declaration
		c.externalDeclarationDecl(n.Declaration)
	case cc.ExternalDeclarationAsmStmt: // AsmStatement
		c.err(n, "assembler statements not supported")
	case cc.ExternalDeclarationEmpty: // ';'
		// ok
	default:
		c.err(n, "internal error %T.%s", n, n.Case)
	}
}

func (c *ctx) isHeader(n cc.Node) bool {
	if n == nil {
		return false
	}

	nm := n.Position().Filename
	return strings.HasSuffix(nm, ".h") ||
		nm == "<builtin>" ||
		c.t.goos == "windows" && strings.HasSuffix(nm, ".inl")
}

// v has no initializer
func (c *ctx) declare(n cc.Node, v variable) {
	switch x := v.(type) {
	case *localVar:
		c.w("\t%s =%s copy 0\n", x.name, c.baseType(n, x.d.Type()))
	case *escapedVar:
		// nop
	default:
		panic(todo("%v: %T %s", n.Position(), x, cc.NodeSource(n)))
	}
}
