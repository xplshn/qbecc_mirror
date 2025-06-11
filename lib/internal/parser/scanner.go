// Copyright 2025 The qbecc Authors. All rights reserved.
// Use of the source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package parser

import (
	"fmt"
	"go/token"
	"strings"
	"unicode"
	"unicode/utf8"

	mtoken "modernc.org/token"
)

const eof = -1

var (
	_ Node = (*Tok)(nil)
)

type errItem struct {
	off int32
	err error
}

type msgList []errItem

func (e msgList) Err(s *source) error {
	if len(e) == 0 {
		return nil
	}

	w := 0
	prev := errItem{off: -1}
	for _, v := range e {
		if v.off != prev.off || v.err.Error() != prev.err.Error() {
			e[w] = v
			w++
			prev = v
		}
	}

	var a []string
	for _, v := range e {
		a = append(a, fmt.Sprintf("%v: %v", position(s.file, mtoken.Pos(v.off+1)), v.err))
	}
	return fmt.Errorf("%s", strings.Join(a, "\n"))
}

func (e *msgList) err(off int32, skip int, msg string, args ...interface{}) {
	errs := *e
	msg = fmt.Sprintf(msg, args...)
	*e = append(errs, errItem{off, fmt.Errorf("%s (%v:)", msg, origin(skip+2))})
}

// Ch represents the lexical value of a CSTToken.
type Ch rune

// Node is an item of a CST/AST tree.
type Node interface {
	Position() token.Position
}

// Tok is the product of Scanner.Scan and a terminal node of the complete
// syntax tree.
type Tok struct { // 24 bytes on 64 bit arch
	source *source

	Ch
	next   int32
	off    int32
	sepOff int32
}

func position(f *mtoken.File, off mtoken.Pos) (r token.Position) {
	p0 := token.Position(f.Position(off))
	p1 := token.Position(f.PositionFor(off, false))
	if p0 != p1 {
		p0.Column = 1
	}
	return p0
}

func (n Tok) Off() int32 {
	return n.off
}

// Position implements Node.
func (n Tok) Position() (r token.Position) {
	if n.IsValid() {
		return position(n.source.file, mtoken.Pos(n.off+1))
	}

	return r
}

func (n Tok) pos() pos { return pos{n.source, n.off} }

type pos struct {
	source *source
	off    int32
}

func (n pos) Position() (r token.Position) {
	if n.source != nil {
		return position(n.source.file, mtoken.Pos(n.off+1))
	}

	return r
}

// Offset reports the offset of n, in bytes, within the source buffer.
func (n *Tok) Offset() int { return int(n.off) }

// SepOffset reports the offset of n's preceding white space, if any, in bytes,
// within the source buffer.
func (n *Tok) SepOffset() int { return int(n.sepOff) }

// String pretty formats n.
func (n *Tok) String() string {
	if n.Ch < ADD || n.Ch > Z {
		return fmt.Sprintf("%v: %q %#U", n.Position(), n.Src(), rune(n.Ch))
	}

	return fmt.Sprintf("%v: %q %#U", n.Position(), n.Src(), n.Ch)
}

// IsValid reports the validity of n. Tokens not present in some nodes will
// report false.
func (n Tok) IsValid() bool { return n.source != nil }

// Sep reports the whitespace preceding n, if any. The result is read only.
func (n Tok) Sep() []byte { return n.source.buf[n.sepOff:n.off] }

// Src reports the original textual form of n. The result is read only.
func (n Tok) Src() []byte { return n.source.buf[n.off:n.next] }

type source struct {
	buf  []byte
	file *mtoken.File
	name string
}

// Scanner provides lexical analysis of its buffer.
type Scanner struct {
	*source
	// Tok is the current CST token. It is valid after first call to Scan. The
	// value is read only.
	Tok  Tok
	errs msgList

	cnt int32
	off int32 // Index into source.buf.

	c byte // Lookahead.

	allErrros bool
	isClosed  bool
}

