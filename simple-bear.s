CMD_STOP = 100
CMD_PASSIVE = 101
CMD_AGGRESSIVE = 102
CMD_FURMWARE_UPDATE = 200

REPORT_ALIVE = 0
REPORT_SPOTTED = 1

IN_PORT = 0
OUT_PORT = 1

MIN_WAIT_TIME = 30
MAX_WAIT_TIME = 180
MIN_WALK_TIME = 60
MAX_WALK_TIME = 240
SCAN_DISTANCE = 120
ATTACK_TIME = 180

mov al, CMD_FURMWARE_UPDATE
out IN_PORT, al

mov esi, rom_update
mov ecx, end - rom_update
mov dx, IN_PORT

mov eax, ecx
out IN_PORT, al

rep outsb

hlt

rom_update:
.stop:
    mov ebx, 0
	mov ecx, 0
    mov eax, SYS_WALK
	int 0x80

    mov esi, 120

.stop_loop:
    pause
    dec esi
    jnz .stop_loop

.walk_right:
    mov ebx, 1
	mov ecx, 0
    mov eax, SYS_WALK
	int 0x80

    mov esi, 120

.walk_right_loop:
	pause
    dec esi
    jnz .walk_right_loop

.walk_left:
    mov ebx, -1
	mov ecx, 0
    mov eax, SYS_WALK
	int 0x80

    mov esi, 120

.walk_left_loop:
	pause
    dec esi
    jnz .walk_left_loop

	jmp .stop
end:
