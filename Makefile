# Copyright 2023 The qbecc Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

.PHONY:	all clean edit editor work

all: editor
	golint
	staticcheck

clean:
	rm -f log-* cpu.test mem.test *.out go.work*
	go clean

edit:
	@touch log
	@if [ -f "Session.vim" ]; then gvim -S & else gvim -p Makefile qbecc.go & fi

editor:
	gofmt -l -s -w . 2>&1 | tee log-editor
	go test -c -o /dev/null 2>&1 | tee -a log-editor
	go build -v ./... 2>&1 | tee -a log-editor
	go install -v 2>&1 | tee -a log-editor
	staticcheck 2>&1 | tee -a log-editor

work:
	rm -f go.work*
	go work init
	go work use .
	go work use ../cc/v4
	go work use ../ssa
