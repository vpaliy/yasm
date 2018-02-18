%include 'utils/arrays.inc'
%include 'utils/system.inc'

section .data
  string:     dq "()()()()",0xA
  print:      db '%d',0xA

section .text
  bits 64
  global _main

_main:
default rel
  push rbp
  mov rbp, rsp
  mov rax, qword string
  push rax
  call _parentheses
  add rsp, 0x8
  out qword format, rax ; prints -1
  leave
  ret

; checks for a balanced set of parentheses
; returns 0 if balanced
; -1 otherwise
_parentheses:
  push rbp
  mov rbp, rsp
  push rsi
  push r8
  xor rax, rax
  xor r8, r8
  mov rsi, [rbp + 0x10]
.while:
  cmp [rsi], byte 0xA
  je .end
  cmp [rsi],byte 0x0
  je .end
  cmp [rsi], byte 0x28  ;
  jne .elseif
  inc rax
  jmp .reset
.elseif:
  cmp [rsi], byte 0x29
  jne .reset
  inc r8
.reset:
  inc rsi
  jmp .while
.end:
  sub rax, r8
  mov r8, -1
  cmp rax, byte 0x0
  cmovnz rax, r8
  pop r8
  pop rsi
debug:
  leave
  ret
