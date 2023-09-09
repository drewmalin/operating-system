[BITS 16]       ; Inform the assembler that this is 16 bit assembly
[ORG 0x7C00]    ; 'Origin 0x7C00' -- inform the assembler of the starting point in memory

MOV  BX, HELLO_MSG
CALL print_string

MOV BX, GOODBYE_MSG
CALL print_string

MOV DX, 0x1FB6
CALL print_hex

MOV DX, 0xABCD
CALL print_hex

JMP  $

; Includes
%include "print.asm"

; Data
HELLO_MSG:
    DB   'Hello, world!', 0

GOODBYE_MSG:
    DB   'Goodbye!', 0

; Fill the rest of the sector with 0s
TIMES 510 - ($ - $$) DB 0
; Add boot signature
DW 0xAA55
