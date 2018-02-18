%include 'utils/arrays.inc'

section .bss
  array resq 100

section .text
  bits 64
  global _main

_main:
default rel
  push rbp
  mov rbp, rsp
  mov rax, qword array
  push rax
  push 0x64
  call _fill
  add rsp, 0x10
  mov rax, qword array
  push rax
  push 0x10
  call _print
  add rsp, 0x10
  leave
  ret
