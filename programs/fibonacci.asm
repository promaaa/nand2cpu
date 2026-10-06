; The Fibonacci numbers that fit in 16 bits
; out: 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181 6765 10946 17711 28657 46368
    LDI R1, 0        ; a = F(0)
    LDI R2, 1        ; b = F(1)
    LDI R3, 24       ; numbers left to print
    LDI R4, -1
loop:
    ADD R5, R1, R2   ; next = a + b
    OR  R1, R2, R2   ; a = b
    OR  R2, R5, R5   ; b = next
    OUT R1
    ADD R3, R3, R4   ; count down
    BNZ R3, loop
    HALT
