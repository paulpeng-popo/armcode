    .global main
    .extern puts
    .extern printf
    .align 2

    .data
cnd_flags:
    .asciz	"EQ   \t\t" @ equal
    .asciz	"NE   \t\t" @ not equal
    .asciz	"CS/HS\t\t" @ carry set/unsigned higher or same
    .asciz	"CC/LO\t\t" @ carry clear/unsigned lower
    .asciz	"MI   \t\t" @ minus/negative
    .asciz	"PL   \t\t" @ plus/positive or zero
    .asciz	"VS   \t\t" @ overflow
    .asciz	"VC   \t\t" @ no overflow
    .asciz	"HI   \t\t" @ higher
    .asciz	"LS   \t\t" @ lower or same
    .asciz	"GE   \t\t" @ greater or equal
    .asciz	"LT   \t\t" @ less than
    .asciz	"GT   \t\t" @ greater than
    .asciz	"LE   \t\t" @ less or equal
    .asciz	"AL   \t\t" @ always
    .asciz	"NV   \t\t" @ never

opcodes:
    .asciz	"AND  \t\t" @ and
    .asciz	"EOR  \t\t" @ exclusive or
    .asciz	"SUB  \t\t" @ subtract
    .asciz	"RSB  \t\t" @ reverse subtract
    .asciz	"ADD  \t\t" @ add
    .asciz	"ADC  \t\t" @ add with carry
    .asciz	"SBC  \t\t" @ subtract with carry
    .asciz	"RSC  \t\t" @ reverse subtract with carry
    .asciz	"TST  \t\t" @ test
    .asciz	"TEQ  \t\t" @ test equivalence
    .asciz	"CMP  \t\t" @ compare
    .asciz	"CMN  \t\t" @ compare negative
    .asciz	"ORR  \t\t" @ or
    .asciz	"MOV  \t\t" @ move
    .asciz	"BIC  \t\t" @ bit clear
    .asciz	"MVN  \t\t" @ move negative

undef_instr:
	.asciz "xxx\n"
message:
    .asciz "Starting deassembler...\n"
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

    .text
main:
    push {fp, lr}
    add fp, sp, #0

    ldr r0, =message
    bl puts

    bl start_deasm
    .include "test.S"

start_deasm:
    @ Because of pipeline
    @ fetch stage is 2 instructions ahead of the execute stage
    sub r0, pc, #8          @ r0 = the address of self
    rsc r6, r14, r0         @ r6 = size of the file
    mov r4, r14             @ first instruction in the file
    mov r5, #0              @ PC
    ldr r0, =labels
    bl puts

deasm_loop:
    ldr r7, [r4], #4

print_pc:
    ldr r0, =iformat
    mov r1, r5
    bl printf

condition:
    mov r2, r7
    mov r2, r2, lsr #28
    mov r2, r2, lsl #3
    ldr r1, =cnd_flags
    add r0, r1, r2
    bl printf

data_process:
    mov r3, r7
    mov r3, r3, lsl #4
    mov r3, r3, lsr #25
    mov r2, r3
    bic r2, #0xFFFFFF9F
    bic r3, #0xFFFFFFF0
    mov r3, r3, lsl #3
    cmp r2, #0
    bne other_instr
    ldr r1, =opcodes
    add r0, r1, r3
    bl printf

t1_dest:
    mov r2, r7
    mov r2, r2, lsr #12
    bic r2, #0xFFFFFFF0
    ldr r0, =rdformat
    mov r1, r2
    bl printf
    b loop_renew

other_instr:
    mov r2, r7
    mov r2, r2, lsl #4
    mov r2, r2, lsr #28
    CMP r2, #10
    ldreq r0, =bformat
    beq t2_dest
    cmp r2, #11
    ldreq r0, =blformat
    beq t2_dest
    ldr r0, =undef_instr
    bl printf
    b loop_renew

t2_dest:
    bl printf
    mov r3, r7
    add r3, r3, #2
    mov r3, r3, lsl #8
    mov r1, r3, asr #6
    add r1, r1, r5
    ldr r0, =offset
    bl printf

loop_renew:
    subs r6, r6, #4
    cmp r6, #0
    ble end_of_main
    add r5, r5, #4
    ldr r15, =deasm_loop

end_of_main:
    mov r0, #0
    add sp, fp, #0
    pop {fp, pc}

    .section .note.GNU-stack,"",%progbits
    .end
