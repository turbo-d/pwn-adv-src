TERMINAL_INPUT = 0
TERMINAL_OUTPUT = 1
BUTTON_CONTROL = 2
DOOR_CONTROL = 3

main:
	xor edi, edi
	xor esi, esi

.loop:
	push first_message
	call puts

	mov eax, edi
	add al, '0'
	out TERMINAL_OUTPUT, al

	push second_message
	call puts

	in al, BUTTON_CONTROL
	mov cl, al
	mov eax, 1
	shl eax, cl
	test esi, eax
	jne .loop

	or esi, eax
	inc edi
	cmp edi, 3
	je .open
	jmp .loop

.open:
	mov al, 1
	out DOOR_CONTROL, al
	jmp .loop


puts:
	push esi
	mov esi, [esp + 8]
.outloop:
	lodsb
	test al, al
	jz .end
	out TERMINAL_OUTPUT, al
	jmp .outloop
.end:
	pop esi
	ret 4


first_message:
db "\fCONTAINMENT AREA\n", 0
second_message:
db "/3 release buttons\npressed.\n", 0
