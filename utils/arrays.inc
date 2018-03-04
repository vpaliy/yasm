
section .data
  format:    db "%d",0xA,0
  eof:       db 0xA,0

section .text
  global _fill
  global _min
  global _max
  global _print
  extern _random
  extern _printf

; 1 - array
; 2 - length
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
  push rdi
  mov rsi, [rbp + 0x18] ; move the array into rsi
  mov rdx, [rbp + 0x10] ; move the length into rdx
  lea rdx, [rsi + 0x8 * rdx]
  sub rsp, 0x18   ; stack frame should be aligned to a 16 byte boundary
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
  mov rdi, qword eof
  xor rax, rax
  call _printf
  add rsp, 0x18
  pop rdi
  pop rdx
  pop rsi
  leave
  ret

; finds min value in an array
; rsi - array
; rdi - length
_min:
  mov rax, [rsi]
  mov rcx, 0x1
.while:
  cmp rcx, rdi
  jge .end
  mov rbx, [rsi + 0x8 * rcx]
  cmp rbx, rax
  cmovl rax, rbx
  inc rcx
  jmp .while
.end:
  ret

; finds max value in an array
; rsi - array
; rdi - length
_max:
  mov rax, [rsi]
  mov rcx, 0x1
.while:
  cmp rcx, rdi
  jge .end
  mov rbx, [rsi + 0x8 * rcx]
  cmp rbx, rax
  cmovg rax, rbx
  inc rcx
  jmp .while
.end:
  ret
