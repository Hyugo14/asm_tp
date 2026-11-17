global _start

section .bss
buf resb 4096

section .text
_start:
    cmp qword [rsp], 2
    jne badargs

    mov rsi, [rsp + 16]
    call parse

    cqo
    mov rcx, 26
    idiv rcx
    test rdx, rdx
    jns keyready
    add rdx, 26

keyready:
    mov r12, rdx

readloop:
    mov rax, 0
    mov rdi, 0
    mov rsi, buf
    mov rdx, 4096
    syscall
    cmp rax, 0
    jle done

    mov r13, rax
    xor rcx, rcx

shift:
    mov al, [buf + rcx]
    mov bl, 'a'
    cmp al, 'a'
    jb tryupper
    cmp al, 'z'
    jbe rotate
    jmp next

tryupper:
    mov bl, 'A'
    cmp al, 'A'
    jb next
    cmp al, 'Z'
    ja next

rotate:
    sub al, bl
    add al, r12b
    cmp al, 26
    jb nowrap
    sub al, 26

nowrap:
    add al, bl
    mov [buf + rcx], al

next:
    inc rcx
    cmp rcx, r13
    jb shift

    mov rax, 1
    mov rdi, 1
    mov rsi, buf
    mov rdx, r13
    syscall
    jmp readloop

done:
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