// NewScanner returns a newly created scanner that will tokenize buf. Positions
// are reported as if buf is coming from a file named name. The buffer becomes
// owned by the scanner and must not be modified after calling NewScanner.
//
// The scanner normally stops scanning after some number of errors. Passing
// allErrros == true overides that.
func NewScanner(buf []byte, name string, allErrros bool) (*Scanner, error) {
	r := &Scanner{
		source: &source{
			buf:  buf,
			file: mtoken.NewFile(name, len(buf)),
			name: name,
		},
		allErrros: allErrros,
	}
	if len(buf) != 0 {
		r.c = buf[0]
		if r.c == '\n' {
			r.file.AddLine(int(r.off) + 1)
		}
	}
	return r, nil
}

// Err reports any errors the scanner encountered. For typical use please see
// the .Scan() documentation.
func (s *Scanner) Err() error { return s.errs.Err(s.source) }

func (s *Scanner) err(off int32, skip int, msg string, args ...interface{}) {
	if len(s.errs) == 10 && !s.allErrros {
		s.close()
		return
	}

	s.errs.err(off, skip+1, msg, args...)
}

func (s *Scanner) close() {
	if s.isClosed {
		return
	}

	if s.cnt == 1 {
		s.err(s.off, 1, "empty input")
	}
	s.Tok.Ch = eof
	s.Tok.next = s.off
	s.Tok.off = s.off
	s.Tok.source = s.source
	s.isClosed = true
}

func isIDFirst(c byte) bool {
	return c >= 'a' && c <= 'z' ||
		c >= 'A' && c <= 'Z' ||
		c == '_' || c == '.'
}

func isDigit(c byte) bool      { return c >= '0' && c <= '9' }
func isHexDigit(c byte) bool   { return isDigit(c) || c >= 'a' && c <= 'f' || c >= 'A' && c <= 'F' }
func isIDNext(c byte) bool     { return isIDFirst(c) || isDigit(c) }
func isOctalDigit(c byte) bool { return c >= '0' && c <= '7' }

func (s *Scanner) next() {
	if int(s.off) == len(s.buf)-1 {
		s.Tok.next = s.off + 1
		s.c = 0
		return
	}

	s.off++
	s.Tok.next = s.off
	s.c = s.buf[s.off]
	if s.c == '\n' {
		s.file.AddLine(int(s.off) + 1)
	}
}

func (s *Scanner) nextN(n int) {
	if int(s.off) == len(s.buf)-n {
		s.c = 0
		return
	}

	s.off += int32(n)
	s.Tok.next = s.off
	s.c = s.buf[s.off]
}

// Scan moves to the next token and returns true if not at end of file. Usage
// example:
//
//	s, _ = NewScanner(buf, name, false)
//	for s.Scan() {
//		...
//	}
//	if err := s.Err() {
//		...
//	}
func (s *Scanner) Scan() (r bool) {
	if s.isClosed {
		return false
	}

	s.cnt++
	s.Tok.sepOff = s.off
	s.Tok.source = s.source
	s.Tok.Ch = -1
	for {
		if r = s.scan(); !r || s.Tok.Ch >= 0 {
			return r
		}
	}
}

func (s *Scanner) scan() (r bool) {
	s.Tok.off = s.off
	s.Tok.next = s.off
	switch s.c {
	case '$':
		s.next()
		switch s.c {
		case '"':
			s.next()
			for s.c != '"' {
				s.next()
			}
			s.next()
			s.Tok.Ch = GLOBAL
			return true
		default:
			s.ident()
			s.Tok.Ch = GLOBAL
			return true
		}
	case '%':
		s.next()
		s.ident()
		s.Tok.Ch = LOCAL
		return true
	case '.':
		s.next()
		if s.c != '.' {
			s.err(s.off, 0, "expected '.'")
			s.Tok.Ch = ELLIPSIS
			return true
		}

		s.next()
		if s.c != '.' {
			s.err(s.off, 0, "expected '.'")
			s.Tok.Ch = ELLIPSIS
			return true
		}

		s.next()
		s.Tok.Ch = ELLIPSIS
		return true
	case ':':
		s.next()
		s.ident()
		s.Tok.Ch = TYPENAME
		return true
	case '@':
		s.next()
		s.ident()
		s.Tok.Ch = LABEL
		return true
	case '#':
		s.lineComment()
		return true
	case ' ', '\t', '\n', '\r':
		s.next()
		for {
			switch s.c {
			case ' ', '\t', '\n', '\r':
				s.next()
			default:
				return true
			}
		}
	case '(', ')', '{', '}', ',', '+', '-', '=':
		s.Tok.Ch = Ch(s.c)
		s.next()
		return true
	case 's':
		s.next()
		switch s.c {
		case '_':
			s.next()
			s.floatLiteral(FLOAT32_LIT)
			return true
		case 0:
			s.Tok.Ch = S
			return true
		default:
			s.off--
			s.c = 's'
		}
	case 'p':
		s.next()
		switch s.c {
		case 'h': // phi
			s.off--
			s.c = 'p'
		default:
			s.Tok.Ch = P
			return true
		}
	case 'd':
		s.next()
		switch s.c {
		case '_':
			s.next()
			s.floatLiteral(FLOAT64_LIT)
			return true
		case 0:
			s.Tok.Ch = D
			return true
		default:
			s.off--
			s.c = 'd'
		}
	case 'l':
		off := s.off
		s.next()
		switch s.c {
		case 0:
			s.Tok.Ch = L
			return true
		}

		s.off = off
		s.c = 'l'
	case '"':
		s.next()
		s.stringLiteral()
		return true
	case 0:
		s.close()
		return false
	}

	switch {
	case s.c >= 'a' && s.c <= 'z':
		s.keyword()
		return true
	case isDigit(s.c):
		s.decimals()
		s.Tok.Ch = INT_LIT
		return true
	default:
		s.err(s.off, 0, "unexpected %#U", s.c)
		s.next()
		return true
	}
}

func (s *Scanner) stringLiteral() {
	// leading '"' already consumed.
	s.Tok.Ch = STRING_LIT
	for {
		switch s.c {
		case '"':
			s.next()
			return
		case '\\':
			s.next()
			switch s.c {
			case '\'', '"', '\\', 'a', 'b', 'f', 'n', 'r', 't', 'v':
				s.next()
				continue
			case 'x', 'X':
				s.next() // consume x|X
				if !isHexDigit(s.c) {
					s.err(s.off, 0, "expected hex digit: %#U", s.c)
					continue
				}

				s.next() // consume the first hex digit
				if !isHexDigit(s.c) {
					s.err(s.off, 0, "expected hex digit: %#U", s.c)
				}

				s.next() // consume the second hex digit
				continue
			case 'u':
				s.next()
				s.u4()
				continue
			case 'U':
				s.next()
				s.u8()
				continue
			}

			switch {
			case isOctalDigit(s.c):
				s.next() // 1st
				if isOctalDigit(s.c) {
					s.next() // 2nd
				} else {
					continue
				}

				if isOctalDigit(s.c) {
					s.next() // 3rd
				}
				continue
			default:
				s.err(s.off, 0, "unknown escape sequence: %#U", s.c)
				s.next()
				continue
			}
		case 0:
			s.err(s.off, 0, "unexpected EOF")
			s.next()
			return
		case '\t':
			s.next()
		}

		switch {
		case s.c < ' ':
			s.err(s.off, 0, "non-printable character: %#U", s.c)
			s.next()
		default:
			s.next()
		}
	}
}

func (s *Scanner) u4() {
	// Leading u consumed.
	for i := 0; i < 4; i++ {
		if !isHexDigit(s.c) {
			panic(todo("%v: %#U", s.Tok.Position(), s.c))
		}

		s.next()
	}
}

