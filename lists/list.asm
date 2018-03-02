section .data
  ; The basic unit of the linked list
  ; Contains three 8 byte pointers
  struc node
    .info:    resq 1  ; data pointer
    .next:    resq 1  ; points to the next
    .prev:    resq 1  ; points to the previous
  endstruc

  format:     db "%d", 0xA,0x0

%define NULL 0x00000000

section .text
  bits 64
  global _main
  global _create
  global _random
  global _show
  extern _malloc
  extern _printf

_main:
default rel
  push rbp
  mov rbp, rsp

  call _create

  mov rdi, rax
  mov rsi, 0x1
  call _append

  mov rdi, rax
  mov rsi, 0x2
  call _append

  mov rdi, rax
  mov rsi, 0x3
  call _append

  mov rdi, rax
  mov rsi, 0x4
  call _append

  mov rdi, qword format
  mov rsi, rax
  call _show

  leave
  ret

; create an empty node
; return: rax - node
_create:
  push rbp
  mov rbp, rsp
  sub rsp, 0x10
  mov [rsp], rdi
  mov rdi, node_size
  call _malloc
  mov rdi, NULL
  mov [rax + node.info], rdi  ; node.info is 0 of NULL (depends on context)
  mov [rax + node.next], rdi  ; node.next is NULL
  mov [rax + node.prev], rdi  ; node.prev is NULL
  mov rdi, [rsp]
  add rsp, 0x10
  leave
  ret

; rdi - head node
; rsi - info
; return: rax - head node
_append:
  push rbp
  mov rbp, rsp
  sub rsp, 0x10
  push rdi
  push rsi
  call _create
  pop rsi
  mov rdi, [rsp]
.while:
  mov r8, [rdi + node.next]
  cmp r8, NULL
  je .done
  mov rdi, r8
  jmp .while
.done
  mov [rdi + node.next], rax
  mov [rax + node.prev], rdi
  mov [rax + node.info], rsi
  pop rax
  leave
  ret

; rdi - format
; rsi - head node
; return: none
_show:
.format equ 0x0
.node   equ 0x8
  push rbp
  mov rbp, rsp
  sub rsp, 0x10
.for:
  cmp rsi, NULL
  je .done
  mov rax, [rsi + node.next]
  mov [rsp + .format], rdi
  mov [rsp + .node], rax
  mov rsi, [rsi]
  xor rax, rax
  call _printf
  mov rdi, [rsp + .format]
  mov rsi, [rsp + .node]
  jmp .for
.done:
  leave
  ret
