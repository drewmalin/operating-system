; Infinite loop (e9 fd ff)
loop:
        jmp loop

; Fill 510 bytes of zeros (less the previous code)
times 510-($-$$) db 0

; Magic number designating a "bootable disk"
dw 0xaa55
