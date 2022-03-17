#!/bin/bash

set -ex

SOURCE_DIR=$(dirname $BASH_SOURCE)
cmake -B "$SOURCE_DIR"/build -GNinja -D"SWIFT_BIN=$SWIFT_BIN/" -D"LLVM_BIN=$LLVM_BIN/" -DCMAKE_TOOLCHAIN_FILE=../toolchain-arm-none-eabi.cmake -S .
ninja -C "$SOURCE_DIR"/build
