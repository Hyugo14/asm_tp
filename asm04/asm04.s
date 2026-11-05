global _start

section .bss
buf resb 64

section .text
_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buf
    mov rdx, 64
    syscall

    cmp rax, 0
    jle notnum

    mov rcx, rax

    cmp byte [buf + rcx - 1], 10
    jne nostrip
    dec rcx
nostrip:
    cmp rcx, 0
    je notnum

    xor rbx, rbx
    cmp byte [buf], '-'
    jne checkloop
    mov rbx, 1
    cmp rcx, 1
    jle notnum

checkloop:
    cmp rbx, rcx
    jge done
    movzx rax, byte [buf + rbx]
    cmp rax, '0'
    jl notnum
    cmp rax, '9'
    jg notnum
    inc rbx
    jmp checkloop

done:
    movzx rax, byte [buf + rcx - 1]
    sub rax, '0'
    and rax, 1
    cmp rax, 0
    jne odd

    mov rax, 60
    mov rdi, 0
    syscall

odd:
    mov rax, 60
    mov rdi, 1
    syscall

notnum:
    mov rax, 60
    mov rdi, 2
    syscall