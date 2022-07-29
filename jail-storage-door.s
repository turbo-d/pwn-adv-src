TERMINAL_INPUT = 0
TERMINAL_OUTPUT = 1
DOOR_CONTROL = 2

main:
	; Display initial message
	mov esi, message
	mov ecx, end_message - message
	mov dx, TERMINAL_OUTPUT
	rep outsb

.input_loop:
	; Grab next input
	in al, TERMINAL_INPUT
	cmp al, '0'
	jb .input_loop
	cmp al, '9'
	ja .input_loop

	; Rolling code for last 4 digits
	mov cl, [entered_code + 1]
	mov [entered_code], cl
	mov cl, [entered_code + 2]
	mov [entered_code + 1], cl
	mov cl, [entered_code + 3]
	mov [entered_code + 2], cl
	mov [entered_code + 3], al

	; Display updated code
	mov dx, TERMINAL_OUTPUT
	mov al, '\r'
	out dx, al
	mov esi, entered_code
	mov ecx, 4
	rep outsb

	; Check code
	mov esi, correct_code
	mov edi, entered_code
	mov ecx, 4
	repe cmpsb
	je .open_door

	jmp .input_loop

.open_door:
	; Send command to unlock door
	mov al, 1
	out DOOR_CONTROL, al

	; Show open message
	mov esi, open
	mov ecx, end_open - open
	mov dx, TERMINAL_OUTPUT
	rep outsb

	jmp .input_loop

correct_code:
	db "5129"

message:
	db "PIN code:\n"
end_message:

open:
	db "\rOPEN"
end_open:

.data
entered_code:
	db 0, 0, 0, 0
