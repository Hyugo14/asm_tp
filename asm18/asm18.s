global _start

AF_INET equ 2
SOCK_DGRAM equ 2
SOL_SOCKET equ 1
SO_RCVTIMEO equ 20

section .data
request db "ping", 10
reqlen equ $ - request

server:
    dw AF_INET
    db 0x05, 0x39
    db 127, 0, 0, 1
    times 8 db 0

timeval:
    dq 1
    dq 0

section .bss
buf resb 65536

section .text
_start:
    mov rax, 41
    mov rdi, AF_INET
    mov rsi, SOCK_DGRAM
    xor rdx, rdx
    syscall
    cmp rax, 0
    jl fail
    mov r12, rax

    mov rax, 54
    mov rdi, r12
    mov rsi, SOL_SOCKET
    mov rdx, SO_RCVTIMEO
    mov r10, timeval
    mov r8, 16
    syscall
    cmp rax, 0
    jl fail

    mov rax, 44
    mov rdi, r12
    mov rsi, request
    mov rdx, reqlen
    xor r10, r10
    mov r8, server
    mov r9, 16
    syscall
    cmp rax, 0
    jl fail

    mov rax, 45
    mov rdi, r12
    mov rsi, buf
    mov rdx, 65536
    xor r10, r10
    xor r8, r8
    xor r9, r9
    syscall
    cmp rax, 0
    jl fail

    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, buf
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

fail:
    mov rax, 60
    mov rdi, 1
    syscall