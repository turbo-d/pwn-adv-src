TERMINAL_INPUT = 0
TERMINAL_OUTPUT = 1
SHARK_HORDE = 2

main:
	push initial_message
	call puts

.waitloop:
	in al, TERMINAL_INPUT
	cmp al, 'y'
	je .shark_attack
	cmp al, 'Y'
	je .shark_attack
	jmp .waitloop

.shark_attack:
	mov al, 1
	out SHARK_HORDE, al

	push shark_message
	call puts

.horde_loop:
	hlt


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


initial_message:
db "\f"
db "Those who desire to obtain the Ice Rod\n"
db "that sits upon the Pedestal of the\n"
db "the Laser Bridge must first face a\n"
db "trial.\n\n"
db "You must conquer a horde of the laser\n"
db "sharks while standing upon this bridge\n"
db "in order to prove your worth. Only then\n"
db "may you take this Ice Rod.\n\n"
db "If you wish to start this trail,\n"
db "press the Y key now.", 0

shark_message:
db "\fThe trial has begun.\n\n", 0
