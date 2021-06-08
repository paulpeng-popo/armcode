.cpu arm926ej-s                  @ ????
.fpu softvfp                     @ 浮點協處理器型別
.text                            @ code starts
.align 2                         @ 字組對齊
.global main                     @ 宣告全域變數

main:
    STMFD r13!, {r11, r14}       @ r14, r11 的值依序存入 memory
    ADD	r11, r13, #4             @ r11 = r14 在 memory 的位置

    LDR r0, =message
    Bl puts

    BL start_deasm
    .include "test3.S"

end_of_main:
    MOV r0, #0                     @ return 0
    SUB	r13, r11, #4               @ r13 = r11 在 stack 的位置
    LDMFD r13!, {r11, r14}         @ 從 stack 依序 load 回 r11, r14
    MOV r15, r14                   @ main function ends here

start_deasm:
    SUB r0, r15, #20
    SUB r0, r0, #8   @ fetch == now // decode == now + 4 // execute == now + 8
    RSC r6, r14, r0
    MOV r4, r14                @ first instr. in file
    MOV r5, #0                 @ PC
    LDR r0, =labels
    BL puts

deasm_loop:
    LDR r7, [r4], #4

print_pc:
    LDR r0, =iformat
    MOV r1, r5
    BL printf

condition:
    MOV r2, r7
    MOV r2, r2, LSR #28
    MOV r2, r2, LSL #3        @ align each line in table with 8 bytes
    LDR r1, =condition_flag
    ADD r0, r1, r2
    BL printf

data_process:
    MOV r3, r7
    MOV r3, r3, LSL #4
    MOV r3, r3, LSR #25
    MOV r2, r3
    BIC r2, #0xFFFFFF9F
    BIC r3, #0xFFFFFFF0
    MOV r3, r3, LSL #3        @ align each line in table with 8 bytes
    CMP r2, #0
    BNE other_instr
    LDR r1, =opcode
    ADD r0, r1, r3
    BL printf

t1_dest:
    MOV r2, r7
    MOV r2, r2, LSR #12
    BIC r2, #0xFFFFFFF0
    LDR r0, =rdformat
    MOV r1, r2
    BL printf
    B loop_renew

other_instr:
    MOV r2, r7
    MOV r2, r2, LSL #4
    MOV r2, r2, LSR #28
    CMP r2, #10
    LDREQ r0, =bformat
    BEQ t2_dest
    CMP r2, #11
    LDREQ r0, =blformat
    BEQ t2_dest
    LDR r0, =undef_instr
    BL printf
    B loop_renew

t2_dest:
    BL printf
    MOV r3, r7
    ADD r3, r3, #2
    MOV r3, r3, LSL #8
    MOV r1, r3, ASR #6
    ADD r1, r1, r5
    LDR r0, =offset
    BL printf

loop_renew:
    SUBS r6, r6, #4
    BMI end_of_main
    ADD r5, r5, #4
    LDR r15, =deasm_loop

condition_flag:
    .asciz	"EQ   \t\t" @ 8 bytes
    .asciz	"NE   \t\t" @ 8 bytes
    .asciz	"CS/HS\t\t" @ 8 bytes
    .asciz	"CC/LO\t\t" @ 8 bytes
    .asciz	"MI   \t\t" @ 8 bytes
    .asciz	"PL   \t\t" @ 8 bytes
    .asciz	"VS   \t\t" @ 8 bytes
    .asciz	"VC   \t\t" @ 8 bytes
    .asciz	"HI   \t\t" @ 8 bytes
    .asciz	"LS   \t\t" @ 8 bytes
    .asciz	"GE   \t\t" @ 8 bytes
    .asciz	"LT   \t\t" @ 8 bytes
    .asciz	"GT   \t\t" @ 8 bytes
    .asciz	"LE   \t\t" @ 8 bytes
    .asciz	"AL   \t\t" @ 8 bytes
    .asciz	"NV   \t\t" @ 8 bytes

opcode:
    .asciz	"AND  \t\t" @ 8 bytes
    .asciz	"EOR  \t\t" @ 8 bytes
    .asciz	"SUB  \t\t" @ 8 bytes
    .asciz	"RSB  \t\t" @ 8 bytes
    .asciz	"ADD  \t\t" @ 8 bytes
    .asciz	"ADC  \t\t" @ 8 bytes
    .asciz	"SBC  \t\t" @ 8 bytes
    .asciz	"RSC  \t\t" @ 8 bytes
    .asciz	"TST  \t\t" @ 8 bytes
    .asciz	"TEQ  \t\t" @ 8 bytes
    .asciz	"CMP  \t\t" @ 8 bytes
    .asciz	"CMN  \t\t" @ 8 bytes
    .asciz	"ORR  \t\t" @ 8 bytes
    .asciz	"MOV  \t\t" @ 8 bytes
    .asciz	"BIC  \t\t" @ 8 bytes
    .asciz	"MVN  \t\t" @ 8 bytes

.align 2
undef_instr:
	.asciz "xxx\n"

.align 2
message:
    .asciz "Starting deasm..."
labels:
    .asciz "PC\tcondition\tinstruction\tdestination"
iformat:
    .asciz "%d\t"
rdformat:
    .asciz "r%d\t\n"
bformat:
    .asciz "B    \t\t"
blformat:
    .asciz "BL   \t\t"
offset:
    .asciz "%d\t\n"

.end                             @ code ends
