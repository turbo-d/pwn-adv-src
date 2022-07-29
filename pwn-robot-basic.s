ROBOT_INPUT = 0

mov esi, data
mov ecx, end - data
mov dx, ROBOT_INPUT
rep outsb

hlt

data:
.walk_down:
    xor eax, eax
    mov al, SYS_WALK
    xor ebx, ebx
    xor ecx, ecx
    inc ecx
	int 0x80

    xor esi, esi
	add esi, 16

.walk_down_loop:
	pause
    dec esi
    jnz .walk_down_loop

.walk_right:
    xor eax, eax
    mov al, SYS_WALK
    xor ebx, ebx
    inc ebx
    xor ecx, ecx
	int 0x80

    xor esi, esi
	add esi, 120

.walk_right_loop:
	pause
    dec esi
    jnz .walk_right_loop

    jmp .walk_down

    db 0
end: