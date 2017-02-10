AS=nasm
ASFLAGS= -f win32
CC=i686-w64-mingw32-gcc
CFLAGS=
CXX=i686-w64-mingw32-g++
CXXFLAGS=

.asm.o:
	$(AS) $(ASFLAGS) -o $*.o $*.asm

.cpp.o:
	$(CXX) -c $(CXXFLAGS) $*.cpp
