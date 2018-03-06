; Created by Vasyl Paliy

%define null 0x00000000

; 1 - root node
; 2 - key
; 3 - value
%macro insert 3
  mov rdi, %2
  mov rsi, %3
  mov rdx, %1
  call _insert
%endmacro

; 1 - root node
; 2 - search key
%macro find 2
  mov rdi, %1
  mov rsi, %2
  call _find
%endmacro

; 1 - key
; 2 - value
%macro create 2
  mov rdi, %1
  mov rsi, %2
  call _create
%endmacro

%macro show 1
  mov rdi, %1
  call _show
%endmacro

section .data
  struc node
    .key:       resq 1
    .info:      resq 1
    .left:      resq 1
    .right:     resq 1
    .parent:    resq 1
  endstruc
  format:       db '%d',0xA,0x0

section .text
  bits 64
  global _main
  global _insert
  global _new
  extern _malloc
  extern _printf

;  16, 8, 7, 10, 18, 17, 19
_main:
  push rbp
  mov rbp, rsp

  create 0x10, 0x10
  insert rax, 0x8, 0x10
  insert rax , 0x7, 0x10
  insert rax, 0xA, 0x10
  insert rax, 0x12, 0x10
  insert rax, 0x11, 0x10
  insert rax, 0x13, 0x10
  show rax

  leave
  ret

; no parameters
; return: rax - new empty node
_new:
  push rbp
  mov rbp, rsp
  mov rdi, node_size
  call _malloc
  mov rdi, null
  mov [rax + node.key], rdi
  mov [rax + node.info], rdi
  mov [rax + node.left], rdi
  mov [rax + node.right], rdi
  mov [rax + node.parent], rdi
  leave
  ret

; rdi - key
; rsi - info
_create:
  push rbp
  mov rbp, rsp
  push rdi
  push rsi
  call _new
  pop rsi
  pop rdi
  mov [rax + node.key], rdi
  mov [rax + node.info], rsi
  leave
  ret

; rdi - node
; rsi - key
; return: rax - node that contains the key
_find:
  push rbp
  mov rbp, rsp
  mov rax, null
.while:
  cmp rdi, null
  je .done
  cmp [rdi + node.key], rsi
  jg .goleft
  jl .goright
  mov rax, rdi
  jmp .done
.goleft:
  mov rdi, [rdi + node.left]
  jmp .while
.goright:
  mov rdi, [rdi + node.right]
  jmp .while
.done:
  leave
  ret

; rdi - key
; rsi - info
; rdx - node
; return: rax - root node
_insert:
  push rbp
  mov rbp, rsp
  push rdx
  push rdx
  mov [rsp], rdx
  call _create
  pop rdx
  mov r8, rdx
.for:
  cmp rdx, null
  je .insert
  mov r8, rdx
  cmp [rdx + node.key], rdi
  jle .goright
  jg  .goleft
.goleft:
  mov rdx, [rdx + node.left]
  jmp .for
.goright:
  mov rdx, [rdx + node.right]
  jmp .for
.insert:
  mov [rax + node.parent], r8
  cmp [r8 + node.key], rdi
  jle .right
  je  .left
.left:
  mov [r8 + node.left], rax
  jmp .end
.right:
  mov [r8 + node.right], rax
.end:
  pop rax
  leave
  ret

; rdi - root node
_show:
  push rbp
  mov rbp, rsp
  cmp rdi, null
  je .end
  sub rsp, 0x10
  mov [rsp], rdi

  mov rsi, [rdi + node.key]
  mov rdi, qword format
  call _printf

  ; show left subtree
  mov rdi, [rsp]
  mov rdi, [rdi + node.left]
  call _show

  ; show right subtree
  mov rdi, [rsp]
  mov rdi, [rdi + node.right]
  call _show

  add rsp, 0x10
.end:
  leave
  ret
