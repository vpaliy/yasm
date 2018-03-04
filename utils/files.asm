%define SYS_nosys   0x2000000
%define SYS_exit    0x2000001
%define SYS_fork    0x2000002
%define SYS_read    0x2000003
%define SYS_write   0x2000004
%define SYS_open    0x2000005
%define SYS_close   0x2000006
%define SYS_brk     0x2000069

section .data
strQ:
  db  'Current program dat segment end addresss: %11X',0xA,0x0
strEL:
   db 'Size after brk +0x1000000: %llX',0xA,0x00

section .bss
  welcome: resb 1

section .text
  bits 64
  global _main
  extern _printf

_main:
default rel
  push rbp
  mov rbp, rsp

  mov rax, SYS_brk
  xor rdi, rdi
  syscall

  mov rdi, qword strQ
  mov rsi, rax
  call _printf

  mov rax, SYS_brk
  mov rdi, 0x1000
  syscall

  mov rdi, qword strQ
  mov rsi, rax
  call _printf

  mov rax, SYS_brk
  mov rdi, 0x10000
  syscall

  mov rdi, qword strQ
  mov rsi, rax
  call _printf

  mov rdi, qword welcome
debug:

  leave
  ret
