%include "io.inc"

; assembly macros

BLEN equ 1
DWLEN equ 2
DDLEN equ 4

segment .data

  message db "Calculating Big Numbers!", 0

  ; 2 in 32 bits
  two32 db 0, 0, 0, 2, 0, 0, 0, 0

  ; 1 in 64 bits

  one64 dw 0, 1, 0, 0

  ; 15 in 96 bits

  fifteen96 dd 15, 0, 0

  ; 0x0102030412345678ABCDEF00 in 96 bits

  bigNumber96 dd ABCDEF00h, 12345678h, 01020304h

  ; IPv6 in 128 bits

  ipv6Addr1 dd 03707334h, 00008a2eh, 85a30000h, 20010db8h
  ipv6Addr1Len equ ($-ipv6Addr1) / DDLEN
  ipv6Addr2 dd 00000000h, 00000000h, cad30000h, fdc4eca4h
  ipv6Addr2Len equ ($-ipv6Addr2) / DDLEN

segment .bss

  addedTwo32 resd 2
  multipliedTwo32 resd 2

  addedOne64 resd 4
  multipliedOne64 resd 4

  addedFifteen96 resd 6
  multipliedFifteen96 resd 6

  addedIpv6 resd 8
  multipledIpv6 resd 8

_asm_bignumbers:

  enter 0,0
  pusha

  push [two32]
  push [two32]
  call add32


; C calling style is arg1, arg2, arg3, arg4
; push arg4, push arg3, push arg2, push arg1
; which means arg4 is lower on the stack
; arg1 is highest on the stack
add32:                          ; 32 bit + 32 bit = 64 bit

  enter 0,0

  mov edx, [ebp+8]

  mov ecx, 1
  mov esi, ebp+12
  mov edi, edx
  cld
  rep movsd

  mov eax, dword [ebp+12]
  add dword edx, eax
  adc dword edx+4, 0

  leave
  ret

_asm_bignumbers:

  enter 0,0
  pusha

  mov eax, prompt
  call print_string

  call read_int
  mov [input], eax

  ; add 1 to the 96 bit number
  ; you just add 1 to the least-significant word
  ; but if the LSW is already full that is 0xFFFFFFFF
  ; then there will be a carry
  ; if there is a carry, then we check if there will be carry
  ; and increment the pointer by 4 bytes, and add 1 to the next word
  add [big_number], 1
  jnc done
  add [big_number+4], 1
  jc overflow

done:

  ; here we have finished adding 1 to the big number

