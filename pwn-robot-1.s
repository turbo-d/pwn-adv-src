ROBOT_INPUT = 0

mov esi, data
mov ecx, end - data
mov dx, ROBOT_INPUT
rep outsb

hlt

data:
    xor eax, eax
    mov al, SYS_WALK
    mov ebx, -1
    xor ecx, ecx
    int 0x80
    hlt
    db 0
end: