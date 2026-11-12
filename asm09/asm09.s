global _start

section .data
hex db "0123456789ABCDEF"

section .bss
buf resb 80

section .text
_start:
    mov rsi, [rsp + 16]
    mov r12, 15
    mov rcx, 4
    mov rax, [rsp]
    cmp rax, 2
    je parse
    cmp rax, 3
    jne badusage
    cmp byte [rsi], '-'
    jne badusage
    cmp byte [rsi + 1], 'b'
    jne badusage
    cmp byte [rsi + 2], 0
    jne badusage
    mov r12, 1
    mov rcx, 1
    mov rsi, [rsp + 24]

parse:
    xor rbx, rbx
    xor r8, r8
    xor r9, r9
    cmp byte [rsi], '-'
    jne scan
    mov r8, 1
    mov rbx, 1

scan:
    movzx r10, byte [rsi + rbx]
    test r10, r10
    jz scandone
    cmp r10, '0'
    jl fail
    cmp r10, '9'
    jg fail
    sub r10, '0'
    imul r9, r9, 10
    jo fail
    sub r9, r10
    jo fail
    inc rbx
    jmp scan

scandone:
    cmp rbx, r8
    je fail
    neg r9
    jno checkzero
    cmp r8, 1
    jne fail

checkzero:
    test r9, r9
    jnz convert
    xor r8, r8

convert:
    lea rdi, [buf + 80]
    dec rdi
    mov byte [rdi], 10

cloop:
    mov rax, r9
    and rax, r12
    mov al, [hex + rax]
    dec rdi
    mov [rdi], al
    shr r9, cl
    jnz cloop

    cmp r8, 1
    jne output
    dec rdi
    mov byte [rdi], '-'

output:
    mov rsi, rdi
    lea rdx, [buf + 80]
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

badusage:
    mov rax, 60
    mov rdi, 2
    syscall