global _start

section .bss
outbuf resb 24

section .text
_start:
    cmp qword [rsp], 3
    jne badargs

    mov rsi, [rsp + 16]
    call parse
    cmp r8, 0
    jne fail
    mov r12, rax

    mov rsi, [rsp + 24]
    call parse
    cmp r8, 0
    jne fail
    mov r13, rax

    mov rax, r12
    add rax, r13
    jo fail

    call print

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

parse:
    xor rax, rax
    xor rcx, rcx
    xor r9, r9
    xor r8, r8

    cmp byte [rsi], '-'
    jne parse_loop
    mov r9, 1
    mov rcx, 1
    cmp byte [rsi + 1], 0
    je parse_err

parse_loop:
    movzx r10, byte [rsi + rcx]
    cmp r10, 0
    je parse_done
    cmp r10, '0'
    jl parse_err
    cmp r10, '9'
    jg parse_err
    sub r10, '0'
    imul rax, 10
    jo parse_err
    cmp r9, 1
    je parse_sub
    add rax, r10
    jo parse_err
    jmp parse_next

parse_sub:
    sub rax, r10
    jo parse_err

parse_next:
    inc rcx
    jmp parse_loop

parse_done:
    cmp rcx, 0
    je parse_err
    ret

parse_err:
    mov r8, 1
    ret

print:
    lea rdi, [outbuf + 24]
    dec rdi
    mov byte [rdi], 10

    xor r9, r9
    cmp rax, 0
    jl print_loop
    mov r9, 1
    neg rax

print_loop:
    cqo
    mov r11, 10
    idiv r11
    neg rdx
    add rdx, '0'
    dec rdi
    mov [rdi], dl
    cmp rax, 0
    jne print_loop

    cmp r9, 1
    je print_out
    dec rdi
    mov byte [rdi], '-'

print_out:
    mov rsi, rdi
    lea rdx, [outbuf + 24]
    sub rdx, rsi
    mov rax, 1
    mov rdi, 1
    syscall
    ret