TERMINAL_INPUT = 0
TERMINAL_OUTPUT = 1
DOOR_CONTROL = 2

main:
	push initial_message
	call puts

.waitloop:
	in al, TERMINAL_INPUT
	cmp al, 'y'
	je .open
	cmp al, 'Y'
	je .open
	jmp .waitloop

.open:
	mov al, 1
	out DOOR_CONTROL, al

	push open_message
	call puts

	mov ecx, 60 * 5
.wait_loop:
	pause
	loop .wait_loop
	jmp main


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
db "The area you are about to enter is\n"
db "dangerous. Ancient experiments have\n"
db "corrupted this land and zombies roam\n"
db "the area forever.\n\n"
db "Authorized personnel and researchers\n"
db "only beyond this point. Any\n"
db "unauthorized persons that enter this\n"
db "area will not receive any aid.\n\n"
db "If you are sure you want to enter,\n"
db "this area, press the Y key now.", 0

open_message:
db "\fBarricade open. Proceed with\n"
db "caution.\n", 0
