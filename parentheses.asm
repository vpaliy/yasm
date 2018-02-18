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
  push 0x63
  call _fill
  add rsp, 0x10
  mov rax, qword array
  push rax
  push 0x64
  call _print
  add rsp, 0x10
  mov rsi, qword array
  mov rdi, 0x64
  call _min
  ;
  lea rdi, [format]
  mov rsi, rax
  xor rax, rax
  call _printf
  xor rax, rax

  mov rsi, qword array
  mov rdi, 0x64
  call _max
  ;
  lea rdi, [format]
  mov rsi, rax
  xor rax, rax
  call _printf
  xor rax, rax
  leave
  ret
