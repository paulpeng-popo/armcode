    .global main
    .extern printf
    .align  2

    .data
char_str:
    .asciz "%c"
new_line:
    .asciz "\n"
no_arg_str:
    .asciz "Usage: %s <string>\n"

    .text
main:
    @ ---------------------------------------------------
    @ Function prologue
    @ ---------------------------------------------------
    stmfd   sp!, {fp, lr}      @ push FP and LR
    add     fp, sp, #4         @ FP = SP + 4

    @ ---------------------------------------------------
    @ Check if we have at least 2 arguments (argc >= 2)
    @ ---------------------------------------------------
    cmp     r0, #2             @ argc in r0
    blo     no_arg             @ branch if less than 2

    @ ---------------------------------------------------
    @ Get argv[1] (the string we want to process)
    @ ---------------------------------------------------
    ldr     r4, [r1, #4]       @ r4 = argv[1]
    mov     r2, #0             @ r2 will be our index i = 0

loop:
    @ ---------------------------------------------------
    @ Load one character: r3 = argv[1][i]
    @ ---------------------------------------------------
    ldrb    r3, [r4, r2]

    @ ---------------------------------------------------
    @ If we hit the null terminator, we're done
    @ ---------------------------------------------------
    cmp     r3, #0
    beq     done

    @ ---------------------------------------------------
    @ Check if uppercase 'A' <= r3 <= 'Z'
    @ If yes, convert by adding 32 (0x20)
    @ ---------------------------------------------------
    cmp     r3, #'A'           @ compare r3 with 'A'
    blt     skip               @ if < 'A', skip
    cmp     r3, #'Z'
    bgt     check_lower        @ if > 'Z', check if lowercase

    add     r3, r3, #32        @ convert uppercase to lowercase
    b       print_char

check_lower:
    @ ---------------------------------------------------
    @ Check if 'a' <= r3 <= 'z'
    @ ---------------------------------------------------
    cmp     r3, #'a'
    blt     skip
    cmp     r3, #'z'
    bgt     skip

print_char:
    @ ---------------------------------------------------
    @ Print the character in r3
    @ We call printf("%c", r3) here
    @ ---------------------------------------------------
    push    {r0, r1, r2, r3, lr}   @ Save registers that printf may clobber
    ldr     r0, =char_str          @ r0 = address of "%c"
    mov     r1, r3                 @ r1 = character to print
    bl      printf
    pop     {r0, r1, r2, r3, lr}   @ Restore registers

skip:
    @ ---------------------------------------------------
    @ Move to the next character
    @ ---------------------------------------------------
    add     r2, r2, #1
    b       loop

done:
    @ ---------------------------------------------------
    @ If everything went fine, jump to exit
    @ ---------------------------------------------------
    @ print new line
    ldr     r0, =new_line
    bl      printf
    b       exit

no_arg:
    @ ---------------------------------------------------
    @ Optionally print usage or an error if no argv[1]
    @ (omitted for brevity, but you could call printf here)
    @ ---------------------------------------------------
    @ print usage
    ldr     r0, =no_arg_str
    ldr     r1, [r1]            @ r1 = argv[0]
    bl      printf
    b       exit

exit:
    @ ---------------------------------------------------
    @ Return 0 from main
    @ ---------------------------------------------------
    mov     r0, #0             @ return value = 0
    sub     sp, fp, #4         @ restore SP before FP
    ldmfd   sp!, {fp, pc}      @ pop FP and return

    .section .note.GNU-stack,"",%progbits
    .end
