AS=nasm
ASFLAGS=-f win32 -I includes/
CC=i686-w64-mingw32-gcc
CFLAGS=-I includes
CXX=i686-w64-mingw32-g++

.PHONY: all addition clean cleanall

# %.asm.o: %.asm
# 	$(AS) $(ASFLAGS) -o $@ $<

# %.o: %.c
# 	$(CC) -c $(CFLAGS) -c $< -o $@

all: addition

addition: addition.o addition.asm.o io.asm.o
	$(CC) $(CFLAGS) addition.o addition.asm.o io.asm.o -o addition

addition.o: addition/main.c includes/cdecl.h
	$(CC) $(CFLAGS) -c addition/main.c -o addition.o

addition.asm.o: addition/addition.asm includes/io.inc
	$(AS) $(ASFLAGS) -o addition.asm.o addition/addition.asm

io.asm.o: io/io.asm
	$(AS) $(ASFLAGS) -o io.asm.o io/io.asm

clean:
	rm *.o
