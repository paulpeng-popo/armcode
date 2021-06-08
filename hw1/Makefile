GCC = arm-none-eabi-gcc
EXE = arm-none-eabi-run
FLAG = generic-hosted.ld
TARGET = a
ARGV = 123456Hello World!123456
QUOTE = "

all:
	@$(GCC) $(TARGET).S -T $(FLAG)
	@echo make $(TARGET).S
	@$(EXE) a.out $(QUOTE)$(ARGV)$(QUOTE)

clean:
	@del a.out
	@echo clean done
