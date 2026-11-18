global _start

O_RDWR equ 2

section .bss
buf resb 65536

section .text
_start:
    cmp qword [rsp], 2
    jne badargs

    mov rax, 2
    mov rdi, [rsp + 16]
    mov rsi, O_RDWR
    syscall
    cmp rax, 0
    jl fail
    mov r12, rax

    mov rax, 0
    mov rdi, r12
    mov rsi, buf
    mov rdx, 65536
    syscall
    cmp rax, 4
    jl fail

    lea r13, [rax - 3]
    xor r14, r14
    xor rbx, rbx

search:
    cmp rbx, r13
    jge done
    cmp dword [buf + rbx], '1337'
    jne next

    mov dword [buf + rbx], 'H4CK'
    mov rax, 18
    mov rdi, r12
    lea rsi, [buf + rbx]
    mov rdx, 4
    mov r10, rbx
    syscall
    cmp rax, 4
    jne fail

    inc r14
    add rbx, 4
    jmp search

next:
    inc rbx
    jmp search

done:
    test r14, r14
    jz fail

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