func (s *Scanner) u8() {
	// Leading U consumed.
	for i := 0; i < 8; i++ {
		if !isHexDigit(s.c) {
			panic(todo("%v: %#U", s.Tok.Position(), s.c))
		}

		s.next()
	}
}

func (s *Scanner) decimals() {
	if !isDigit(s.c) {
		s.err(s.off, 0, "expected decimal digit")
		s.next()
		return
	}

	for {
		switch {
		case isDigit(s.c):
			s.next()
		default:
			return
		}
	}
}

func (s *Scanner) floatLiteral(ch Ch) {
	s.Tok.Ch = ch
	off0 := s.off
	switch s.c {
	case '+', '-':
		s.next()
	}
	for {
		switch s.c {
		case 'x', 'X':
			if s.off-off0 == 1 && s.source.buf[off0] == '0' {
				s.next()
				s.hexDigits(true)
				switch s.c {
				case 'p', 'P':
					s.next()
					s.exponent()
					return
				default:
					s.err(s.off, 0, "expected 'p' or 'P'")
					s.next()
					return
				}
			}

			if s.off != off0 {
				return
			}

			s.err(s.off, 0, "unexpected 'x' or 'X'")
			s.next()
			return
		case '.':
			s.next()
			if isDigit(s.c) {
				s.decimals()
			}
			switch s.c {
			case 'e', 'E':
				s.next()
				s.exponent()
			}
			return
		case 'e', 'E':
			s.next()
			s.exponent()
			return
		case 0:
			if s.off == off0 {
				s.err(s.off, 0, "expected floating point literal")
				return
			}
		}

		switch {
		case s.c >= '0' && s.c <= '9':
			s.next()
		default:
			return
		}
	}
}

func (s *Scanner) exponent() {
	switch s.c {
	case '+', '-':
		s.next()
	}

	s.decimals()
}

func (s *Scanner) hexDigits(accept1dot bool) {
	switch {
	case accept1dot && s.c == '.':
		// ok
	default:
		if !isHexDigit(s.c) {
			s.err(s.off, 0, "expected hex digit")
		}
	}

	for {
		switch {
		case isHexDigit(s.c):
			s.next()
		case accept1dot && s.c == '.':
			s.next()
			accept1dot = false
		default:
			return
		}
	}
}

func (s *Scanner) keyword() {
out:
	for {
		switch {
		case s.c >= 'a' && s.c <= 'z' || s.c >= '0' && s.c <= '9':
			s.next()
		case s.c == 0:
			break out
		default:
			break out
		}
	}
	s.Tok.Ch = Keywords[string(s.Tok.Src())]
	if s.Tok.Ch == 0 {
		s.err(s.Tok.off, 0, "expected keyword: %s", s.Tok.Src())
	}
}

func (s *Scanner) ident() {
	ok := false
	off := s.off
out:
	for {
		switch {
		case isIDNext(s.c):
			s.next()
			ok = true
		case s.c >= 0x80:
			switch r := s.rune(); {
			case unicode.IsLetter(r) || unicode.IsDigit(r):
				ok = true
				// already consumed
			default:
				panic(todo("%v: %#U", s.Tok.Position(), r))
			}
		case s.c == 0:
			break out
		default:
			break out
		}
	}
	if !ok {
		s.err(off, 0, "expected identifier")
		return
	}

	s.Tok.Ch = Keywords[string(s.Tok.Src())]
}

func (s *Scanner) rune() rune {
	switch r, sz := utf8.DecodeRune(s.buf[s.off:]); {
	case r == utf8.RuneError && sz == 0:
		panic(todo("%v: %#U", s.Tok.Position(), s.c))
	case r == utf8.RuneError && sz == 1:
		panic(todo("%v: %#U", s.Tok.Position(), s.c))
	default:
		s.nextN(sz)
		return r
	}
}

