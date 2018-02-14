section .data
  example:    db 'Hello', 0xA
  print:      db '%d',0xA

section .text
    bits 64
    global _main
    global _length
    extern _scanf
    extern _printf

_main:
default rel
  push rbp
  mov rbp, rsp
  mov rdi, qword example
  call _length
  lea rdi, [print]
  mov rsi, rax
  xor rax, rax
  call _printf
  xor rax, rax
  leave
  ret

_length:
  push rbp
  mov rbp, rsp
  mov rax, rdi
while:
  cmp [rdi], byte 0x0
  je exit
  cmp [rdi], byte 0xA
  je exit
  inc rdi
debug:
  jmp while
exit:
  sub rdi, rax
  mov rax, rdi
end:
  leave
  ret
