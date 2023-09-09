## General Notes

### Registers

In 16-bit mode, 4 registers exist:
* AX ("Accumulator")
* BX ("Base")
* CX ("Counter")
* DX ("Data")

The names generally point to their conventional use, but you seem to be able to just use whichever you'd prefer.

Each can be subdivided into its upper/high (H) or lower (L) 8 bits:
* AX -> AH + AL
* BX -> BH + BL
* CX -> CH + CL
* DX -> DH + DL

In 32-bit mode, each has an extended 32 bit version:

    |FF              1F|F       8|7      0
EAX>|               AX>|   AH    |   AL   |
EBX>|               BX>|   BH    |   BL   |
ECX>|               CX>|   CH    |   CL   |
EDX>|               DX>|   DH    |   DL   |

### Operations

#### MOV

The MOV operation supports 'simple' movement of data:
* `mov AL, 0xF ; AL has been loaded with the value '0xF'`
* `mov BL, 0x4 ; BL has been loaded with the value '0x4'`
* `mov AL, 15  ; AL has been loaded with the value '15'`
* `mov AL, BL  ; AL has been loaded with the address of BL`
* `mov BL, [AL]; BL has been loaded with the value at the address of AL`
* `mov [BL], AL; The value of BL is set to the address of AL`

#### DB

'Declare byte', used to write bytes at compile-time.

```
HELLO:
  DB 'Hello', 0  ; Write 'Hello\0', accessible via the 'HELLO' label
```

#### JMP vs CALL

Jumps can be made between areas of code:

```
do_work:
JMP store

store:
MOV AX, BX
JMP do_work
```

This has limitations when jumping between shared blocks of code. For that, `CALL` allows for a convenient 'RET' (return) to the caller:

```
do_work:
CALL store

store:
MOV AX, BX
RET
```

It is convenient to stash, then restore, the values of the registers prior to commencing function logic that makes use of registers:

```
do_work:
CALL store

store:
PUSHA

MOV AX, BX

POPA
RET
```
