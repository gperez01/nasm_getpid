;-----------------------------------------------------------------------------------------------------------------------
; Name: nasm_getpid
; Author: @gperez01
; Date: 28/10/2023
; Description: prints the PID of the new process through the STDOUT. Designed using the i386 Linux calling convention.
;
; Compile instructions: nasm -f elf nasm_getpid.asm
; Link instructions: ld -m elf_i386 -o nasm_getpid nasm_getpid.o
; Usage: ./nasm_getpid
;-----------------------------------------------------------------------------------------------------------------------

section .data
  LOOKUP_DIGITS db "0123456789"

  PID_STRING db "PID: "

  PID_STR_LEN equ $-PID_STRING

section .bss
  PID: resb 16 ; reserve a 16-bytes memory chunk for the PID value + additional chars (\n, \t, etc.)

section .text
  global _start

_start:

  mov eax, 20 ; sys_getpid call

  int 0x80 ; sys_getpid interruption

  ;-------------------------------

  mov ebx, 10 ; set divider for the ASCII conv.

  lea ebp, [PID+7] ; LEA (Load Effective Address) PID + 6 bytes into the buffer

  jmp _ascii_conv ; jump into the ASCII conv. loop

_ascii_conv:

  div ebx ; divide the sys_getpid return value

  mov byte cl, [LOOKUP_DIGITS+edx] ; copy the ASCII value into ecx

  mov [ebp], cl ; move ecx value into the buffer (pointed by ebp). It is like a "mini-stack"

  dec ebp ; point to the next position in the buffer

  xor edx, edx ; clear the edx register (containing the previous DIV reminder). THIS SETS THE ZF TO 0!!

  inc eax ; increment eax by one (set ZF again to 1)

  dec eax ; reset eax to its original value. if eax == 0 --> ZF = 0; else --> ZF = 1

  jnz _ascii_conv ; restart the loop if eax != 0

  jmp _print_pid ; jump to the _print_pid section if eax == 0;

_print_pid:

  mov eax, 4 ; sys_write call

  push PID_STR_LEN ; push PID_STR_LEN into the stack

  push PID_STRING ; push "PID: " string into the stack 

  mov ebx, 1 ; STDOUT file descriptor

  pop ecx ; PID_STRING into ecx

  pop edx ; PID_STR_LEN into edx

  int 0x80 ; sys_write interruption

  ;--------------------------------

  mov [PID+8], byte 0x0a ; add "\n" to the PID buffer

  add esp, 0x10 ; clear the stack

  push PID ; push the PID value into the stack

  mov eax, 4 ; sys_write call

  mov ebx, 1 ; STDOUT file descriptor

  pop ecx ; PID into ecx

  mov edx, 16 ; the output has a max length of 16 bytes = PID buffer

  int 0x80 ; sys_write interruption


  ;--------------------------------

  mov eax, 1 ; sys_exit call

  xor ebx, ebx ; set sys_exit status code = 0 

  xor ecx, ecx ; clear ecx

  xor edx, edx ; clear edx

  int 0x80 ; sys_exit interruption
