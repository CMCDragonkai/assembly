Assembly
========

NASM x86 Assembly.

On 64 bit Cygwin, you have 4 different C compiler toolchains:

* `x86_64-pc-cygwin-gcc` - 64 bit Cygwin GCC for 64 bit machine (a.k.a `gcc`).
* `i686-pc-cygwin-gcc` - 32 bit Cygwin GCC for 64 bit machine.
* `x86_64-w64-mingw32-gcc` - 64 bit MinGW GCC for 64 bit machine.
* `i686-w64-mingw32-gcc` - 32 bit MingW GCC for 64 bit machine.

You can get those compilers by downloading the necessary packages.

Assembly examples will be categorised by the compiler toolchain.

Note that assembly programs built by MinGW should be executed in a Windows environment like Powershell or CMD or winpty.

Adapted from the forked repository, and improved organisation.

The cygwin examples only use tools that can be installed from Cygwin, no Windows executables required at all! That means `nasm` and GCC all are in Cygwin!

Make sure to read the PC Assembly PDF. That explains assembly.

Get keystone-assembler and unicorn-engine setup to do assembly in other architectures!

On Cygwin use `winpty` to launch the programs in order to attach a proper TTY to the command line programs. Otherwise you need to use CMD to execute them.
