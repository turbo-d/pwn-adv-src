mov edi, payload
mov ecx, 128
mov dx, 0
rep insb
jmp payload

.data
payload: