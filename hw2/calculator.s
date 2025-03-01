    .global main
    .extern scanf
    .extern printf

    .data
fmt_in:
    .asciz "%s %d %d"
fmt_out:
    .asciz "%d\n"
num1:
    .word 0           @ 第一個整數
num2:
    .word 0           @ 第二個整數
str:
    .space 100        @ 儲存操作字串

add_cmd:
    .asciz "add"
sub_cmd:
    .asciz "sub"
rev_cmd:
    .asciz "rev"
div_cmd:
    .asciz "div"
max_cmd:
    .asciz "max"
exp_cmd:
    .asciz "exp"
gcd_cmd:
    .asciz "gcd"
mul_cmd:
    .asciz "mul"
lcm_cmd:
    .asciz "lcm"

help_msg:
    .asciz "Usage: [operation] [num1] [num2]\n\
Available operations are:\n\
  - \"add\" for addition\n\
  - \"sub\" for subtraction\n\
  - \"rev\" for bit-reverse (for first integer)\n\
  - \"div\" for division (first divided by second)\n\
  - \"max\" for maximum\n\
  - \"exp\" for exponent (first to the power of second)\n\
  - \"gcd\" for greatest common divisor\n\
  - \"mul\" for multiplication\n\
  - \"lcm\" for least common multiply\n"

error_msg:
    .asciz "Error: Invalid operation or input\n"

    .text
@======================================================
@ strcmp: 比較兩個以 NUL 結尾的字串
@======================================================
strcmp:
    push {r4, lr}
    mov  r2, r0      @ r2 = str1
    mov  r3, r1      @ r3 = str2
loop:
    ldrb r4, [r2], #1
    ldrb r5, [r3], #1
    cmp  r4, r5
    bne  finish
    cmp  r4, #0
    bne  loop
    mov  r0, #0
    pop {r4, lr}
    bx  lr
finish:
    sub  r0, r4, r5
    pop {r4, lr}
    bx lr

@======================================================
@ main: 程式進入點
@======================================================
main:
    push {fp, lr}
    add fp, sp, #0

    @ 呼叫 scanf(fmt_in, str, num1, num2)
    ldr r0, =fmt_in
    ldr r1, =str
    ldr r2, =num1
    ldr r3, =num2
    bl scanf

    cmp r0, #3         @ 是否成功讀取 3 個項目
    bne help

    @ 檢查操作字串是否為空
    ldr r0, =str
    ldrb r1, [r0]
    cmp r1, #0
    beq help

    @ 比較操作字串
    ldr r0, =add_cmd
    ldr r1, =str
    bl strcmp
    cmp r0, #0
    beq add

    ldr r0, =sub_cmd
    ldr r1, =str
    bl strcmp
    cmp r0, #0
    beq sub

    ldr r0, =rev_cmd
    ldr r1, =str
    bl strcmp
    cmp r0, #0
    beq rev

    ldr r0, =div_cmd
    ldr r1, =str
    bl strcmp
    cmp r0, #0
    beq div

    ldr r0, =max_cmd
    ldr r1, =str
    bl strcmp
    cmp r0, #0
    beq max

    ldr r0, =exp_cmd
    ldr r1, =str
    bl strcmp
    cmp r0, #0
    beq exp

    ldr r0, =gcd_cmd
    ldr r1, =str
    bl strcmp
    cmp r0, #0
    beq gcd

    ldr r0, =mul_cmd
    ldr r1, =str
    bl strcmp
    cmp r0, #0
    beq mul

    ldr r0, =lcm_cmd
    ldr r1, =str
    bl strcmp
    cmp r0, #0
    beq lcm

    @ 若無符合的操作，顯示 help 訊息
    b help

@======================================================
@ 各運算子程式實作
@======================================================
add:
    ldr r0, =num1
    ldr r1, [r0]
    ldr r0, =num2
    ldr r2, [r0]
    add r0, r1, r2
    b print

sub:
    ldr r0, =num1
    ldr r1, [r0]
    ldr r0, =num2
    ldr r2, [r0]
    sub r0, r1, r2
    b print

rev:
    ldr r0, =num1
    ldr r1, [r0]      @ 讀取第一個整數
    mov r2, #0        @ 反轉結果初值
    mov r4, #32       @ 位元數
rev_loop:
    lsls r2, r2, #1
    and r5, r1, #1
    orr r2, r2, r5
    lsrs r1, r1, #1
    subs r4, r4, #1
    bne rev_loop
    mov r0, r2
    b print

div:
    ldr r0, =num1
    ldr r1, [r0]      @ dividend
    ldr r0, =num2
    ldr r2, [r0]      @ divisor
    cmp r2, #0
    beq error_div
    sdiv r0, r1, r2
    b print
error_div:
    ldr r0, =error_msg
    bl printf
    b end

max:
    ldr r0, =num1
    ldr r1, [r0]
    ldr r0, =num2
    ldr r2, [r0]
    cmp r1, r2
    bge max_done
    mov r1, r2
max_done:
    mov r0, r1
    b print

exp:
    ldr r0, =num1
    ldr r3, [r0]      @ base
    ldr r0, =num2
    ldr r2, [r0]      @ exponent
    mov r1, #1        @ result = 1
    cmp r2, #0
    beq exp_done
exp_loop:
    mul r4, r1, r3    @ 使用臨時暫存器 r4
    mov r1, r4
    subs r2, r2, #1
    bne exp_loop
exp_done:
    mov r0, r1
    b print

gcd:
    ldr r0, =num1
    ldr r1, [r0]      @ a
    ldr r0, =num2
    ldr r2, [r0]      @ b
gcd_loop:
    cmp r2, #0
    beq gcd_done
    mov r3, r1
    mov r1, r2
    sdiv r4, r3, r2
    mul r5, r4, r2    @ 使用臨時暫存器 r5
    sub r4, r3, r5
    mov r2, r4
    b gcd_loop
gcd_done:
    mov r0, r1
    b print

mul:
    ldr r0, =num1
    ldr r1, [r0]
    ldr r0, =num2
    ldr r2, [r0]
    mul r0, r1, r2
    b print

lcm:
    ldr r1, =num1
    ldr r3, [r1]      @ a
    ldr r1, =num2
    ldr r4, [r1]      @ b

    mul r2, r3, r4    @ a * b
    bl gcd_internal   @ 計算 gcd，結果存於 r0

    cmp r0, #0
    beq lcm_zero

    sdiv r0, r2, r0   @ (a * b) / gcd(a, b)

    b print

lcm_zero:
    mov r0, #0
    b print

gcd_internal:
gcd_internal_loop:
    cmp r4, #0
    beq gcd_internal_done
    mov r5, r3
    mov r3, r4
    sdiv r6, r5, r4
    mul r7, r6, r4   @ 使用臨時暫存器 r7
    sub r6, r5, r7
    mov r4, r6
    b gcd_internal_loop
gcd_internal_done:
    mov r0, r3
    bx lr

@======================================================
@ print: 印出結果後結束程式
@======================================================
print:
    mov r2, r0       @ 暫存計算結果
    ldr r0, =fmt_out @ 載入格式字串
    mov r1, r2       @ 將結果放入 r1（printf 第二個參數）
    bl printf
    b end

help:
    ldr r0, =help_msg
    bl printf
    b end

error:
    ldr r0, =error_msg
    bl printf
    b end

end:
    mov r0, #0
    pop {fp, pc}

    .section .note.GNU-stack,"",%progbits
    .end
