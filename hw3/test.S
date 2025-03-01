STMFD r13!, {r11, r14}
ADD	r11, r13, #4
MOV r2, #0
MOV r3, #0
MOV r4, #0
STMFD r13!, {r1, r2, r3, r4}
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
MOV r0, #0
SUB	r13, r11, #4
LDMFD r13!, {r11, r14}
MOV r15, r14
