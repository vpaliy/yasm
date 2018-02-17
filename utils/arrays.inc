
section .text
  global _fill
  extern _random

; fills an array of size N with random numbers
_fill:
.first equ  0x0
.last  equ  0x10
  push rbp
  mov rbp, rsp
  push rsi
  push rdx
  mov rsi, [rbp + 0x10]
  mov rdx, [rbp + 0x18]
  lea rdx, [rsi + 0x8 * rdx] ;  assuming all elements are 8 bytes long
  sub rsp, 0x10
.while:
  cmp rsi, rdx
  jge .end
  mov [rsp + .first], rsi
  mov [rsp + .last], rdx
  call _random
  mov rsi, [rsp + .first]
  mov rdx, [rsp + .last]
  mov [rsi], rax
  lea rsi, [rsi + 0x8]  ; move on to the next element
  jmp .while
.end:
  add rsp, 0x10
  pop rdx
  pop rsi
  leave
  ret
