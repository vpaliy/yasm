
; 1 - array
; 2 - length
_bubble:
  push rbp
  mov rbp, rsp
  push rsi
  push rdi
  mov rsi, [rbp + 0x18] ; array
  mov rdi, [rbp + 0x10] ; length
.while:
  cmp rsi, rdi
  jge .end
  mov rax, rsi
.inner:
  lea rax, [rax + 0x8]
  cmp rax, rdi
  jge .reset
  push rax
  mov rax, [rax]
  cmp [rsi], rax
  jmp .inner
.reset:
  lea rsi, [rsi + 0x8]
  jmp .while
.end:
  pop rdi
  pop rsi
  leave
  ret
