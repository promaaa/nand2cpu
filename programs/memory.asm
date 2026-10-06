; Store the first ten odd numbers in RAM, then read them back and add them: 1 + 3 + ... + 19 = 100
; out: 100
    LDI R1, 1        ; odd number
    LDI R2, 0        ; address
    LDI R3, 10       ; count
    LDI R4, 1
    LDI R6, 2
store:
    ST  R1, [R2]
    ADD R1, R1, R6
    ADD R2, R2, R4
    SUB R3, R3, R4
    BNZ R3, store
    XOR R0, R0, R0   ; sum = 0
    LDI R3, 10
load:
    SUB R2, R2, R4   ; walk back from address 9 to 0
    LD  R5, [R2]
    ADD R0, R0, R5
    SUB R3, R3, R4
    BNZ R3, load
    OUT R0
    HALT
