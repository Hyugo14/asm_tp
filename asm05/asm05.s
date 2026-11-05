global _start

section .data
nl db 10

section .text
_start:
    cmp qword [rsp], 2
    jne badargs

    mov rsi, [rsp + 16]
    xor rdx, rdx

strlen:
    cmp byte [rsi + rdx], 0
    je strlen_done
    inc rdx
    jmp strlen

strlen_done:
    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall

    mov rax, 60
    mov rdi, 0
    syscall

badargs:
    mov rax, 60
    mov rdi, 2
    syscall