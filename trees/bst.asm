
%define null 0x00000000

section .data
  struc TreeNode
    .key:     resq 1
    .info:    resq 1
    .left:    resq 1
    .right:   resq 1
    .parent:  resq 1
  endstruc

  format:   db '%d',0xA,0x0
section .text
  global _main
  global _create
  global _insert
  extern _malloc
  extern _printf

_main:
  push rbp
  mov rbp, rsp

  call _create
  mov qword [rax + TreeNode.key], 0x18
  mov qword [rax + TreeNode.info], 0x10

  mov rdi, rax
  mov rsi, 0x24
  mov rdx, 0x10
  call _insert

  mov rdi, rax
  mov rsi, 0x19
  mov rdx, 0x10
  call _insert

  mov rdi, rax
  mov rsi, 0x17
  mov rdx, 0x10
  call _insert

  mov rdi, rax
  mov rsi, 0x16
  mov rdx, 0x10
  call _insert

  mov rdi, rax
  mov rsi, 0x15
  mov rdx, 0x10
  call _insert

  mov rdi, rax
  mov rsi, 0x20
  mov rdx, 0x10
  call _insert

  mov rdi, rax
  call _show

  leave
  ret

_create:
  push rbp
  mov rbp, rsp
  mov rdi, TreeNode_size
  xor rax, rax
  call _malloc
  mov rdi, null
  ; assign null to each field
  mov [rax + TreeNode.key], rdi
  mov [rax + TreeNode.info], rdi
  mov [rax + TreeNode.left], rdi
  mov [rax + TreeNode.right], rdi
  mov [rax + TreeNode.parent], rdi
  leave
  ret

; rdi - root node
; rsi - key
; rdx - info
; return: rax - root node
_insert:
  push rbp
  mov rbp, rsp
  push rdi
  push rdx
  push rsi
  push rdi
  call _create
  pop rdi
  pop rsi
  pop rdx
  mov r8, rdi
.for:
  cmp rdi, null
  je .leaf
  mov r8, rdi
  cmp [r8 + TreeNode.key], rsi
  jmp .lower
  mov rdi, [rdi + TreeNode.right]
  jmp .for
.lower:
  mov rdi, [rdi + TreeNode.left]
  jmp .for
.leaf:
  mov [rax + TreeNode.parent], r8
  mov [rax + TreeNode.key], rsi
  mov [rax + TreeNode.info], rdx
  cmp [r8 + TreeNode.key], rsi
  jge .left
  mov [r8 + TreeNode.right], rax
  jmp .done
.left:
  mov [r8 + TreeNode.left], rax
.done:
  pop rax
  leave
  ret

; 24, 23, 22, 21, 25, 24, 32
; rdi - root node
_show:
  push rbp
  mov rbp, rsp
  ; if null is reached, just leave
  cmp rdi, null
  je .done
  ; save rdi in stack
  sub rsp, 0x10
  mov [rsp], rdi

  ; print its key
  mov rsi, [rdi + TreeNode.key]
  mov rdi, qword format
  xor rax, rax
  call _printf

  ; show its left node
  mov rdi, [rsp]
  mov rdi, [rdi + TreeNode.left]
  call _show

  ; show its right node
  mov rdi, [rsp]
  mov rdi, [rdi + TreeNode.right]
  call _show

  ; release stack
  add rsp, 0x10
.done:
  leave
  ret
