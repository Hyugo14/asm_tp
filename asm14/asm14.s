global _start

O_WRONLY equ 1
O_CREAT equ 64
O_TRUNC equ 512

section .data
msg db "Hello Universe!", 10
msglen equ $ - msg

section .text
_start:
    cmp qword [rsp], 2
    jne badargs

    mov rax, 2
    mov rdi, [rsp + 16]
    mov rsi, O_WRONLY | O_CREAT | O_TRUNC
    mov rdx, 0644o
    syscall
    cmp rax, 0
    jl fail

    mov rdi, rax
    mov rax, 1
    mov rsi, msg
    mov rdx, msglen
    syscall
    cmp rax, msglen
    jne fail

    mov rax, 60
    xor rdi, rdi
    syscall

fail:
    mov rax, 60
    mov rdi, 1
    syscall

badargs:
    mov rax, 60
    mov rdi, 2
    syscall