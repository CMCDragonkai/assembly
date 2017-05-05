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

---

db - means byte
dw - means word
dd - means double word
resb - means reserved byte
resw - means reserved word
resd - means reserved double word

The example assumes a 32 bit machine. In this case it's actually a 32 bit runtime/compiler that compiles to a 64bit compatible thing.

A MingW 32 bit compiler targeting a Cygwin environment on a 64 bit x86 computer.

So we can simulate a 32 bit environment here, and write 32 bit assembly. Our syscalls will be targeting a Cygwin environment.

To define a 64 bit integer in a 32 bit machine, we have to use 2 * 32 bits.

This allows us to define it in various ways. We can either define 8 bytes in our data section, or 4 words or 2 dwords.

Since the fundamental word of the machine is 32 bits, we must define a "word order". Yes I know a word is 16 bits, but this CPU's word is 32 bits. We can define a little-endian word order, with least significant words first. Let's differentiate CPU words, from the standard word of 16 bits.

What's the best way to define numbers? The best way is to use hex notation and use dwords.

So here's 15 in hex:

Our goal is write assembly routines to add digits of certain sizes. We'll define them in non-generic way.

32 bit addition
32 bit multiplication

64 bit addition
64 bit multiplication

96 bit addition
96 bit multiplication

128 bit addition
128 bit multiplication

Note that addition and multiplication can can result in a larger number than the input types. At some point, the larger type will simply be unusable. So it can only be shown, but no further multiplication or addition can be done on it.


  ; 0x20010db885a3000000008a2e03707334
  ; +
  ; 0xfdc4eca4cad300000000000000000000
  ; =
  ; 0x11DC5FA5D5076000000008A2E03707334
  ; the result actually overflows into 129 bits
  
THe above shows adding 2 128 bits overflows into 129 bits.

Each operation takes 2 sizes and returns twice the size of its input size. 32 bit + 32 bit = 64 bit. 32 bit * 32 bit = 64 bit... etc.

The routines will take 3 pointers, pointers to the 2 inputs, and pointer to the output to write to it.

Nasm supports macros, that are evaluated at compile time. These are done via the `equ` operator. It allows us to do simple calculations as well.

For example the ipv6Addr1 we can get the number of dwords (32 bits) in the address by taking the number of bytes, and dividing by the byte factor of 32 bits. This is done via the `($-ipv6Addr1) / DDLEN`. Where `$` is the byte address of the beginning of the current instruction, and ipv6Addr1 is the byte address of the previous instruction, and this gives us the number of bytes that takes up the entire ipv6Address. And finally we divide by 4, which DDLEN is defined to be.

This gives us the length of CPU words that the address is. This will be important when we pass in it in a rotuine.

The advantage of little-endian ordered CPU words for large numbers is that, that downcasting a 64 bit number that only contains a 32 bit number is a simple truncation, and preserves the 32 bit number. 

Also remember that multiplication and addition for signed numbers is different. Big number signed addition and multiplication is a different story.

enter 0,0 is equivalent to 

push ebp
mov ebp esp

enter 5,0 is equivalent to

push ebp
mov ebp esp
sub esp 5

Pushing base pointer onto stack, and saving stack pointer to base pointer.

Stack grows downwards, heap grows upwards.

So pushing ebp, means where the esp is, let's say:

1000

Putting a 4 byte ebp pointer into it, stores the ebp at

996 - 1000

This also moves esp to 996, as 996 is now the "top" of the stack.

So by doing mov ebp esp, this puts esp into ebp


Where is the best pointer?


X
X
X
X
X
X
EBP

Subtract constant offset from EBP allows accessing local variables.


sub esp 20, grows the stack by 20 bytes, by subtracting the esp address by 20 bytes...

that means esp must be at the top of the stack

ESP 2
20 bytes
EBP 1's EBP
ESP 1
LOCAL VAR2
LOCAL VAR1
EBP 0's EBP

XY
012

X's address is 0
Y's address is 1
EBP would be at 0
ESP would be at 2



Imagine if instead of 32 bit machine, we had an 8 bit machine. This all addresses are only 1 byte. Let's start with an example:

