; Shift-and-add multiplication: 123 x 45 = 5535
; out: 5535
    LDI R1, 123      ; a
    LDI R2, 45       ; b
    LDI R3, 1        ; mask for the lowest bit
    XOR R0, R0, R0   ; product = 0
loop:
    BZ  R2, done     ; stop when b has no bits left
    AND R4, R2, R3
    BZ  R4, skip     ; lowest bit of b is 0: nothing to add
    ADD R0, R0, R1
skip:
    SHL R1, R1       ; a = a * 2
    SHR R2, R2       ; b = b / 2
    JMP loop
done:
    OUT R0
    HALT
