STMFD r13!, {r11, r14}         @ r14, r11 的值依序存入 stack
ADD	r11, r13, #4               @ r11 = r14 在 stack 的位置
MOV r2, #0                     @ num1 #-16
MOV r3, #0                     @ num2 #-12
MOV r4, #0                     @ op   #-8
STMFD r13!, {r1, r2, r3, r4}   @ stores r1-r4 in stack
MOV r9, #0
MOV r0, #8
CMP r9, #1
STRNE r2, [r11, #-16]
MOV r9, #0
MOV r0, #12
CMP r9, #1
STRNE r2, [r11, #-12]
MOV r0, #16
STR r2, [r11, #-8]
LDR r1, [r11, #-16]
LDR r2, [r11, #-12]
LDR r0, [r11, #-8]
CMPEQ r0, #8
LDRLS r15, [r3, r0, LSL #2]
LDR r2, [r1, #12]
LDR r1, [r1, #8]
BL printf
LDR r2, [r1, #12]
LDR r1, [r11, #-16]
BL printf
MOV r0, #0                     @ return 0
SUB	r13, r11, #4               @ r13 = r11 在 stack 的位置
LDMFD r13!, {r11, r14}         @ 從 stack 依序 load 回 r11, r14
MOV r15, r14                   @ main function ends here
