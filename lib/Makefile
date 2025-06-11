# Copyright 2025 The qbecc Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

.PHONY:	all clean edit editor work shorttest test

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
	stringer -type=fileType
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
