ROBOT_INPUT = 0

mov esi, data
mov ecx, end - data
mov dx, ROBOT_INPUT
rep outsb

hlt

data:

; initial direction is down  // Down
; walk one block
; A - store location
; turn left // Left
; walk one block
; if location has changed
;   goto A
; else
;   turn left 3x (turn right) // Down count = 1
;   walk one block
;   if location has changed
;       goto A
;   else
;       turn left 3x (turn right) // Right count = 2
;       walk one block
;       if location has changed
;           goto A
;       else
;           turn left 3x (turn right) // Up count = 3
;           walk one block
;           goto A

.start
; set initial direction to down

call walk

.A
.store_location
; x location sys call
; y location sys call
; store x
; store y

.turn_left
; turn the direction left 1x

call walk

; set counter to 0

.recursion
.check_locations
; compare x location
; compare y location
jne A
; || if counter > 3
jmp A

; inc counter

; turn the direction left 3x or right 1x

call walk

jmp .recursion



walk:
    xor eax, eax
    mov al, SYS_WALK
	int 0x80

    xor esi, esi
	add esi, 16

.walk_loop:
	pause
    dec esi
    jnz .walk_loop

    ret

db 0
end: