; Created by Vasyl Paliy 2018
; This file contains an implementation of a doubly linked list
; _create () - creates a node with null values.
; _append (node) - appends a node to the end of the passed node
; _reverse (node) - reverses the list
; _show(node) - prints

%define null 0x00000000

%macro salloc 1
  sub rsp, 0x10
  mov [rsp], %1
%endmacro

%macro sfree 1
  pop %1
  add rsp, 0x8
%endmacro

section .data
  struc node
    .info:        resq 1
    .next:        resq 1
    .prev:        resq 1
  endstruc

  format:   db '%d', 0xA, 0x0

section .text
  bits 64
  global _main
  global _create
  global _show
  global _append
  extern _printf
  extern _malloc

_main:

  push rbp
  mov rbp, rsp

  call _create

  mov rdi, rax
  mov rsi, 0x10
  call _append

  mov rdi, rax
  mov rsi, 0x11
  call _append

  mov rdi, rax
  mov rsi, 0x12
  call _append

  mov rdi, rax
  mov rsi, 0x13
  call _append

  mov rdi, rax
  call _reverse

  mov rdi, qword format
  mov rsi, rax
  call _show

  leave
  ret

; return: rax - node
_create:
  push rbp
  mov rbp, rsp
  ; allocate memory for local variables
  salloc rdi
  mov rdi, node_size
  call _malloc
  mov rdi, null
  ; make every field equal to null
  mov [rax + node.info], rdi
  mov [rax + node.next], rdi
  mov [rax + node.prev], rdi
  ; free stack memory
  sfree rdi
  leave
  ret

; rdi - node
; rsi - info
; return: rax - head node
; O(n) - time
_append:
  cmp rdi, null
  je .done
  push rbp
  mov rbp, rsp
  push r8
  push rsi
  call _create
  pop rsi
  push rdi
  mov r8, [rdi + node.next]
.for:
  cmp r8, null
  je .append
  mov rdi, [rdi + node.next]
  mov r8, [r8 + node.next]
  jmp .for
.append:
  mov [rdi + node.next], rax
  mov [rax + node.prev], rdi
  mov [rax + node.info], rsi
  pop rax
  pop r8
.done:
  leave
  ret

; rdi - head node
; return: rax - head node
; O(n) - time, O(1) - memory
_reverse:
  push rbp
  mov rbp, rsp
.for:
  cmp rdi, null
  je .done
  ; apply xor to swap node.next and node.prev
  mov r8, [rdi + node.next]
  xor r8, [rdi + node.prev]
  xor [rdi + node.prev], r8
  xor r8, [rdi + node.prev]
  mov [rdi + node.next], r8
  ; move the new head to rax
  mov rax, rdi
  ; go to next
  mov rdi, [rdi + node.prev]
  jmp .for
.done:
  leave
  ret


; rdi - format
; rsi - head node
_show:
.format equ 0x0
.node equ 0x8
  push rbp
  mov rbp, rsp
  sub rsp, 0x10
.for:
  cmp rsi, null
  je .done
  mov [rsp + .format], rdi
  mov [rsp + .node], rsi
  mov rsi, [rsi + node.info]
  xor rax, rax
  call _printf
  mov rdi, [rsp + .format]
  mov rsi, [rsp + .node]
  mov rsi, [rsi + node.next]
  jmp .for
.done:
  add rsp, 0x10
  leave
  ret
