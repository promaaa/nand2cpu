; Test basic operations
start:
    ADD R0, R1, R2  ; R0 = R1 + R2
    SUB R3, R4, R5  ; R3 = R4 - R5
    AND R6, R7, R0  ; R6 = R7 & R0
loop:
    SHL R1, R2      ; R1 = R2 << 1
    NOT R3, R4      ; R3 = ~R4