overflow:


  ; alternatively we can use the adc operation
  ; and add only if a carry flag is set
  ; and the carry flag is set to the number is carried over right?
  add [big_number], 1
  adc [big_number+4], 0
  adc [big_number+8], 0

  ; where do you keep your big numbers?
  ; you would need a stack memory to set it up
  ; or heap memory
  ; point is... there's no memory management here

  ; but there's an issue right, if the input is more than 1
  ; and the big_number starts out close to the max
  ; is the carry flag storing the resulting carry?
  ; why does this work?
  add [big_number], [input]
  adc [big_number+4] 0
  adc [big_number+8] 0

  ; let's add 2 big numbers
  ; use adc to add higher dwords
  ; here the litte endian is used for the other big number as well
  add [big_number], AABBCCDDh
  adc [big_number+POINTER32], 12345678h
  adc [big_number+POINTER32+POINTER32], 0

  ; how do we add to another reserved area?
  ; we'd need to move everything there
  ; move all of ipv6_addr_1 into output
  ; we need to move it one by one?
  ; output is currently 256 bits, how do we move 128 bits of ipv6_addr_1
  ; into the output location
  ; basically the first dword goes into the first dword
  ; the subsequent dwords would be at the latter which is all zeros




  push dword [two32]
  push dword [two32]
  push dword [addedTwo32]
  call add32


  ; to move 2 memory addresses, we need to use movs variants
  ; the the number of times to move is the number of words
  ; here we assume the number of words to be less than 32 bits
  ; it is faster to manually encode the mov each dword
  mov ecx, ipv6_addr1_ddlen
  mov esi, ipv6_addr1
  mov edi, output
  cld
  rep movsd

  mov eax, dword [ipv6_addr2]
  add dword [output], eax
  mov eax, dword [ipv6_addr2 + 1 * DDLEN]
  adc dword [output + 1 * DDLEN], eax
  mov eax, dword [ipv6_addr2 + 2 * DDLEN]
  adc dword [output + 2 * DDLEN], eax
  mov eax, dword [ipv6_addr2 + 3 * DDLEN]
  adc dword [output + 3 * DDLEN], eax
  adc dword [output + 4 * DDLEN], 0

  ; why can we do the above?
  ; it's because the carry from an addition of the maximum int of some common size
  ; is at most always 1 (it could be 0)
  ; how is this true?
  ; the proof is this
  ; you take any number, if you were to add it to itself
  ; it is equivalent to multiple by 2
  ; multiplying by 2 is equal to bit shift left by 1
  ; x << 1
  ; that will only ever produce a result with at most a bit 1 at the left of the x
  ; if x was 1111, x << 1 = 1 1110
  ; if x was 0111, x << 1 = 0 1110
  ; if x was 0011, x << 1 = 0 0110
  ; you 128 bit + 128 bit <= 129 bit
  ; you can always get at most 1 bit extra
  ; so the carry will always be at-most 1
  ; in the above case 128 bit plus 128 bit
  ; we moved the 128 bit into output a 256 bit
  ; and we know the most-significant 128 bits is zero and empty
  ; so in that case, we just need one more adc instruction
  ; at the end of the 4th segment (dword)
  ; which adds up a possible carry to a zeroed segment
  ; the instructions here would be embedded by a compiler
  ; the compiler would know about the types of the system
  ; the assembly doesn't need to, you as the programmer knows

  ; if you really want arbitrary precision arithmetic
  ; there are 2 ways to do this, you can either
  ; always return a doubling of the max input size
  ; or you need a new type representing arbitrary precision number
  ; that is the type allows any size
  ; you would then add an extra unit of memory if you need to capture the carry
  ; or you maintain the size if the there's no carry
  ; or you even reduce the size if there's no use for it
  ; the unit of memory you need can be a byte or a word
  ; Haskell's Integer type is exactly this
  ; the above style is closer to arbitrary fixed precision arithmetic
  ; where or safe fixed precision arithmetic
  ; at some point, a your highest number size cannot be safely manipulated
  ; because you don't want the 2 * number size
  ; anyway we don't really want to try that right now
  ; it's because that would require a memory management system to allocate and deallocate memory
  ; something that's beyond just stack manipulation or register and labelled memory location manipultion that we are doing here

  ; if you wanted to use heap memory in in assembly
  ; you cannot just write it in assembly, you have to bind to the extern malloc on C
  ; actually you can't just do that, you have virtual memory
  ; but at the same time to due to loader and linker, you don't really know the absolute address of any particular label or memory object
  ; so you instead rely on syscalls like brk
  ; memory mapping is also available but it is a library call that does some magic at the virtual memory level
  ; we can use push http://soliduscode.blogspot.com.au/2012/04/creating-local-variables-in-assembly.html
  ; and just acquire local space to put variables



  ; there is a syscall that is the equivalent of malloc in assembly
  ; this would give you the pointer to the data segment
  ; and you would ask the OS to get you the pointer to the new space
  ; here in assembly you would just increase the pointer of the size
  ; nothing is changed in the memory space, but you tell the OS
  ; that you need this extra memory, and so the OS won't give a access exception
  ; still after writing/reading a page fault is generated
  ; all of this only exists under a virtual memory OS
  ; you can however call C extern malloc in assembly and avoid all that work




  ; so i found a site describing big number multiplication
  ; segmentation into dword and you still perform the multiplcation
  ; and then adding up the partial sums
  ; seems like there'd be an opportunity to create a function that takes any 2 types
  ; and returns the bigger type
  ; you'd have to define operations for each set of types as there's no generics in C
  ; 32 * 32 or 32 + 32 => 64
  ; 64 * 64 or 64 + 64 => 128
  ; 128 * 128
  ; note that in C, since you don't have 128 bit types, you'd need to keep it as a 2 64 bit
  ; similar to assembly segmentation
  ; this is done like this
  ; struct uint256_t { uint64_t bits[4]; };
  ; here you have 4 64 bits
  ; so your 64 bits is now your "word"
  ; and you can set it up little-endial style




















