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

The cygwin examples only use tools that can be installed from Cygwin, no Windows executables required at all! That means `nasm` and GCC all are in Cygwin!

Make sure to read the PC Assembly PDF. That explains assembly.

Get keystone-assembler and unicorn-engine setup to do assembly in other architectures!

On Cygwin use `winpty` to launch the programs in order to attach a proper TTY to the command line programs. Otherwise you need to use CMD to execute them.

---

All assembly programs requires the main logic to be written in Assembly, which is then ffied from a C wrapper main function, that handles all the executable bootstrapping logic because the bootstrapping logic is different for different operating systems and architectures, we rely on C to bootstrap our assmebly program. In every assembly program we also rely on an assembly IO library, which handles all the printing and reading from stdin and stdout.

To understand how to the programs are built, make sure to checkout the architecture respective Makefile.

Numbers on modern architectures use 2's complement. We first find the 1's complement, then we add 1 to the result. Given a number `00111000` (56), 1's complement is `11000111`. The add 1, giving us `11001000`. Computing the 2's complement gives us the negation of the number. Thus `11001000` becomes -56. Taking the 2's complement of this number gives us `00111000` (56). As you can see, taking 2's complement twice is basically negating a number twice.

2's complement, is find 1's complement and 1 to the number. 1's complement is inverse of the number.

56: `00111000`.
1's complement: `11000111`.
2's complement: `11001000` => -56
2's complement again: `00111000` => 56.

So taking the 2's complement is equivalent to negation, or inversion of the bitstring. You end up flipping between positive and negative.

Given any bitstring, the CPU has no idea what it really means, it relies on the programmer to interpret the bit string. There are types associated to bitstrings, unless you specify a protocol at the meta-language!

The same bitstring can represent multiple things. Like `0xFF` can be both `-1` or `+255`.

To decrease the size of data, simply remove the most significant bits from the data.

You can do things like `mov cl al`, which moves the lower 8 bits of `ax` into `cl` which is the lower 8 bits of `cx`.

For an unsigned number under 256, we can easily remove the top 8 bits, and the number would still work. We don't need 32 bits to store the number, only 8 bits.

To decrease size for signed numbers:

1. You can only remove leading bits if they all 0.

To decrease size of unsigned numbers:

1. You can only remove bits that are either all 1 or all 0. The first bit not being removed must be the same value as the removed bits.

The leading bit is always the sign bit for signed values.

Increasing the size also has rules.

To increase size of unsigned numbers:

1. Left pad by 0.

To increase size for signed numbers:

1. Left pad by the sign bit value (1 or 0).

To extend:

```
mov ah, 0
```

That makes the higher 8 bits as 0. Thus making al into ax.

Unsigned numbers can be easily extended with the `movzx` instruction which works with 32 bits and higher. However it doesn't work for signed numbers.

Another instruction is introduced as `CBW` - Convert Byte to Word.

Everytime a new architecture is introduced, this resulted in introducing instructions that managed higher bit sizes of numbers. We have `mov`, to `movzx` to `movsx`. While for signed numbers we have `cbw` to `cwd` to `cwde` and `cdq`.

After performing add or sub, 2 bits in the FLAG register is set, which are called the overflow and carry flag.

The overflow flag is for signed arithmetic, while the carry flag is for unsigned arithmetic.

The same `add` and `sub` can be used for both signed and unsigned numbers. But for multiplication and division there are 2 separate instructions for both.

We notice that alot of instructions uses the A register for lots of implicit mutations and sometimes the D register when performing composite operations. The smallest always begins at AL, the lower half.

I don't understand the `adc` and `sbb` instructions. The carry flag and stuff is not making sense.

The `cmp` instruction can be used to compare things, and the result is set in the flags register.

If `cmp` of 2 operands gives 0, then the zero flag is set in the flags register. If the left operand is greater, then there is no carry, cause `left - right` is a positive number, so we get 0 for zero flag and carry flag. However if `left - right` gives a negative number, then there's the carry flag set to 1. Note that this carry flag is used to represent the borrow concept when subtracting things that result in more digits.

You get a carry when you add 2 single digits and the result is a double digit. You get a borrow when you subtract 2 single digits and you get a negative digit. I'm not sure how the borrow in this sense relates to the borrow in assembly.

Yea so because left is smaller than right, the subtraction would result in a negative number, that's why we set the carry flag which represents the fact that we would need to borrow in elementary arithmetic.

Currently on page 49 of 195. Reading about gotos and unconditional jumps vs conditional jumps.

---

In Assembly many commands that cause overflow would use `edx:eax`.

---

http://soliduscode.blogspot.com.au/2012/04/creating-local-variables-in-assembly.html

And you can call malloc from assembly.

http://x86asm.net/articles/working-with-big-numbers-using-x86-instructions/

http://cs.lmu.edu/~ray/notes/nasmtutorial/

