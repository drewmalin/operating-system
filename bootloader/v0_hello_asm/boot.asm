[BITS 16]       ; Inform the assembler that this is 16 bit assembly
[ORG 0x7C00]    ; 'Origin 0x7C00' -- inform the assembler of the starting point in memory

;;
; Print a character to the screen using the 0x10 interrupt (INT 10H)
; 
; https://en.wikipedia.org/wiki/INT_10H
; 
; Teletype output:
;  AH=0xE
;  AL=(character to print)
;  BH=(page number)
;  BL=(color)
;
MOV AL, 'A'     ; Load 'A' into AL
CALL Print
JMP $           ; Infinite loop

Print:
MOV AH, 0x0E    ; Teletype output (AH=0xE)
MOV BH, 0x00    ; Page 0
MOV BL, 0x07    ; Light grey font
INT 0x10        ; Flush (INT 10H)
RET             ; Return to caller

; Fill the rest of the sector with 0s
TIMES 510 - ($ - $$) db 0
; Add boot signature
DW 0xAA55
