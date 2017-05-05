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

  bigNumber96 dd 0xABCDEF00, 0x12345678, 0x01020304

  ; IPv6 in 128 bits

  ipv6Addr1 dd 0x03707334, 0x00008a2e, 0x85a30000, 0x20010db8
  ipv6Addr1Len equ ($-ipv6Addr1) / DDLEN
  ipv6Addr2 dd 0x00000000, 0x00000000, 0xcad30000, 0xfdc4eca4
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

segment .text

  global _asm_add32
  global _asm_mul32
  global _asm_addi32
  global _asm_muli32

_asm_add32:

  enter 0,0

  mov eax, [ebp+8]
  mov edx, 0

  add eax, [ebp+12]
  adc edx, 0

  leave
  ret

_asm_mul32:

  enter 0,0

  mov eax, [ebp+8]
  mul dword [ebp+12]

  leave
  ret

_asm_addi32:

  enter 0,0

  ; we need to deal with underflow as well as overflow
  ; we may be adding 2 large negative numbers
  ; how does this work?

  mov eax, [ebp+8]
  add eax, [ebp+12]
  cdq
  adc edx, 0

  leave
  ret

_asm_muli32:

  enter 0,0

  mov eax, [ebp+8]
  imul dword [ebp+12]

  leave
  ret
