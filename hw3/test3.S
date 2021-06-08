	stmfd	sp!, {fp, lr}	@store content of ctl regs
	add	fp, sp, #4
	sub r1, pc, #8	  @ or use: ldr r1, =start_deasm
	sub r1, r1, lr
	mov r6, r1        @ r6 save total number of instruction
	mov r5, lr
	MOV r5, r5
	bl printf
	mov r4, #-4			 	@ r4 as index counter
	add r4, r4, #4 			@ r4 start from 0
	subs r6, r6, #4
	ldr r7, [r5], #4 		@r7 get data, r5 post-incre
	mov r1, r4
	bl printf
	mov r1, r7			 	@r7 always contain instruction data
	mov r1, r1, lsr #14
	mov r1, r1, lsr #14
	mov r1, r1, lsl #3
	add r0, r0, r1
	bl printf

ADD_END_LINE:
	mov r1, r7				@r7 always contain instruction data
	mov r1, r1, lsr #14
	moveq r1, r1, lsr #12
	bic r1, #0xFFFFFFFC
	cmp r1, #0
	bl printf
	b  ADD_END_LINE			@jump to bottom-of-loop

START:
	mov r1, r7				@r7 always contain instruction data
	mov r1, r1, lsr #14
	mov r1, r1, lsr #7
	bic r1, #0xFFFFFFF0
	mov r1, r1, lsl #3   	@Aligned with instr_str_data
	add r0, r0, r1
	bl printf
	mov r1, r7				@r7 always contain instruction data
	mov r1, r1, lsr #14
	mov r1, r1, lsr #7
	bic r1, #0xFFFFFFF0
	cmp r1, #8
	cmp r1, #11
	bl printf
	mov r1, r7				@r7 always contain instruction data
	mov r1, r1, lsr #12
	bic r1, #0xFFFFFFF0
	mov r1, r7				@r7 always contain instruction data
	mov r1, r1, lsr #14
	mov r1, r1, lsr #7
	bic r1, #0xFFFFFFF0
	cmp r1, #13			@mov
	mov r1, r7				@r7 always contain instruction data
	mov r1, r1, lsr #14
	mov r1, r1, lsr #11
	bic r1, #0xFFFFFFFE
	cmp r1, #1
	mov r1, r7				@r7 always contain instruction data
	bic r1, #0xFFFFFF00
	bl printf
	b  ADD_END_LINE			@jump to bottom-of-loop
	mov r1, r7				@r7 always contain instruction data
	bic r1, #0xFFFFFFF0
	bl printf
	b  ADD_END_LINE			@jump to bottom-of-loop
	mov r1, r7				@r7 always contain instruction data
	mov r1, r1, lsr #14
	mov r1, r1, lsr #2
	bic r1, #0xFFFFFFF0
	mov r1, r7				@r7 always contain instruction data
	mov r1, r1, lsr #14
	mov r1, r1, lsr #11
	bic r1, #0xFFFFFFFE
	cmp r1, #1
	mov r1, r7				@r7 always contain instruction data
	bic r1, #0xFFFFFF00
	bl printf
	b  ADD_END_LINE			@jump to bottom-of-loop
	mov r1, r7				@r7 always contain instruction data
	bic r1, #0xFFFFFFF0
	bl printf
	bl printf
	sub	sp, fp, #4
	ldmfd	sp!, {fp, lr}
	bx	lr
	mov r1, r6
	mov r1, r1, lsr #14
	mov r1, r1, lsr #6
	bic r1, #0xFFFFFFFE
	bl printf
	mov r1, r6
	mov r1, r1, lsr #7
	bic r1, #0xFFFFFFE0
	bl printf
	mov r1, r6
	mov r1, r1, lsr #5
	bic r1, #0xFFFFFFFC
	bl printf
	mov r1, r6
	mov r1, r1, lsr #4
	bic r1, #0xFFFFFFFE
	bl printf
	mov r1, r6
	mov r1, r1, lsr #8
	bic r1, #0xFFFFFFF0
	bl printf
