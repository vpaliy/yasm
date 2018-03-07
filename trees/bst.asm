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

; 1 - root node
%macro size 1
  mov rdi, %1
  call _size
%endmacro

; 1 - root node
%macro max_depth 1
  mov rdi, %1
  xor rax, rax
  call _max_depth
%endmacro

; 1 - root node
%macro min_depth 1
  mov rdi, %1
  call _min_depth
%endmacro

; 1 - root node
; 2 - key
%macro delete 2
  mov rdi, %1
  mov rsi, %2
  call _delete
%endmacro

; 1 - root node
%macro max 1
  mov rdi, %1
  call _max
%endmacro

; 1 - root node
%macro min 1
  mov rdi, %1
  call _min
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
  insert rax, 0x14, 0x10
  insert rax, 0x15, 0x10
  min_depth rax

  mov rdi, qword format
  mov rsi, rax
  xor rax, rax
  call _printf

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
; return: rax - the number of nodes
_size:
  push rbp
  mov rbp, rsp
  xor rax, rax
  push rdi
.for:
  ; if the stack is empty, then finish
  cmp rsp, rbp
  jge .done
  ; if the node is a leaf, then restart
  pop rdi
  cmp rdi, null
  je .for
  ; otherwise, increment the counter
  inc rax
  push qword [rdi + node.left]
  push qword [rdi + node.right]
  jmp .for
.done:
  leave
  ret

; rdi - root node
; return: rax - max depth
_max_depth:
  push rbp
  mov rbp, rsp
  ; if it's a leaf, then return
  xor rax, rax
  cmp rdi, null
  je .done

  inc rax
  ; allocate memory to keep the current size
  sub rsp, 0x10
  mov [rsp], rax
  mov [rsp + 0x8], rdi
  ; get the depth of the left subtree
  mov rdi, [rdi + node.left]
  call _max_depth
  ; save it
  mov r8, rax
  mov rax, [rsp]
  mov [rsp], r8
  ; move to the right subtree
  mov rdi, [rsp + 0x8]
  mov rdi, [rdi + node.right]
  ; put the initial length
  mov [rsp + 0x8], rax
  ; get the depth of the right subtree
  call _max_depth
  mov r8, [rsp]
  ; move the bigger value into r8
  cmp r8, rax
  cmovl r8, rax
  ; add to the initial depth
  mov rax, [rsp + 0x8]
  add rax, r8
  ; release stack
  add rsp, 0x10
.done:
  leave
  ret

; rdi - root node
; return: rax - max depth
_min_depth:
  push rbp
  mov rbp, rsp
  ; if it's a leaf, then return
  xor rax, rax
  cmp rdi, null
  je .done

  inc rax
  ; allocate memory to keep the current size
  sub rsp, 0x10
  mov [rsp], rax
  mov [rsp + 0x8], rdi
  ; get the depth of the left subtree
  mov rdi, [rdi + node.left]
  call _max_depth
  ; save it
  mov r8, rax
  mov rax, [rsp]
  mov [rsp], r8
  ; move to the right subtree
  mov rdi, [rsp + 0x8]
  mov rdi, [rdi + node.right]
  ; put the initial length
  mov [rsp + 0x8], rax
  ; get the depth of the right subtree
  call _max_depth
  mov r8, [rsp]
  ; move the bigger value into r8
  cmp r8, rax
  cmovg r8, rax
  ; add to the initial depth
  mov rax, [rsp + 0x8]
  add rax, r8
  ; release stack
  add rsp, 0x10
.done:
  leave
  ret

; rdi - root node
; return: rax - the max node
_max:
  push rbp
  mov rbp, rsp
.for:
  cmp [rdi + node.right], null
  je .done
  mov rdi, [rdi + node.right]
  jmp .for
.done:
  leave
  ret

; rdi - root node
; return: rax - the min node
_min:
  push rbp
  mov rbp, rsp
.for:
  cmp rdi, [rdi + node.left]
  je .done
  mov rdi, [rdi + node.left]
  jmp .for
.done:
  leave
  ret

; rdi - root node
_delete:
  push rbp
  mov rbp, rsp
  find rdi
  cmp rax, null
  je .done
  mov rdi, [rax + node.parent]
.for:
  cmp [rax + node.left], null
  ; if we have the
.done:
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
  show [rdi + node.left]

  ; show right subtree
  mov rdi, [rsp]
  show [rdi + node.right]
  add rsp, 0x10
.end:
  leave
  ret
