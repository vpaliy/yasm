section .data
  x:      dq 0x0
  scan:   db '%d',0x0
  print:  db 'fact(%d) = %d',0xA

section .text
  bits 64
  global _main
  global factorial
  extern _scanf
  extern _printf

_main:
default rel
  push rbp
  mov rbp, rsp
  lea rdi, [scan]
  lea rsi, [x]
  xor rax, rax
  call _scanf
  mov rdi, [x]
  call _factorial
  lea rdi, [print]
  mov rsi, [x]
  mov rdx, rax
  xor rax, rax
  call _printf
  xor rax, rax
  leave
  ret


_factorial:
  push rbp
  mov rbp, rsp
  sub rsp, 0x10
  cmp rdi, 0x1
  jg _greater
  mov rax, 0x1
  leave
  ret
_greater:
  mov [rsp+0x8], rdi
  dec rdi
  call _factorial
  imul rax, [rsp+0x8]
  leave
  ret
