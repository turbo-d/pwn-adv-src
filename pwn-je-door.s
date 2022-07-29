TERMINAL_INPUT = 0

mov esi, data
mov ecx, end - data
mov dx, TERMINAL_INPUT
rep outsb
hlt

data:
db "11111111"
db "11111111"
db "11111111"
db "11111111"
db "11111111"
db "1111"
db 0xa7,0x10
db "\n"
end:
