global _start

section .bss
buf resb 1048576

section .text
_start:
    xor r12, r12

readloop:
    mov rax, 0
    mov rdi, 0
    lea rsi, [buf + r12]
    mov rdx, 1048576
    sub rdx, r12
    jz check
    syscall
    cmp rax, 0
    jle check
    add r12, rax
    jmp readloop

check:
    test r12, r12
    jz palindrome
    cmp byte [buf + r12 - 1], 10
    jne compare
    dec r12

compare:
    lea rsi, [buf]
    lea rdi, [buf + r12 - 1]

cloop:
    cmp rsi, rdi
    jae palindrome
    mov al, [rsi]
    cmp al, [rdi]
    jne notpalindrome
    inc rsi
    dec rdi
    jmp cloop

palindrome:
    mov rax, 60
    xor rdi, rdi
    syscall

notpalindrome:
    mov rax, 60
    mov rdi, 1
    syscall