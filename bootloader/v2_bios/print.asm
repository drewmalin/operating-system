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
print_char:
  PUSHA               ; Push all register values to the stack

  MOV  AH, 0x0E       ; Teletype output (AH=0xE)
  MOV  BH, 0x00       ; Page 0
  MOV  BL, 0x07       ; Light grey font
  INT  0x10           ; Flush (INT 10H)
  
  POPA                ; Restore all register values
  RET                 ; Return to caller

;;
; Print a string of bytes to the screen using the 0x10 interrupt
;
; Reads from the BX register, dereferencing each byte until a '0'
; is encountered, at which point the function exits.
;
print_string:
  PUSHA

  print_string_loop:
    MOV  AL, [BX]          ; Get one byte from BX, load into AL
    INC  BX                ; Increment BX pointer
    OR   AL, AL            ; Test if AL is 0
    JZ   print_string_exit ; If AL == 0, exit
    CALL print_char        ; If AL != 0, print it
    JMP  print_string_loop ; Loop
  print_string_exit:

  POPA
  RET                      ; Return to caller


;;
; Print a hex address to the screen using the 0x10 interrupt
; Reads from the DX register, interpreting each 4-bit chunk of the address as a
; standalone character (if a full byte were to be interpreted, we'd get weird characters.)
;
print_hex:
  PUSHA

  MOV BX, hex_base             ; Set BX to point to the 'hex_base' address, which will be overwritten
  TIMES 5 INC BX               ; As the value here is '0x0000', decrement such that BX points to the final '0'

  print_hex_loop:
    CMP  DX, 0                 ; If DX holds 0, exit the loop and print
    JE   print

    MOV AX, DX                 ; Isolate the least significant 4 bits of DX (as we want to convert some value between 0x0 and 0xF)
    AND AX, 0x000F
    CMP AX, 10                 ; Compare the lower byte to 10 (as we want to convert the literal value to an ASCII value)
    JL  lt10

    ; If AX >= 10
    ge10:
      ADD AX, 55 ; The value is between 10 and 15 -- convert it to a value between 65 ('A') and 70 ('F')
      JMP store
  
    ; If AX <= 10
    lt10:
      ADD AX, 48 ; The value is between 0 and 9 -- convert it to a value between 48 ('0') and 57 ('9') 
      JMP store

    ; Set the value of the byte at BX to the AL address byte (which is now the ASCII value of DX's final 4 bits)
    store:
      MOV  [BX], AL
      DEC  BX                 ; Decrement the BX address by 1 to prepare for the next value
      SHR  DX, 4              ; Right-shift DX by 4 bits to isolate the next character
      JMP  print_hex_loop     ; Loop!

  ; Out of the loop -- reset BX to the beginning of the 'hex_base' address and print its contents
  print:
    MOV  BX, hex_base
    CALL print_string

  POPA
  RET

hex_base:
  DB '0x0000', 0

