%include '../utils/arrays.inc'

%define SIZE 0x10

section .bss
  second resq 0x1
  array resq SIZE

%macro prepare 0
  mov rax, qword array
  push rax
  push SIZE
%endmacro

section .text
  global _main
  global _insertion

_main:
default rel
  push rbp
  mov rbp, rsp

  prepare
  call _fill
  add rsp, 0x10

  prepare
  call _print
  add rsp, 0x10

  prepare
  call _insertion
  add rsp, 0x10

  prepare
  call _print
  add rsp, 0x10

  leave
  ret

_insertion:
  push rbp
  mov rbp, rsp
  push rsi
  push rdi
  mov rsi, [rbp + 0x18]
  mov rdi, [rbp + 0x10]
  lea rdi, [rsi + 0x8 * rdi]
.while:
  cmp rsi, rdi
  jge .end
  lea rax, [rsi + 0x8]
  cmp rax, rdi
  jge .end
  push rdi
  mov rdi, rsi
  mov r8, rax
  mov rax, [rax]
  lea rsi, [rsi - 0x8]
; iterate backwards
.inner:
  cmp rax, [rdi]
  jge .finish
  mov rbx, [rdi]
  mov [rdi + 0x8], rbx
  lea rdi, [rdi - 0x8]
  lea r8, [r8 - 0x8]
  cmp rdi, rsi
  je .finish
  jmp .inner
.finish:
  lea rsi, [rsi + 0x10]
  pop rdi
  mov [r8], rax
  jmp .while
.end:
  pop rdi
  pop rsi
  leave
  ret
