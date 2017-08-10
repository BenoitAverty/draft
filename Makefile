PONYC = CC=clang ponyc
SOURCE_FILES := $(shell find src -name \*.pony)
ARGS = -p /usr/lib/openssl-1.0

all: bin/load_test

.deps: bundle.json
	stable fetch

bin/load_test: ${SOURCE_FILES} .deps
	mkdir -p bin
	stable env ${PONYC} ${ARGS} src -o bin
	mv bin/src bin/load_test

clean:
	rm -rf bin .deps


.PHONY: all
