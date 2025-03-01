AS = as
LD = gcc

PROG1 = lower.s
PROG2 = calculator.s
PROG3 = deasm.s

OBJ1 = $(PROG1:.s=.o)
OBJ2 = $(PROG2:.s=.o)
OBJ3 = $(PROG3:.s=.o)

EXE1 = $(PROG1:.s=)
EXE2 = $(PROG2:.s=)
EXE3 = $(PROG3:.s=)

all: $(EXE1) $(EXE2) $(EXE3)

$(EXE1): $(OBJ1)
	$(LD) -o $@ $^ -static

$(EXE2): $(OBJ2)
	$(LD) -o $@ $^ -static

$(EXE3): $(OBJ3)
	$(LD) -o $@ $^ -static

%.o: %.s
	$(AS) -o $@ $<

clean:
	rm -f $(OBJ1) $(OBJ2) $(OBJ3) $(EXE1) $(EXE2) $(EXE3)

.PHONY: all clean
