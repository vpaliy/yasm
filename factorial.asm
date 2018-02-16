section .data
  n:                 dq 0x0
  print_format:      db '%d', 0x0
  scan_format:       db 'factorial(%d) = %d',0xA

section .text
  bits 64
  extern _printf
  extern _scanf
  global _main
  global _factorial

_main:
default rel
  push rbp
  mov rbp, rsp
  lea rdi, [print_format]
  lea rsi, [n]
  xor rax, rax
  call _scanf
  mov rdi, [n]
  call _factorial
  lea rdi, [scan_format]
  mov rsi, [n]
  mov rdx, rax
  call _printf
  xor rax, rax
  leave
  ret

_factorial:
  push rbp
  mov rbp, rsp
  cmp rdi, 0x1
  jg .greater
  mov rax, 0x1
  leave
  ret
.greater:
  push rdi
  dec rdi
  call _factorial
  imul rax, [rsp]
  mov rsp, rbp
  leave
  ret
