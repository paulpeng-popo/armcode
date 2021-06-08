.cpu arm926ej-s                  @ ????
.fpu softvfp                     @ 浮點協處理器型別
.text                            @ code starts
.align 2                         @ 字組對齊
.global main                     @ 宣告全域變數

main:
    STMFD r13!, {r11, r14}       @ r14, r11 的值依序存入 memory
    ADD	r11, r13, #4             @ r11 = r14 在 memory 的位置
    MOV r2, #0                   @ loop var i = 0
    STMFD r13!, {r1, r2}         @ 把 r2, r1(=argv的address) 存入 memory

loop:
    LDR r2, [r11, #-8]           @ load i 到r2
    LDR r3, [r11, #-12]          @ 取出 argv的address 存入 r3
    LDR r3, [r3, #4]             @ 取出 argv 的第二個引數存入 r3
    LDRB r3, [r3, r2]            @ r3 = 字串的第 r2 個字元;

    CMP r3, #0                   @ r3 與字串結束符號'\0'比較
    BEQ end_loop                 @ 字串讀完，結束迴圈

    BL function                  @ 字串未讀完，進入 function

    LDR r2, [r11, #-8]           @ 重新 load i 到 r2
    ADD r2, r2, #1               @ i = i + 1
    STR r2, [r11, #-8]           @ 更新 memory 中的 i
    BAL loop                     @ 重複執行

end_loop:
    SUB	r13, r11, #4             @ r13 = r11 在 memory 的位置
    LDMFD r13!, {r11, r14}       @ 從 memory 依序 load 回 r11, r14
    MOV r15, r14                 @ program ends here

function:
    STR r14, [r13, #-4]!         @ 儲存跳躍前的 r14
    CMP r3, #64                  @ 比較 r3 跟 ascii 64 ('A'-1)
    BLS not_upper                @ 如果 r3 <= ('A'-1) 進入not_upper處理
    CMP r3, #90                  @ 比較 r3 跟 ascii 90 ('Z')
    BHI not_upper                @ 如果 r3 > ('Z'-1) 進入not_upper處理
    add r3, #0x20                @ r3 = r3 + 32

not_upper:
    CMP r3, #96                  @ 比較 r3 跟 ascii 96 ('a'-1)
    BLS not_alpha                @ 如果 r3 <= ('a'-1) 進入not_alpha處理
    CMP r3, #122                 @ 比較 r3 跟 ascii 122 ('z')
    BHI not_alpha                @ 如果 r3 > ('z'-1) 進入not_alpha處理

print:
    LDR r0, =char_str            @ printf 第一個參數 "%c"
    MOV r1, r3                   @ printf 第二個參數 c
    BL printf                    @ system call printf("%c", c)

not_alpha:
    LDR r14, [r13], #4           @ 取回先前儲存的 r14
    MOV r15, r14                 @ 跳躍

char_str:
    .asciz "%c"                  @ char_str = "%c"

.end                             @ code ends