func (s *Scanner) lineComment() {
	for {
		s.next()
		switch s.c {
		case '\n', 0:
			s.next()
			return
		}
	}
}

// Named values of Ch.
const (
	ADD             Ch = iota + 0xe000 // add
	ALIGN                              // align
	ALLOC16                            // alloc16
	ALLOC4                             // alloc4
	ALLOC8                             // alloc8
	AND                                // and
	B                                  // b
	BLIT                               // blit
	C                                  // c
	CALL                               // call
	CAST                               // cast
	CEQD                               // ceqd
	CEQL                               // ceql
	CEQS                               // ceqs
	CEQW                               // ceqw
	CGED                               // cged
	CGES                               // cges
	CGTD                               // cgtd
	CGTS                               // cgts
	CLED                               // cled
	CLES                               // cles
	CLTD                               // cltd
	CLTS                               // clts
	CNED                               // cned
	CNEL                               // cnel
	CNES                               // cnes
	CNEW                               // cnew
	COD                                // cod
	COPY                               // copy
	COS                                // cos
	CSGEL                              // csgel
	CSGEW                              // csgew
	CSGTL                              // csgtl
	CSGTW                              // csgtw
	CSLEL                              // cslel
	CSLEW                              // cslew
	CSLTL                              // csltl
	CSLTW                              // csltw
	CUGEL                              // cugel
	CUGEW                              // cugew
	CUGTL                              // cugtl
	CUGTW                              // cugtw
	CULEL                              // culel
	CULEW                              // culew
	CULTL                              // cultl
	CULTW                              // cultw
	CUOD                               // cuod
	CUOS                               // cuos
	D                                  // d
	DATA                               // data
	DECLARE                            // declare
	DIV                                // div
	DTOSI                              // dtosi
	DTOUI                              // dtoui
	ELLIPSIS                           // ...
	ENV                                // env
	EXPORT                             // export
	EXTD                               // exts
	EXTS                               // exts
	EXTSB                              // extsb
	EXTSH                              // extsh
	EXTSW                              // extsw
	EXTUB                              // extub
	EXTUH                              // extuh
	EXTUW                              // extuw
	FLOAT32_LIT                        // float32 literal
	FLOAT64_LIT                        // float64 literal
	FUNCTION                           // function
	GLOBAL                             // global name
	H                                  // h
	INT_LIT                            // integer literal
	JMP                                // jmp
	JNZ                                // jnz
	L                                  // l
	LABEL                              // label name
	LOAD                               // load
	LOADD                              // loadd
	LOADL                              // loadl
	LOADS                              // loads
	LOADSB                             // loadsb
	LOADSH                             // loadsh
	LOADSW                             // loadsw
	LOADUB                             // loadub
	LOADUH                             // loaduh
	LOADUW                             // loaduw
	LOADW                              // loadw
	LOCAL                              // local name
	LONG_DOUBLE_LIT                    // long double literal
	MUL                                // mul
	OR                                 // or
	P                                  // p
	PHI                                // phi
	REM                                // rem
	RET                                // ret
	S                                  // s
	SAR                                // sar
	SHL                                // shl
	SHR                                // shr
	SLTOF                              // sltof
	STOREB                             // storeb
	STORED                             // stored
	STOREH                             // storeh
	STOREL                             // storel
	STORES                             // stores
	STOREW                             // storew
	STOSI                              // stosi
	STOUI                              // stoui
	STRING_LIT                         // string literal
	SUB                                // sub
	SWTOF                              // swtof
	THREAD                             // thread
	TRUNCD                             // truncd
	TYPE                               // type
	TYPENAME                           // type name
	UDIV                               // udiv
	ULTOF                              // ultof
	UREM                               // urem
	UWTOF                              // uwtof
	VAARG                              // vaarg
	VASTART                            // vastart
	W                                  // w
	XOR                                // xor
	Z                                  // z
)

