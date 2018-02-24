; Created by Vasyl Paliy
; 2018

; rdi - string
; rax - length + zerp byte
_length:
  mov rax, rdi
.while:
  cmp [rdi], byte 0x0
  lea rdi, [rdi + 0x1]
  jne .while
.end:
  sub rdi, rax
  mov rax, rdi
  ret

; rdi - string
; rsi - element (not a string)
; rax - (0 - absent, 1 - contains)
; works only for ASCII
_contains:
  xor rax, rax
.while:
  cmp [rdi], byte 0x0
  je .end
  cmp [rdi], byte sil
  lea rdi, [rdi + 0x1]
  jne .while
  mov rax, 0x1
.end:
  ret

; rdi - string
; rsi - element (not a string)
; works only for ASCII
_index_of:
  xor rax, rax
.while:
  cmp [rdi], byte 0x0
  je .end
  cmp [rdi], byte sil
  je .end
  inc rax
  inc rdi
  jmp .while
.end:
  ret
