PONYC = CC=clang ponyc
SOURCE_FILES := $(shell find . -name \*.pony)
ARGS = -p /usr/lib/openssl-1.0

bin/load_test: ${SOURCE_FILES}
	mkdir -p bin
	${PONYC} ${ARGS} src -o bin
	mv bin/src bin/load_test

clean:
	rm -rf bin

all: bin/load_test

.PHONY: all
