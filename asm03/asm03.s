global _start

section .data
msg db "1337", 10
msglen equ $ - msg

section .text
_start:
    cmp qword [rsp], 2
    jne badargs

    mov rsi, [rsp + 16]

    cmp byte [rsi], '4'
    jne fail
    cmp byte [rsi + 1], '2'
    jne fail
    cmp byte [rsi + 2], 0
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

badargs:
    mov rax, 60
    mov rdi, 2
    syscall