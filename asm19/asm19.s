global _start

AF_INET equ 2
SOCK_DGRAM equ 2
O_WRONLY equ 1
O_CREAT equ 64
O_TRUNC equ 512

section .data
banner db "Listening on port 1337", 10
bannerlen equ $ - banner
logname db "messages", 0

address:
    dw AF_INET
    db 0x05, 0x39
    db 0, 0, 0, 0
    times 8 db 0

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

    mov rax, 49
    mov rdi, r12
    mov rsi, address
    mov rdx, 16
    syscall
    cmp rax, 0
    jl fail

    mov rax, 2
    mov rdi, logname
    mov rsi, O_WRONLY | O_CREAT | O_TRUNC
    mov rdx, 0644o
    syscall
    cmp rax, 0
    jl fail
    mov r13, rax

    mov rax, 1
    mov rdi, 1
    mov rsi, banner
    mov rdx, bannerlen
    syscall

receive:
    mov rax, 45
    mov rdi, r12
    mov rsi, buf
    mov rdx, 65536
    xor r10, r10
    xor r8, r8
    xor r9, r9
    syscall
    cmp rax, 0
    jl receive

    mov rdx, rax
    mov rax, 1
    mov rdi, r13
    mov rsi, buf
    syscall
    jmp receive

fail:
    mov rax, 60
    mov rdi, 1
    syscall