section .data
  array:            db 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36
  print_format:     db '%d',0xA

section .text
  bits 64
  extern _printf
  extern _scanf
  global _main
  global _bubble_sort

_main:
default rel
  push rbp
  mov rbp, rsp
  mov rax, qword array
  push rax
  push 0x7
;  call _bubble_sort
  add rsp, 0x10
  xor rbx, rbx
  mov rbx, qword array
  mov rax, [rbx]
  xor rcx, rcx
.while:
  cmp rcx, 0x7
  jge .end
  mov rsi, [rbx]
.debug:
  lea rdi, [print_format]
;  call _printf
  inc rcx
  jmp .while
.end:
  leave
  ret

_bubble_sort:
  push rbp
  mov rbp, rsp
  push rsi
  push rdi
  push rcx
  push rax
  mov rsi, [rbp + 0x18]   ; array
  mov rdi, [rbp + 0x10]   ; length
  xor rcx, rcx
.for:
  inc rcx
  cmp rcx, rdi
  jg .end
  mov rax, [rsi-0x1]
  cmp qword [rsi+0x1*rcx], rax
  jmp .for
.end:
  pop rax
  pop rcx
  pop rdi
  leave
  ret
