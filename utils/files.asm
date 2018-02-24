%define SYS_nosys   0x2000000
%define SYS_exit    0x2000001
%define SYS_fork    0x2000002
%define SYS_read    0x2000003
%define SYS_write   0x2000004
%define SYS_open    0x2000005
%define SYS_close   0x2000006

section .data
  file:       dq 'file.txt',0x0
  data:       dq 'Hello there!',0xA, 0x0
  length:     equ $-data

section .text
  bits 64
  global _main

_main:

  push rbp
  mov rbp, rsp
  sub rsp, 0x8
  ; open
  mov rax, SYS_open
  mov rdi, qword file
  mov rsi, 0x2
  or rsi, 0x40
  syscall


  ; write
  mov [rsp], rax
  mov rdi, rax
  mov rax, SYS_write
  mov rsi, qword data
  mov rdx, length
  syscall

  ; close
  mov rax, SYS_close
  mov rdi, [rsp]
  syscall

  add rsp, 0x8
  leave
  ret
