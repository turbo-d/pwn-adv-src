TERMINAL_INPUT = 0
TERMINAL_OUTPUT = 1
SECURE_PIN_STORAGE = 2
DOOR_CONTROL = 3

main:
.correct_pin = 0
	sub esp, 32

	; Fetch PIN from secure memory
	lea edi, [esp + .correct_pin]
	push edi
	call get_secure_pin
	add esp, 4

.main_loop:
	push edi
	call ask_and_verify_pin
	add esp, 4
	test al, al
	jz .invalid

	call open_door
	jmp .main_loop

.invalid:
	; Show denied message
	mov esi, invalid
	mov ecx, end_invalid - invalid
	mov dx, TERMINAL_OUTPUT
	rep outsb

	call sleep
	jmp .main_loop


ask_and_verify_pin:
; Args
.correct_pin = 16
; Variables
.input = -32
.len = -36

	push esi
	push edi
	push ebp
	mov ebp, esp
	sub esp, 36

	mov dword [ebp + .len], 0

	; Display initial message
	mov esi, message
	mov ecx, end_message - message
	mov dx, TERMINAL_OUTPUT
	rep outsb

.input_loop:
	; Grab next input
	in al, TERMINAL_INPUT

	; If enter is pressed, done
	cmp al, '\n'
	je .end_input

	; Look for backspace
	cmp al, 8
	je .backspace

	; Add character to input
	mov ecx, [ebp + .len]
	mov [ebp + .input + ecx], al
	inc dword [ebp + .len]
	out TERMINAL_OUTPUT, al
	jmp .input_loop

.backspace:
	cmp dword [ebp + .len], 0
	je .input_loop

	; Erase last character
	mov al, 8
	out TERMINAL_OUTPUT, al
	mov al, ' '
	out TERMINAL_OUTPUT, al
	mov al, 8
	out TERMINAL_OUTPUT, al

	dec dword [ebp + .len]
	jmp .input_loop

.end_input:
	out TERMINAL_OUTPUT, al

	; Null terminate input
	mov ecx, [ebp + .len]
	mov byte [ebp + .input + ecx], 0

	; Check code
	mov esi, [ebp + .correct_pin]
	lea edi, [ebp + .input]
	mov ecx, [ebp + .len]
	inc ecx
	repe cmpsb
	sete al

	mov esp, ebp
	pop ebp
	pop edi
	pop esi
	ret


open_door:
	push esi

	; Send command to unlock door
	mov al, 1
	out DOOR_CONTROL, al

	; Show open message
	mov esi, open
	mov ecx, end_open - open
	mov dx, TERMINAL_OUTPUT
	rep outsb

	call sleep

	pop esi
	ret


get_secure_pin:
	mov ecx, [esp + 4]
.get_pin_loop:
	in al, SECURE_PIN_STORAGE
	mov [ecx], al
	inc ecx
	test al, al
	jnz .get_pin_loop
	ret


sleep:
	mov ecx, 120
.sleep_loop:
	pause
	loop .sleep_loop
	ret


message:
	db "\fPIN code:\n"
end_message:

open:
	db "ACCESS GRANTED"
end_open:

invalid:
	db "ACCESS DENIED"
end_invalid:
