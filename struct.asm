section .data
struc Customer
  .id:       resb 1
  .name:     resb 64
  .address:  resb 64
  .balance:  resb 1
endstruc

struc Node
  .data:     resq 1
  .next:     resq 1
  .prev:     resq 1
endstruc

section .bss
  start:    resq 1

section .text
  bits 64
  extern _malloc
  global _main

_main:
default rel
  push rbp
  mov rbp, rsp
  call _create

  leave
  ret

_create:
  push rbp
  mov rbp, rsp
  push rdi
  mov rdi, Node_size
  call _malloc
  mov [rax + Node.next], 0x0  ; points to NULL
  mov [rax + Node.prev], 0x0  ; points to NULL
  mov [rax], 0x0              ; just 0 or NULL (depends on context)
  pop rdi
  leave
  ret

_random:
  push rbp
  mov rbp, rsp
  cmp rdi, 0x0  ; jump if the length is zero or negative
  jle .done
  call _create  ; create the first node
  push rax      ; store it in the stack
  mov rcx, rdi  ; store the length in rcx
.for:
  cmp rcx, 0x0
  jle .done
  mov rdi, rax   ; move the previous node
  call _create
  mov [rax + Node.prev, rdi
  mov [rdi + Node.next], 

.done:
  pop rax
  leave
  ret
