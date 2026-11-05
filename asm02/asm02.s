global _start

section .bss
buf resb 16

section .data
msg db "1337", 10
msglen equ $ - msg

section .text
_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buf
    mov rdx, 16
    syscall

    cmp rax, 3
    jne fail

    movzx ecx, byte [buf]
    cmp ecx, '4'
    jne fail

    movzx ecx, byte [buf + 1]
    cmp ecx, '2'
    jne fail

    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msglen
    syscall

    mov rax, 60
    mov rdi, 0
    syscall

fail:
    mov rax, 60
    mov rdi, 1
    syscall