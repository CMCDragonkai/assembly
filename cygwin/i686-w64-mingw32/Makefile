AS=nasm
ASFLAGS=-f win32 -I includes/ -g
CC=i686-w64-mingw32-gcc
CFLAGS=-I includes -std=c11 -Wall -g

.PHONY: all addition clean cleanall

# %.asm.o: %.asm
# 	$(AS) $(ASFLAGS) -o $@ $<

# %.o: %.c
# 	$(CC) -c $(CFLAGS) -c $< -o $@

all: addition arithmetic

addition: addition.o addition.asm.o io.asm.o
	$(CC) $(CFLAGS) addition.o addition.asm.o io.asm.o -o addition

addition.o: addition/main.c includes/cdecl.h
	$(CC) $(CFLAGS) -c addition/main.c -o addition.o

addition.asm.o: addition/addition.asm includes/io.inc
	$(AS) $(ASFLAGS) -o addition.asm.o addition/addition.asm

arithmetic: arithmetic.o arithmetic.asm.o io.asm.o
	$(CC) $(CFLAGS) arithmetic.o arithmetic.asm.o io.asm.o -o arithmetic

arithmetic.o: arithmetic/main.c includes/cdecl.h
	$(CC) $(CFLAGS) -c arithmetic/main.c -o arithmetic.o

arithmetic.asm.o: arithmetic/arithmetic.asm includes/io.inc
	$(AS) $(ASFLAGS) -o arithmetic.asm.o arithmetic/arithmetic.asm

bignumbers: bignumbers.o bignumbers.asm.o io.asm.o
	$(CC) $(CFLAGS) bignumbers.o bignumbers.asm.o io.asm.o -o bignumbers

bignumbers.o: bignumbers/main.c bignumbers/bignumbers.h includes/cdecl.h
	$(CC) $(CFLAGS) -c bignumbers/main.c -o bignumbers.o

bignumbers.asm.o: bignumbers/bignumbers.asm includes/io.inc
	$(AS) $(ASFLAGS) -o bignumbers.asm.o bignumbers/bignumbers.asm

io.asm.o: io/io.asm
	$(AS) $(ASFLAGS) -o io.asm.o io/io.asm

clean:
	rm *.o

cleanall:
	rm *.o
	rm *.exe
