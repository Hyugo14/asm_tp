global _start

section .bss
outbuf resb 24

section .text
_start:
    cmp qword [rsp], 2
    jne badargs

    mov rsi, [rsp + 16]
    xor rcx, rcx
    xor r8, r8
    xor r9, r9

    cmp byte [rsi], '-'
    jne scan
    mov r8, 1
    mov rcx, 1

scan:
    movzx r10, byte [rsi + rcx]
    cmp r10, 0
    je scandone
    cmp r10, '0'
    jl fail
    cmp r10, '9'
    jg fail
    sub r10, '0'
    imul r9, r9, 10
    jo fail
    add r9, r10
    jo fail
    inc rcx
    jmp scan

scandone:
    cmp rcx, r8
    je fail
    cmp r8, 1
    je zero
    cmp r9, 1
    jle zero

    mov rax, r9
    dec rax
    mov rbx, r9
    test rax, 1
    jnz oddfirst
    shr rax, 1
    jmp scale

oddfirst:
    shr rbx, 1

scale:
    imul rax, rbx
    jo fail
    jmp print

zero:
    xor rax, rax

print:
    lea rdi, [outbuf + 24]
    dec rdi
    mov byte [rdi], 10

ploop:
    xor rdx, rdx
    mov r11, 10
    div r11
    add rdx, '0'
    dec rdi
    mov [rdi], dl
    test rax, rax
    jnz ploop

    mov rsi, rdi
    lea rdx, [outbuf + 24]
    sub rdx, rsi
    mov rax, 1
    mov rdi, 1
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