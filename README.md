# ARM 組合語言小程式

- 組合語言：ARM32
- 編譯環境架構：armv7l

```sh
limactl create --name=arm32 --arch=armv7l template://default
limactl start arm32
limactl shell arm32
```

## 編譯與執行

```sh
make
./lower "<string>"
./calculator <operation> <num1> <num2>
./deasm
```

## 關於 ARM 組合語言

AAPCS (ARM Procedure Call Standard)

- r0 = a1, r1 = a2, r2 = a3, r3 = a4
- r11 = fp (frame pointer)
- r12 = ip (intra-procedure call scratch register)
- r13 = sp (stack pointer)
- r14 = lr (link register)
- r15 = pc (program counter)
