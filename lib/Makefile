# Copyright 2025 The qbecc Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

.PHONY:	all asm clean edit editor work test todo review shorttest csmith bgsmith rsync

all: editor
	golint
	staticcheck

asm:
	echo "//go:build ignore" > atomic_linux_amd64.s
	gcc atomic.c -S
	cat atomic.s >> atomic_linux_amd64.s
	rm atomic.s

clean:
	rm -f log-* cpu.test mem.test *.out go.work*
	go clean

csmith:
	go test -v -timeout 24h -run TestCSmith -trc

edit:
	@touch log
	@if [ -f "Session.vim" ]; then gvim -S & else gvim -p Makefile ../go.mod builder.json *.h *.go & fi

editor: asm
	stringer -type=fileType,symbolType,mode,refType
	gofmt -l -s -w .
	go test -c -o /dev/null ./...
	go build -o /dev/null logextractor.go
	go install -v  ..
	staticcheck 2>&1

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
	grep -a 'VET' log | tee -a log-todo
	grep -a 'EXEC' log | tee -a log-todo
	grep -a 'EQUA' log | tee -a log-todo
	grep -a -o 'passed=.*' log | tee -a log-todo

review:
	echo -n > log-review
	for f in $(shell ls *.h *.go | sort) ; \
		do echo "File:" $$f >> log-review ; \
		echo >> log-review; \
		echo '```' >> log-review; \
		cat $$f >> log-review; \
		echo '```' >> log-review; \
		echo >> log-review; \
		done
	ls -l log-review

shorttest:
	go test -v -timeout 24h -csmithn 100

bgsmith:
	GOMAXPROCS=1 go test -v -timeout 2400h -run TestCSmith -trc -csmithn 1000000 -csmith 2399h

rsync:
	rsync -avz --delete ../../qbecc/ rpi5:src/modernc.org/qbecc/
