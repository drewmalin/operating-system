; Loading a character into the screen requires:
; loading the 'high' bits of ax with 0x0e
; loading the 'low' bits of ax with the character
; raising the 0x10 general interrupt

; tty mode
mov ah, 0x0e

mov al, 'H'
int 0x10

mov al, 'e'
int 0x10

mov al, 'l'
int 0x10
int 0x10

mov al, 'o'
int 0x10

jmp $ ; jump to the 'current address' (infinite loop)

; Fill 510 bytes of zeros (less the previous code)
times 510-($-$$) db 0

; Magic number designating a "bootable disk"
dw 0xaa55
