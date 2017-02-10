AS=nasm
ASFLAGS= -f win32
CC=i686-w64-mingw32-gcc
CFLAGS=
CXX=i686-w64-mingw32-g++
CXXFLAGS=

.PHONY: all addition clean cleanall

%.asm.o: %.asm
	$(AS) $(ASFLAGS) -o $@ $<

%.o: %.c
	$(CC) -c $(CFLAGS) -c $< -o $@

%.o: %.cc
	$(CXX) $(CXXFLAGS) -c $< -o $@

all: io addition
