OSTYPE := $(shell uname -s)
VERSION = $(patsubst "%",%, $(word 3, $(shell grep version Cargo.toml)))
BIN_NAME = asyncomplete-fuzzy-matcher
FULL_BIN_NAME = $(BIN_NAME)-v$(VERSION)-x86_64
BIN_DIR = bin

export VERSION BIN_NAME FULL_BIN_NAME BIN_DIR

.PHONY: all clean release_linux release_mac install bin

all:
	echo nop

clean:
	cargo clean

ifeq ($(OSTYPE),Linux)
release:
	cargo build --locked --release --target=x86_64-unknown-linux-musl
	tar -C target/x86_64-unknown-linux-musl/release -Jcvf ${FULL_BIN_NAME}-linux.tar.xz ${BIN_NAME}
else ifeq ($(OSTYPE),Darwin)
release:
	cargo build --locked --release --target=x86_64-apple-darwin
	tar -C target/x86_64-apple-darwin/release -Jcvf ${FULL_BIN_NAME}-mac.tar.xz ${BIN_NAME}
else
$(error "Unsupported OSTYPE: $(OSTYPE)")
endif

install: $(BIN_DIR)
	./install

$(BIN_DIR):
	mkdir -p $@
