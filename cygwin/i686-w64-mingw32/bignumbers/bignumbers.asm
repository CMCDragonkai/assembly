%include "io.inc"

; assembly macros

BLEN equ 1
WLEN equ 2
DWLEN equ 4

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

  ; ipv6Addr1 dd 0x03707334, 0x00008a2e, 0x85a30000, 0x20010db8
  ; ipv6Addr1Len equ ($-ipv6Addr1) / DDLEN
  ; ipv6Addr2 dd 0x00000000, 0x00000000, 0xcad30000, 0xfdc4eca4
  ; ipv6Addr2Len equ ($-ipv6Addr2) / DDLEN

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
  global _asm_add64
  global _asm_add128

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
  push ebx

  mov eax, [ebp+8]
  cdq

  mov ecx, [ebp+12]
  test ecx, ecx
  mov ebx,0
  jns positive
  mov ebx, -1

  ; -1 + -1
  ; 1111 1111 + 1111 1111
  ; = 1 1111 1110
  ; 1111 1111 + 0000 0001 + 1111 1111
  ; = 1111 1111
  ; => 1111 1111 : 1111 1110

  ; -1 + 1
  ; 1111 1111 + 0000 0001
  ; = 1 0000 0000
  ; 1111 1111 + 0000 0001 + 0000 0000
  ; = 1 0000 0000
  ; => 0000 0000 : 0000 0000

  ; 1 + -1
  ; 0000 0001 + 1111 1111
  ; = 1 0000 0000
  ; 0000 0000 + 0000 0001 + 1111 1111
  ; = 1 0000 0000
  ; => 0000 0000 : 0000 0000

  ; 1 + 1
  ; 0000 0001 + 0000 0001
  ; = 0000 0010
  ; 0000 0000 + 0000 0000 + 0000 0000
  ; = 0000 0000
  ; => 0000 0000 : 0000 0010

positive:
  add eax, ecx
  adc edx, ebx

  pop ebx
  leave
  ret

_asm_muli32:

  enter 0,0

  mov eax, [ebp+8]
  imul dword [ebp+12]

  leave
  ret

_asm_add64:

  enter 0,0
  push esi
  push edi

  mov edx, [ebp+8]

  ; move the first 64 bit in into the 128 bit output return address
  mov ecx, 2
  mov esi, ebp
  add esi, 12
  mov edi, edx
  cld
  rep movsd

  mov dword [edx+8], 0
  mov dword [edx+12], 0

  mov eax, [ebp+20]
  add dword [edx], eax
  mov eax, [ebp+20 + 1*DWLEN]
  adc dword [edx + 1*DWLEN], eax
  adc dword [edx + 2*DWLEN], 0

  pop edi
  pop esi
  leave
  ret

_asm_add128:

  enter 0,0
  push esi
  push edi

  mov edx, [ebp+8]

  mov ecx, 4
  mov esi, ebp
  add esi, 12
  mov edi, edx
  cld
  rep movsd

  mov dword [edx+16], 0
  mov dword [edx+20], 0
  mov dword [edx+24], 0
  mov dword [edx+28], 0

  mov eax, [ebp+28]
  add dword [edx], eax
  mov eax, [ebp+28 + 1*DWLEN]
  adc dword [edx + 1*DWLEN], eax
  mov eax, [ebp+28 + 2*DWLEN]
  adc dword [edx + 2*DWLEN], eax
  mov eax, [ebp+28 + 3*DWLEN]
  adc dword [edx + 3*DWLEN], eax
  mov eax, [ebp+28 + 4*DWLEN]
  adc dword [edx + 4*DWLEN], 0

  pop edi
  pop esi
  leave
  ret
