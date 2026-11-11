global _start

section .bss
buf resb 32

section .text
_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buf
    mov rdx, 32
    syscall

    cmp rax, 0
    jle notnum

    mov rcx, rax
    cmp byte [buf + rcx - 1], 10
    jne nostrip
    dec rcx

nostrip:
    xor rsi, rsi
    xor r8, r8
    xor r9, r9
    cmp byte [buf], '-'
    jne checklen
    mov r8, 1
    mov rsi, 1

checklen:
    cmp rcx, rsi
    jle notnum

scan:
    cmp rsi, rcx
    jge scandone
    movzx r10, byte [buf + rsi]
    cmp r10, '0'
    jl notnum
    cmp r10, '9'
    jg notnum
    sub r10, '0'
    imul r9, r9, 10
    add r9, r10
    inc rsi
    jmp scan

scandone:
    cmp r8, 1
    je notprime

    cmp r9, 2
    jl notprime
    je prime
    test r9, 1
    jz notprime

    mov rbx, 3

ploop:
    mov rax, r9
    cqo
    idiv rbx
    cmp rbx, rax
    jg prime
    cmp rdx, 0
    je notprime
    add rbx, 2
    jmp ploop

prime:
    mov rax, 60
    mov rdi, 0
    syscall

notprime:
    mov rax, 60
    mov rdi, 1
    syscall

notnum:
    mov rax, 60
    mov rdi, 2
    syscall