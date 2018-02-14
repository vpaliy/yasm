%define stdin       0
%define stdout      1
%define stderr      2

%define SYS_nosys   0x2000000
%define SYS_exit    0x2000001
%define SYS_fork    0x2000002
%define SYS_read    0x2000003
%define SYS_write   0x2000004

section .text
align 4
access.the.osx.kernel:
syscall
ret

%macro  system  1
mov rax, %1
call    access.the.osx.kernel
%endmacro

%macro  sys.exit    0
system  SYS_exit
%endmacro

%macro  sys.write   0
system  SYS_write
%endmacro
