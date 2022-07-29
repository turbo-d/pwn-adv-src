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
	mov eax, SYS_RAND
	int 0x80
	mov [.id], eax

	; Randomize keep alive timing
	and eax, 63
	mov dword [.keep_alive_time], eax

	mov byte [.mode], CMD_STOP

.stop:
	mov eax, SYS_WALK
	xor ebx, ebx
	xor ecx, ecx
	int 0x80
	pause
	jmp .process_commands
.end_process_commands:
	cmp byte [.mode], CMD_STOP
	jmp .stop


.process_commands:

	; Check if time for alive report
	cmp dword [.keep_alive_time], 0
	jnz .check_for_command

	; Send alive report to controller
	mov byte [.report_buffer], REPORT_ALIVE
	mov eax, [.id]
	mov [.report_buffer + 1], eax
	mov al, [.mode]
	mov [.report_buffer + 5], al
	mov eax, SYS_WRITE
	mov ebx, OUT_PORT
	mov ecx, .report_buffer
	mov edx, 6
	int 0x80

	mov dword [.keep_alive_time], 120

.check_for_command:
	dec dword [.keep_alive_time]

	; See if a command byte is available
	mov eax, SYS_CAN_READ
	mov ebx, IN_PORT
	mov ecx, 1
	int 0x80
	test eax, eax
	jz .done

	; Grab the command byte
	in al, IN_PORT
	mov cl, al
	cmp al, CMD_FURMWARE_UPDATE
	je .update

	; Grab the target id
	in eax, IN_PORT
	; Check for broadcast
	cmp eax, 0xffffffff
	je .do_command
	cmp eax, [.id]
	jne .done

.do_command:
	mov byte [.mode], CMD_STOP
	jmp .done

.update:
	in ax, IN_PORT
	movzx edx, ax
	mov eax, SYS_READ
	mov ebx, 0
	mov ecx, .update_buffer
	int 0x80
	mov eax, SYS_ROM_UPDATE
	mov ebx, ecx
	mov ecx, edx
	int 0x80

.done:
	jmp .end_process_commands


.directions:
dd 1, 0
dd -1, 0
dd 0, 1
dd 0, -1

;.data
.id:
dd 0

.keep_alive_time:
dd 0

.report_buffer:
db 0
dd 0
db 0

.mode:
db 0

.update_buffer:
end:
