#!/bin/sh

qemu-system-arm -display none -m 1024 -M raspi2b -serial stdio -kernel build/Sources/kernel.elf