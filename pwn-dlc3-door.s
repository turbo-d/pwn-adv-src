TERMINAL_INPUT = 0

mov esi, data
mov ecx, end - data
mov dx, TERMINAL_INPUT
rep outsb
hlt

data:
	db "9b916917-b6117336"
    db "\n"
end: