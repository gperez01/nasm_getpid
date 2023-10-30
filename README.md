# NASM_getpid
- **Author**: Gabriel Pérez Navarro @gperez01
- **Date:** 28/10/2023
- **Description:** utility that gets the PID of the newly created process and converts the returned value `pid_t` (signed int) to its printable ASCII representation.
- **IMPORTANT**: this utility was designed using the **i386 Linux System Call convention**
- **CREDITS**: credits to *TheROPFather* (https://github.com/TheROPFather/getpid) because of the binary data-to-ASCII conversion implementation.
--------------------------------------------------------------------------------
Compile instructions:
```bash
nasm -f elf nasm_getpid.asm
```

Link instructions:
```bash
ld -m elf_i386 -o nasm_getpid nasm_getpid.o
```
