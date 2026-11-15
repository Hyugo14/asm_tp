global _start

section .bss
buf resb 24

section .text
_start:
    cmp qword [rsp], 4
    jne badargs

    mov rsi, [rsp + 16]
    call parse
    mov r12, rax

    mov rsi, [rsp + 24]
    call parse
    cmp rax, r12
    cmovg r12, rax

    mov rsi, [rsp + 32]
    call parse
    cmp rax, r12
    cmovg r12, rax

    mov rax, r12
    lea rdi, [buf + 23]
    mov byte [rdi], 10
    mov r11, 10
    test rax, rax
    jl digits
    neg rax

digits:
    cqo
    idiv r11
    neg rdx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    test rax, rax
    jnz digits

    test r12, r12
    jns output
    dec rdi
    mov byte [rdi], '-'

output:
    mov rsi, rdi
    lea rdx, [buf + 24]
    sub rdx, rsi
    mov rax, 1
    mov rdi, 1
    syscall

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

parse:
    xor rax, rax
    xor rcx, rcx
    xor r9, r9
    cmp byte [rsi], '-'
    jne scan
    mov r9, 1
    mov rcx, 1

scan:
    movzx r10, byte [rsi + rcx]
    test r10, r10
    jz scandone
    cmp r10, '0'
    jl fail
    cmp r10, '9'
    jg fail
    sub r10, '0'
    imul rax, rax, 10
    jo fail
    test r9, r9
    jnz negdigit
    add rax, r10
    jo fail
    inc rcx
    jmp scan

negdigit:
    sub rax, r10
    jo fail
    inc rcx
    jmp scan

scandone:
    cmp rcx, r9
    je fail
    ret