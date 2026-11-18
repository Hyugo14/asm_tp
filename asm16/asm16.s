global _start

ELFCLASS64 equ 2
EM_X86_64 equ 62

section .bss
header resb 64

section .text
_start:
    cmp qword [rsp], 2
    jne error

    mov rax, 2
    mov rdi, [rsp + 16]
    xor rsi, rsi
    syscall
    cmp rax, 0
    jl error

    mov rdi, rax
    mov rax, 0
    mov rsi, header
    mov rdx, 64
    syscall
    cmp rax, 0
    jl error

    cmp dword [header], `\x7FELF`
    jne notelf
    cmp byte [header + 4], ELFCLASS64
    jne notelf
    cmp word [header + 18], EM_X86_64
    jne notelf

    mov rax, 60
    xor rdi, rdi
    syscall

notelf:
    mov rax, 60
    mov rdi, 1
    syscall

error:
    mov rax, 60
    mov rdi, 2
    syscall