Before calling a function, we can have this state:

```
ESP  97
     98  variable1
     99  variable2  EBP
```

Calling a routine with arg1.
OH actually the return address is pushed onto the stack as well here.
And ret pops off the address on the stack.
ret 10, would be stdcall convention, but cdecl convention the caller cleans up the arguments
the one that created stuff, should be the one that cleans up stuff, that kind of thing...
push arg1:


```
ESP  96 
     97  arg1
     98  variable1
     99  variable2  EBP
```

call proc:

```
ESP  95 
     96  return
     97  arg1
     98  variable1
     99  variable2  EBP
```

push ebp:

```
ESP  94
     95  99
     96  return
     97  arg1
     98  variable1
     99  variable2  EBP
```

mov ebp esp

```
ESP  94            EBP
     95  99
     96  return
     97  arg1
     98  variable1
     99  variable2
```

sub esp 1

```
ESP  93
     94  variable  EBP
     95  99
     96  return
     97  arg1
     98  variable1
     99  variable2
```

To access variable, use `ebp - 1`, and read 1 byte. To access arg1, use `ebp + 1`, and read 1 byte.

In a 32 bit machine, the size of addreses is 4 bytes. So that means to access the variable, you still use `ebp - X` and read X bytes. To access arg1, you use `ebp + 4` and read Y bytes, where X is the size of the variable, and Y is the size of the arg1.

That's bascially what `enter 0,0` does. It does the setup of local variable stack space, the push, mov and sub. Similarly leave instruction does the opposite. But it is the caller's responsibility to push arguments onto the stack, and then drop arguments that it no longer needs. The result of the function can be stored in some area, either by refernece, register (eax), or by some area on the stack, that the caller reads. Since the caller already pushed arguments, the return type is likely to be placed right on top of the pushed arguments, and the caller knows the size of the returned data. (arbitrary sized data would be a pointer to somewhere in th heap, but the size would still be known ahead of time, or done by message framing (either prefix, or delimiter based)).

```
mov esp ebp
pop ebp
ret 0
```

Which is that ret 0 is the size that was subtracted..

How do you return by value on the stack? I don't want to return a pointer, and the data is larger than 1 register. So it needs be part of the stack.

It's apparently done like this:

```
ESP  92
     93  variable  EBP
     94  99
     95  return
     96  returnAddr
     97  arg1
     98  variable1
     99  variable2
```

Note that return is the return address for the jump, not the return address of the value.

esp + 1, move the resulting value into eax.
ESP + 1 would be the EBP 99.

Then move [eax] 0x01.

So we assume that EAX now holds a pointer to some address space. It moves 0x01 into it, then 0x02 into it. Each move happens.

So the caller allocates some buffer into the space that the callee assigns into. But appears to use ESP which is the top of the stack, that occurs above local variables. So why is it using ESP offsets?

ReturnVal must be a pointer... so we store the pointer in and then return?

We should be using EBP + 2, to jump past the EBP value, the return address and the returnVal.

EBP value is essentially the "Control Link".

So you first push arguments right to left, then push a return address representing where to store the value (this could be some address in heap memory or something else), but usually it represents an area in the stack right?

Return values are either returned in eax, edx:eax, or no return just store in heap. But how does it work for caller specific return by struct?

After the returned values, there's the return address that is pushed by call, and used by ret.

This doesn't seem to be specified in the model, the return address is between the returned values and the control link.

After the control link, we may have an access link, don't know what this is for.

After access link, we have saved machine status.

TEMPORARIES
LOCAL DATA
SAVED MACHINE STATUS
ACCESS LINK
CONTROL LINK
RETURN VALUES
ARGUMENTS

However in cdecl x86, the actual style is this:

TEMPORARIES
LOCAL DATA
CONTROL LINK (EBP)
SAVED MACHINE STATUS (RETURN ADDR)
RETURN VALUE ADDRESS
ARGUMENTS

Where the caller initiates ARGUMENTS and RETURN VALUE ADDRESS, and cleans up them up. It also calls, thus putting return address, and I think ret must pop it right? Yea, so while the caller pushes the return address, the callee by ret, pops the return address.

