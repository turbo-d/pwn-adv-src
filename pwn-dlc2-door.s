TERMINAL_INPUT = 0

main:
    mov esi, seed
    mov ecx, end_seed - seed
    mov dx, TERMINAL_INPUT
    rep outsb

    mov esi, seed
    mov ecx, 0

    mov edx, 0xfa
    mov al, [esi]
    rol edx, 5
    xor dl, al
    add dl, 0xab
    mov al, [esi+1]
    rol edx, 3
    xor dl, al
    add dl, 0x45
    mov al, [esi+2]
    rol edx, 1
    xor dl, al
    add dl, 0x12
    mov al, [esi+3]
    rol edx, 9
    xor dl, al
    add dl, 0xcd
    mov cl, dl
    and cl, 15
    add cl, 'a'
    call print_cl

    rol edx, 12
    xor dl, cl
    add dl, 0x87
    mov cl, dl
    and cl, 15
    add cl, 'a'
    call print_cl

    rol edx, 3
    xor dl, cl
    add dl, 0xef
    mov cl, dl
    and cl, 15
    add cl, 'C'
    call print_cl

    rol edx, 1
    xor dl, cl
    add dl, 0x10
    mov cl, dl
    and cl, 15
    add cl, 'f'
    call print_cl

    rol edx, 13
    xor dl, cl
    add dl, 0x9a
    mov cl, dl
    and cl, 15
    add cl, 'e'
    call print_cl

    rol edx, 9
    xor dl, cl
    add dl, 0xa8
    mov cl, dl
    and cl, 15
    add cl, 'D'
    call print_cl

    rol edx, 7
    xor dl, cl
    add dl, 0xca
    mov cl, dl
    and cl, 15
    add cl, 'D'
    call print_cl

    rol edx, 2
    xor dl, cl
    add dl, 0x91
    mov cl, dl
    and cl, 15
    add cl, 'c'
    call print_cl

    rol edx, 5
    xor dl, cl
    add dl, 0x86
    mov cl, dl
    and cl, 15
    add cl, 'A'
    call print_cl

    rol edx, 6
    xor dl, cl
    add dl, 0xf1
    mov cl, dl
    and cl, 15
    add cl, 'e'
    call print_cl

    rol edx, 3
    xor dl, cl
    add dl, 0x1f
    mov cl, dl
    and cl, 15
    add cl, 'B'
    call print_cl

    rol edx, 4
    xor dl, cl
    add dl, 0x90
    mov cl, dl
    and cl, 15
    add cl, 'f'
    call print_cl

    mov esi, newline
    mov ecx, end_newline - newline
    mov dx, TERMINAL_INPUT
    rep outsb

    hlt

print_cl:
    push eax

    mov al, cl
    out TERMINAL_INPUT, al

    pop eax

    ret

seed:
	db "aaaa"
end_seed:

newline:
    db "\n"
end_newline: