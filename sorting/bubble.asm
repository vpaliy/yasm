%include '../utils/arrays.inc'

%define SIZE 0x2

section .bss
  array resq SIZE

%macro prepare 0
  mov rax, qword array
  push rax
  push SIZE
%endmacro

section .text
  global _main
  global _bubble

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
  call _bubble
  add rsp, 0x10

  prepare
  call _print
  add rsp, 0x10

  leave
  ret

; Bubble sort (2 loops) O(n)
; 1 - array
; 2 - length
_bubble:
  push rbp
  mov rbp, rsp
  push rsi
  push rdi
  mov rsi, [rbp + 0x18] ; array
  mov rdi, [rbp + 0x10] ; length
  lea rdi, [rsi + 0x8 * rdi]
.while:
  cmp rsi, rdi
  jge .end
  mov rax, rsi
.inner:
  lea rax, [rax + 0x8]
  cmp rax, rdi
  jge .reset
  push rax
  mov rax, [rax]
  cmp rax, [rsi]
  jge .proceed
  xor rax, [rsi]
  xor [rsi], rax
  xor rax, [rsi]
.proceed:
  pop r8
  mov [r8], rax
  mov rax, r8
  lea rax, [rax + 0x8]
  jmp .inner
.reset:
  lea rsi, [rsi + 0x8]
  jmp .while
.end:
  pop rdi
  pop rsi
  leave
  ret
