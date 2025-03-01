AS = as
LD = ld
GCC = gcc

SRC = $(wildcard *.s)
OBJ = $(SRC:.s=.o)
EXE = $(SRC:.s=)

all:
	$(AS) -o $(OBJ) $(SRC)
	$(GCC) -o $(EXE) $(OBJ) -static

.PHONY: clean
clean:
	@rm -f $(OBJ) $(EXE)
	@echo "Clean done"