// Keywords represents the mapping of identifiers to QBE's reserved names.
var Keywords = map[string]Ch{
	"add":      ADD,
	"align":    ALIGN,
	"alloc16":  ALLOC16,
	"alloc4":   ALLOC4,
	"alloc8":   ALLOC8,
	"and":      AND,
	"b":        B,
	"blit":     BLIT,
	"c":        C,
	"call":     CALL,
	"cast":     CAST,
	"ceqd":     CEQD,
	"ceql":     CEQL,
	"ceqs":     CEQS,
	"ceqw":     CEQW,
	"cged":     CGED,
	"cges":     CGES,
	"cgtd":     CGTD,
	"cgts":     CGTS,
	"cled":     CLED,
	"cles":     CLES,
	"cltd":     CLTD,
	"clts":     CLTS,
	"cned":     CNED,
	"cnel":     CNEL,
	"cnes":     CNES,
	"cnew":     CNEW,
	"cod":      COD,
	"copy":     COPY,
	"cos":      COS,
	"csgel":    CSGEL,
	"csgew":    CSGEW,
	"csgtl":    CSGTL,
	"csgtw":    CSGTW,
	"cslel":    CSLEL,
	"cslew":    CSLEW,
	"csltl":    CSLTL,
	"csltw":    CSLTW,
	"cugel":    CUGEL,
	"cugew":    CUGEW,
	"cugtl":    CUGTL,
	"cugtw":    CUGTW,
	"culel":    CULEL,
	"culew":    CULEW,
	"cultl":    CULTL,
	"cultw":    CULTW,
	"cuod":     CUOD,
	"cuos":     CUOS,
	"d":        D,
	"data":     DATA,
	"declare":  DECLARE,
	"div":      DIV,
	"dtosi":    DTOSI,
	"dtoui":    DTOUI,
	"env":      ENV,
	"export":   EXPORT,
	"extd":     EXTD,
	"exts":     EXTS,
	"extsb":    EXTSB,
	"extsh":    EXTSH,
	"extsw":    EXTSW,
	"extub":    EXTUB,
	"extuh":    EXTUH,
	"extuw":    EXTUW,
	"function": FUNCTION,
	"h":        H,
	"jmp":      JMP,
	"jnz":      JNZ,
	"l":        L,
	"load":     LOAD,
	"loadd":    LOADD,
	"loadl":    LOADL,
	"loads":    LOADS,
	"loadsb":   LOADSB,
	"loadsh":   LOADSH,
	"loadsw":   LOADSW,
	"loadub":   LOADUB,
	"loaduh":   LOADUH,
	"loaduw":   LOADUW,
	"loadw":    LOADW,
	"mul":      MUL,
	"or":       OR,
	"p":        P,
	"phi":      PHI,
	"rem":      REM,
	"ret":      RET,
	"s":        S,
	"sar":      SAR,
	"shl":      SHL,
	"shr":      SHR,
	"sltof":    SLTOF,
	"storeb":   STOREB,
	"stored":   STORED,
	"storeh":   STOREH,
	"storel":   STOREL,
	"stores":   STORES,
	"storew":   STOREW,
	"stosi":    STOSI,
	"stoui":    STOUI,
	"sub":      SUB,
	"swtof":    SWTOF,
	"thread":   THREAD,
	"truncd":   TRUNCD,
	"type":     TYPE,
	"udiv":     UDIV,
	"ultof":    ULTOF,
	"urem":     UREM,
	"uwtof":    UWTOF,
	"vaarg":    VAARG,
	"vastart":  VASTART,
	"w":        W,
	"xor":      XOR,
	"z":        Z,
}

//TODO- func (c Ch) str() string {
//TODO- 	if c < ADD || c > Z {
//TODO- 		return fmt.Sprintf("%#U", c)
//TODO- 	}
//TODO-
//TODO- 	return c.String()
//TODO- }
