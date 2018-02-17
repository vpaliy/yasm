section .data
  array:            dq 0x33, 0x31, 0x32
  print_format:     db '%d',0xA

section .text
  bits 64
  global _main
  global _sort
  extern _printf

_main:
default rel
  push rsp
  mov rbp, rsp
  xor rcx, rcx
  mov rax, qword array
  push rax
  push 0x3
  call _sort
  add rsp, 0x10
  leave
  ret

_sort:
  push rbp
  mov rbp, rsp
  push rsi
  push rdi
  push rax
  mov rsi, [rbp + 0x18]
  mov rdi, [rbp + 0x10]
  lea rdi, [rsi + rdi]
.while:
  cmp rsi, rdi
  jge .end
  mov rax, rsi
.nested:
  lea rax, [rax + 0x8]
  cmp rax, rdi
  jge .finish
  push rax
  mov rax, [rax]
  cmp rax,[rsi]
  jge .set
  ; swap values
  xor rax, [rsi]
  xor [rsi], rax
  xor rax, [rsi]
.set:
  pop rax
  jmp  .nested
.finish:
  lea rsi, [rsi + 0x8]
  jmp .while
.end:
  pop rax
  pop rdi
  pop rsi
  leave
  ret
