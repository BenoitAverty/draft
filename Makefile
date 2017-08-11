NAME = draft
PONYC = CC=clang ponyc
SOURCE_FILES := $(shell find draft -name \*.pony)
ARGS = -p /usr/lib/openssl-1.0

all: bin/${NAME}

.deps: bundle.json
	stable fetch

bin/${NAME}: ${SOURCE_FILES} .deps
	mkdir -p bin
	stable env ${PONYC} ${ARGS} ${NAME} -o bin

clean:
	rm -rf bin .deps


.PHONY: all
