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
  call ©
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

  create 0x20, 0x10
  insert rax, 0x21, 0x10
  insert rax, 0x10, 0x10
  insert rax, 0x11, 0x10
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

; rdi - root node
; rsi - key
_find:
  push rbp
  mov rbp, rsp
  mov rax, null
.for:
  cmp rdi, null
  je .done
  cmp [rdi + node.key], rsi
  je .found
  cmovg rdi, [rdi + node.left]
  cmovl rdi, [rdi + node.right]
  jmp .for
.found:
  mov rax, rdi
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
; return: rax - min depth
_min_depth:
  push rbp
  mov rbp, rsp
  ; if it's a leaf, just return
  xor rax, rax
  cmp rdi, null
  je .done

  sub rsp, 0x10
  mov [rsp], rdi
  mov rdi, [rdi + node.left]
  call _min_depth

  mov [rsp + 0x8], rax
  mov rdi, [rsp]
  mov rdi, [rdi + node.right]
  call _min_depth

  mov rdi, [rsp + 0x8]
  cmp rax, rdi
  cmovg rax, rdi
  inc rax

  add rsp, 0x10
.done:
  leave
  ret

; rdi - root node
; return: rax - max depth
_max_depth:
  push rbp
  mov rbp, rsp
  mov rdi, null
  je .done

  sub rsp, 0x10
  mov [rsp], rdi
  mov rdi, [rdi + node.left]
  call _max_depth

  mov rdi, [rsp]
  mov [rsp], rax
  mov rdi, [rdi + node.right]
  call _max_depth

  mov rdi, [rsp]
  cmp rax, rdi
  cmovl rax, rdi
  inc rax
  add rsp, 0x10
.done:
  leave
  ret

; rdi - root node
; return: rax - the max node
_max:
  push rbp
  mov rbp, rsp
  mov rax, rdi
  mov rdi, [rdi + node.right]
.for:
  cmp rdi, null
  je .done
  mov rax, rdi
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
  mov rax, rdi
  mov rdi, [rdi + node.left]
.for:
  cmp rdi, null
  je .done
  mov rax, rdi
  mov rdi, [rdi + node.left]
  jmp .for
.done:
  leave
  ret

; rdi - root node
; rsi - key
; return: rax - root node
_delete:
  push rbp
  mov rbp, rsp
  sub rsp, 0x10
  ; save the root node
  mov [rsp], rdi
  find rdi, rsi
  ; rdi contains the target node
  mov rdi, rax
  cmp [rdi + node.left], null
  je .right
  cmp [rdi + node.right], null
  je .left
  ; if both nodes aren't null, then work around the right node
  mov rax, [rdi + node.right]
.firstcase:
  ; find the very left node
  cmp [rax + node.left], null
  mov rax, [rax + node.left]
  je .firstcase
  ; when the left node is found,
  mov r8, [rax + node.parent]
  ; check if the parent is not the target node
  cmp r8, rdi
  je .endfirstcase
  ; save the target node to stack
  mov [rsp + 0x8], rdi
  mov rdi, [rax + node.parent]
  mov r8, [rax + node.right]
  mov [rdi + node.left], r8
  cmp r8, null
  je .afterright
  mov [r8 + node.parent], rdi
  mov [rax + node.right], null
.afterright:
  mov [rax + node.right], rdi
  mov [rdi + node.parent], rax
  mov rdi, [rsp + 0x8]
.endfirstcase:
  je .finish
.left:
  cmp [rdi + node.left], null
  je .finish
  mov rax, [rdi + node.left]
  jmp .finish
.right:
  cmp [rdi + node.right], null
  je .finish
  mov rax, [rdi + node.right]
.finish:
  ; rax contains the node that will replace the target node
  ; rdi contains the target node
  mov rdi, [rsp]
  cmp rax, rdi
  jne .done
  mov r8, [rdi + node.parent]
  mov [rax + node.parent], r8
  cmp r8, null
  je .done
  cmp [r8 + node.right], rdi
  jne .connectleft
  mov [r8 + node.right], rax
  jmp .done
.connectleft:
  mov [r8 + node.left], rax
.done:
  add rsp, 0x10
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
