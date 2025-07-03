# Copyright 2025 The qbecc Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

.PHONY:	all clean edit editor work shorttest test todo

all: editor
	golint
	staticcheck

clean:
	rm -f log-* cpu.test mem.test *.out go.work*
	go clean

edit:
	@touch log
	@if [ -f "Session.vim" ]; then gvim -S & else gvim -p Makefile ../go.mod builder.json *.h *.go & fi

editor:
	stringer -type=fileType,symbolType,mode,refType
	gofmt -l -s -w .
	go test -c -o /dev/null ./...
	go install -v  ..
	staticcheck 2>&1

shorttest:
	go test -short -v -timeout 24h

work:
	rm -f go.work*
	go work init
	go work use .

test:
	go test -v -timeout 24h

todo:
	go test -v -timeout 24h 2>&1 | tee log || true
	grep -a \
		' FAIL: ~' log | \
		sed 's/.* FAIL: \(.*\)/\1/p' | \
		sed 's/\.c signal.*/.c/' | \
		sed 's/\.c exit status.*/.c/' | \
		LC_ALL=C sort -u 2>&1 > \
		log-todo
	grep -a -o 'instruction.*' log | sort -u 2>&1 >> log-todo
	grep -a -o 'PANIC:.*\.go:[0-9]\+:' log | sort -u 2>&1 >> log-todo
	grep -a -o 'passed=.*' log | tee -a log-todo