CALL is paired up with RET
ENTER is paired up with LEAVE

base pointer or "frame pointer", stack pointer these 2 tells us where the current activation record or "stack frame" is

By preserving the base pointer into the stack, during function returns, the base pointer will be denumerated back to the prior base pointer. The stack pointer itself is not explicitly moved. It is always implicitly moved based on push and pop instructions (which the higher order instructions like enter, leave, call, ret perform).

ACCESS LINK is used for nested functions, that is higher order functions, or lexically nested functions, it's not used for where a function calls another function, it's designed to operate like a closure thing, but there are other ways of representing closures as well.

Access link points to the stack frame of the latest activation of the procedure that most closely encapsulates the callee. The immediate scope of the callee. This is called the "access link" or "static link". Some compilers may inline outer closures into the most immediate level, so nested functions don't need to traverse the transitive access graph, and this is called "display". Access links can be optimised away if the inner function only accesses immutable variables in its closure. Such as pure functions.

The enter and leave is called the "subroutine or function prologue and epilogue". The second argument of enter was used for nested functions before, pushing several base and frame pointers, like giving and access link, modern languages generally don't use this, and C does not have nested functions.

push arg3
push arg2
push arg1
push space for return value

space
arg1
arg2 
arg3

How does the callee know the return space?

Well it knows the first argument is ebp + 8. That the second argument is ebp + 12. The third argument is ebp + 16 (note that all arguments are assumed to be 32 bits here), the final argument what space is it? Well if your function is assuming 32 + 32 = 64, then final space should also be 64 bits as well, and the caller should have pushed 64 bits of space into it.

The clean up of the caller is then to pop the parameters, and pop the return space.

According to the x86 calling convensions, there are variations as to how to return values.

* Simple values fitting into a register: eax
* Values that fit into 2 registers: edx:eax
* Caller adds a return address as the first parameter (and a address is a pointer), callee looks up this address (first parameter) (so it gets pushed last), callee populates this and knows it is exactly a register size as well, so it can then dereference and pass in the relevant size, both the caller and callee know the size of the result (or has some way of knowing?)

Other than the top 3, you also have pointer deferencing, but those are different, as the function isn't returning anymore...

This actually shows that calling conventions are quite different.

http://jdebp.eu./FGA/function-calling-conventions.html

OK I get it, so basically the return value is basically setup as an address, representing the first hidden parameter, so that means it gets pushed last, which means its the closes to the next base pointer. Where does this address point to? Well to the return value space, this has to be allocated by the caller. It can be allocated on the caller's stack space as a local variable or as a temporary, or it can be allocated in the heap. What does this correspond to?

```
struct X {
    int a;
    int b;
    int c;
};

struct X abc () {

    struct X x = { 1, 2, 3 };
    return x;

}

int main () {

    struct X x = abc();
    
    return 0;

}
```

So does that mean main allocates space as a local variable, passes the address for the local variable as the first argument, then calls abc. abc fills the x in the main, and then the main has it in the stack. That's pretty cool.

Alternatively imagine:

```
int 
main () {

    struct X * x = malloc(sizeof(X));
    
    *x = abc();

}
```

And there you go, now instead of local variable, you get return address to someplace in the heap. AWEESSSOMME!!

Take half of a 32 bit add half of a 32 bit, you already have the FULL 32 bit, now if you add 1 more, you need 64 bit to hold the rest, but where do you pass on that overflow.

It is said, we add to the least significant word first. So that just means something like this:

```
mov eax, [ebp+12]
add [ebp+16]
adc [ebp+20], 0
```

Carry flag is set to 1, if it is set to 1, add 1 to the next number... So that just means 

```
00000000000000001111111111111111
+ 1
00000000000000010000000000000000

 1111
  1111
+ 0001
------
 10000
 
 1111
  1111
+ 0101
------
 10100
```

That's it, so we just need to make sure the it is all zeroed out!

Ok so basically we need to have 64 bit digit space, and just carry it to the higher end...
