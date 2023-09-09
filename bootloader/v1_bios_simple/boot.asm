[BITS 16]       ; Inform the assembler that this is 16 bit assembly
[ORG 0x7C00]    ; 'Origin 0x7C00' -- inform the assembler of the starting point in memory

MOV  SI, HelloWorldData
CALL PrintSI
JMP  $

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
PrintAL:
  PUSHA               ; Push all register values to the stack
  MOV  AH, 0x0E       ; Teletype output (AH=0xE)
  MOV  BH, 0x00       ; Page 0
  MOV  BL, 0x07       ; Light grey font
  INT  0x10           ; Flush (INT 10H)
  POPA                ; Restore all register values
RET                   ; Return to caller

;;
; Print a string of bytes to the screen using the 0x10 interrupt
;
; Reads from the SI register, dereferencing each byte until a '0'
; is encountered, at which point the function exits.
;
PrintSI:
  PUSHA
  PrintSI_loop:
    MOV  AL, [SI]     ; Get one byte from SI, load into AL
    INC  SI           ; Increment SI pointer
    OR   AL, AL       ; Test if AL is 0
    JZ   PrintSI_exit ; If AL == 0, exit
    CALL PrintAL      ; If AL != 0, print it
    JMP  PrintSI_loop ; Loop
  PrintSI_exit:
  POPA
RET                   ; Return to caller

; Data
HelloWorldData:
    DB   'Hello, world!', 0

; Fill the rest of the sector with 0s
TIMES 510 - ($ - $$) DB 0
; Add boot signature
DW 0xAA55
