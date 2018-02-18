
section .data
  format:    db "%d",0xA,0

section .text
  global _fill
  extern _random
  extern _printf
; fills an array of size N with random numbers
_fill:
.first equ  0x0
.last  equ  0x8
  push rbp
  mov rbp, rsp
  push rsi
  push rdx
  mov rsi, [rbp + 0x18] ; move the array into rsi
  mov rdx, [rbp + 0x10] ; move the length into rdx
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

; prints an array
_print:
.first equ 0x0
.last equ 0x8
  push rbp
  mov rbp, rsp
  push rsi
  push rdx
  mov rsi, [rbp + 0x18] ; move the array into rsi
  mov rdx, [rbp + 0x10] ; move the length into rdx
  lea rdx, [rsi + 0x8 * rdx]
  sub rsp, 0x10
.while:
  cmp rsi, rdx
  jge .end
  mov [rsp + .first], rsi
  mov [rsp + .last], rdx
  mov rdi, qword format
  mov rsi, [rsi]
  xor rax, rax
  call _printf
  mov rsi, [rsp + .first]
  mov rdx, [rsp + .last]
  lea rsi, [rsi + 0x8]
  jmp .while
.end:
  add rsp, 0x10
  pop rdx
  pop rsi
  leave
  ret
