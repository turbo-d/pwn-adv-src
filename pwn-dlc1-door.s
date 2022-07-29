TERMINAL_INPUT = 0

mov esi, data
mov ecx, end - data
mov dx, TERMINAL_INPUT
rep outsb
hlt

data:
    ;   'A',  'A',  'A',  'A',  'A',  'A',  'A',  'A'
	db 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41
    ;   'H',  'b',  'G',  'F',  'w',  'y',  'c',  'm'
    db 0x48, 0x62, 0x47, 0x46, 0x77, 0x79, 0x63, 0x6d
    db "\n"
end: