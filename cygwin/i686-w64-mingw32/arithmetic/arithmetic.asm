%include "io.inc"

segment .data

  prompt db "Enter a number: ", 0
  square_msg db "Square of input is ", 0
  cube_msg db "Cube of input is ", 0
  cube25_msg db "Cube of input * 25 is ", 0
  quot_msg db "Quotient of cube/100 is ", 0
  rem_msg db "Remainder of cube/100 is ", 0
  neg_msg db "The negation of the remainder is ", 0

segment .bss

  ; reserve 1 dword (32 bits)
  input resd 1

segment .text

  global _asm_arithmetic

_asm_arithmetic:

  enter 0,0
  pusha

  mov eax, prompt
  call print_string

  ; read a signed 32 bit number
  call read_int
  mov [input], eax

  ; signed multiplication (into a 64 bit composite register)
  ; so the biggest number we can square before entering 64 bit territory
  ; is the nearest integer less or equal to the square root of (2^31 - 1)
  ; that is 46340
  ; any bigger than this number will cause this squaring to overflow
  ; but because we are cubing and multiplying by 25, we'll need to use even smaller numbers
  ; edx:eax = eax * eax
  imul eax
  mov ebx, eax

  ; move the label representing a pointer to eax
  ; print_string actually calls another procedure which runs C's printf
  ; and naturally it operates on pointers to chars
  mov eax, square_msg
  call print_string

  ; we still have edx (where is that going?)
  mov eax, ebx
  call print_int
  call print_nl

  mov ebx, eax
  ; ebx *= [input]
  ; multiplying ebx by a 32 bit number and storing the result in a 32 bit area
  imul ebx, [input]
  mov eax, cube_msg
  call print_string
  mov eax, ebx
  call print_int
  call print_nl

  ; ecx = ebx * 25
  ; would be nice if we had a way to track what's in the registers each time
  ; as you step through the program
  ; ebx is carried on from before
  ; the input number was multiplied by itself
  ; before being multipled by itself again
  ; but this time using the reserved dword in bss
  ; so it has been cubed, and now we multiply by 25
  imul ecx, ebx, 25
  mov eax, cube25_msg
  call print_string
  mov eax, ecx
  call print_int
  call print_nl

  mov eax, ebx
  ; convert eax double word to quad word (64 bit)
  ; eax => edx:eax
  ; the edx will hold the remainder, while eax holds the qoutient
  ; using cdq conveniently fills out edx according to sign bit of eax
  ; apparently this called initialising the edx prior to division
  ; by initialising it, we've basically expanded a 32 bit number in a composite 64 bit number
  cdq
  mov ecx, 100
  ; edx:eax / ecx
  ; the quotient is stored in eax, and the remainder in edx
  ; division always doubles against the operand
  ; it is always 64 bit / 32 bit, or 32 bit / 16 bit or 16 bit / 8 bit
  idiv ecx
  ; save the quotient
  mov ecx, eax
  mov eax, quot_msg
  call print_string
  ; print the quotient
  mov eax, ecx
  call print_int
  call print_nl
  mov eax, rem_msg
  call print_string
  ; print the remainder
  mov eax, edx
  call print_int
  call print_nl

  neg edx
  mov eax, neg_msg
  call print_string
  mov eax, edx
  call print_int
  call print_nl

  popa
  mov eax, 0
  leave
  ret
