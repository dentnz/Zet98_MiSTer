#!/bin/sh
split -b 32k BIOS.ROM
dd if=/dev/zero of=./dummy.bin bs=64K count=2
cat xaa xab xac xac dummy.bin FONT.ROM >boot.rom
