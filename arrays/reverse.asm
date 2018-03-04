%include '../utils/arrays.inc'
%define SIZE 10

section .bss
  array:    resq SIZE

section .text
  global _main
  global _reverse

_main:
  default rel
  push rbp
  mov rbp, rsp

  mov rax, 0x12345678
  shr rax, 0x10
  leave
  ret

; rdi  - array
; rsi - length
_reverse:
  push rbp
  mov rbp, rsp
  lea rsi, [rdi + rsi * 0x8 - 0x8]
.while:
  cmp rdi, rsi
  jge .done
  mov rax, [rdi]
  xor rax, [rsi]
  xor [rsi], rax
  xor rax, [rsi]
  mov [rdi], rax
  lea rdi, [rdi + 0x8]
  lea rsi, [rsi - 0x8]
  jmp .while
.done:
  leave
  ret
