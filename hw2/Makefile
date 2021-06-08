GCC = arm-none-eabi-gcc
EXE = arm-none-eabi-run
COMPIL = generic-hosted.ld
TARGET = a
ARGV = 13 12 3

all:
	@$(GCC) $(TARGET).S -T $(COMPIL)
	@echo make $(TARGET).S success
	@$(EXE) a.out $(ARGV)

.PHONY: clean
clean:
	@del a.out
	@echo clean done
