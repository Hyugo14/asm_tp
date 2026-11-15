global _start

section .bss
buf resb 4096
outbuf resb 24

section .text
_start:
    xor r12, r12

readloop:
    mov rax, 0
    mov rdi, 0
    mov rsi, buf
    mov rdx, 4096
    syscall
    cmp rax, 0
    jle print

    xor rcx, rcx

scan:
    movzx r8, byte [buf + rcx]
    or r8, 0x20
    cmp r8, 'a'
    je vowel
    cmp r8, 'e'
    je vowel
    cmp r8, 'i'
    je vowel
    cmp r8, 'o'
    je vowel
    cmp r8, 'u'
    jne next

vowel:
    inc r12

next:
    inc rcx
    cmp rcx, rax
    jl scan
    jmp readloop

print:
    mov rax, r12
    lea rdi, [outbuf + 23]
    mov byte [rdi], 10
    mov r11, 10

digits:
    xor rdx, rdx
    div r11
    add dl, '0'
    dec rdi
    mov [rdi], dl
    test rax, rax
    jnz digits

    mov rsi, rdi
    lea rdx, [outbuf + 24]
    sub rdx, rsi
    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall