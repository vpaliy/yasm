%include 'system.inc'

section .data
  array:      db "2l",0xA, 0x0
  example:    db "l"
  format:     dq "%d",0xA,0

section .text
  bits 64
  global _length
  global _main

; finds the length of a string
_main:
default rel
  push rbp
  mov rbp, rsp
  mov rdi, qword array
  mov rsi, [example]
  call _contains
  out qword format, rax
  leave
  ret

; rdi - string
; rax - length
_length:
  mov rax, rdi
.while:
  cmp [rdi], byte 0x0
  lea rdi, [rdi + 0x1]
  jne .while
.end:
  sub rdi, rax
  mov rax, rdi
  ret

; rdi - string
; rsi - element (not a string)
; rax - (0 - absent, 1 - contains)
_contains:
  push rbp
  mov rbp, rsp
  xor rax, rax
.while:
  cmp [rdi], byte 0x0
  je .end
  cmp [rdi], qword rsi
  je .contains
  inc rdi
  jmp .while
.contains:
  mov rax, 0x1
.end:
  leave
  ret
