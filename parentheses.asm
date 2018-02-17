%include 'utils/arrays.inc'

section .bss
  array resb 100

section .text
  bits 64
  global _main

_main:
default rel
  push rbp
  mov rbp, rsp
  mov rax, qword array
  push rax
  push 100
  call _fill
  leave
  ret
