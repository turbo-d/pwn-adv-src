INPUT = 0

main:
	mov esi, program
.loop:
	in al, INPUT
	cmp al, 0
	je .done
	mov [esi], al
	inc esi
	jmp .loop
.done:
	mov eax, SYS_DISCONNECT
	int 0x80
	mov eax, SYS_ROM_UPDATE
	mov ebx, program
	mov ecx, esi
	sub ecx, ebx
	int 0x80

.data
program:
