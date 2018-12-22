SHELL         := /bin/bash

WRAPPER       ?= all
DB_HOST       ?= 127.0.0.1

TEST_FLAGS    ?=

export DB_HOST
export WRAPPER

benchmark-lib:
	go test -v -benchtime=500ms -bench=. ./lib/...

benchmark-internal:
	go test -v -benchtime=500ms -bench=. ./internal/...

benchmark: benchmark-lib benchmark-internal

test-lib:
	go test -v ./lib/...

test-internal:
	go test -v ./internal/...

test-libs: test-lib test-internal

test-adapters: test-adapter-postgresql test-adapter-mysql test-adapter-sqlite test-adapter-mssql test-adapter-ql test-adapter-mongo

test-main:
	go test $(TEST_FLAGS) -v ./tests/...

reset-db: reset-db-postgresql reset-db-mysql reset-db-sqlite reset-db-mssql reset-db-ql reset-db-mongo

test: test-libs test-main test-adapters

test-adapter-%:
	($(MAKE) -C $* test || exit 1)

reset-db-%:
	($(MAKE) -C $* reset-db || exit 1)
