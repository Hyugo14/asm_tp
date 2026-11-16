global _start

section .bss
buf resb 1048577

section .text
_start:
    xor r12, r12

readloop:
    mov rax, 0
    mov rdi, 0
    lea rsi, [buf + r12]
    mov rdx, 1048576
    sub rdx, r12
    jz reverse
    syscall
    cmp rax, 0
    jle reverse
    add r12, rax
    jmp readloop

reverse:
    test r12, r12
    jz output
    cmp byte [buf + r12 - 1], 10
    jne swapinit
    dec r12

swapinit:
    lea rsi, [buf]
    lea rdi, [buf + r12 - 1]

swap:
    cmp rsi, rdi
    jae output
    mov al, [rsi]
    mov bl, [rdi]
    mov [rsi], bl
    mov [rdi], al
    inc rsi
    dec rdi
    jmp swap

output:
    mov byte [buf + r12], 10
    lea rdx, [r12 + 1]
    mov rax, 1
    mov rdi, 1
    mov rsi, buf
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall