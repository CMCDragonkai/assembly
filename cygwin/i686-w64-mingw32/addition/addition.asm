%include "io.inc"

; each segment has a different address space
; on a 32 bit system, each segment has 32 bits of addressable memory

; statically initialised variables
segment .data

  ; label size value
  prompt1 db "Enter a number: ", 0
  prompt2 db "Enter another number: ", 0
  outmsg1 db "You entered ", 0
  outmsg2 db " and ", 0
  outmsg3 db ", the sum of these is ", 0

; statically uninitialised variables
segment .bss

  ; label size multiplier
  input1 resd 1
  input2 resd 1

; program code
segment .text

  global  _asm_addition

_asm_addition:

  ; setup routine
  ; enter into a new stack frame for this procedure call
  enter 0,0
  pusha

  ; print prompt1
  mov eax, prompt1
  call print_string

  ; read int from terminal
  call read_int
  mov [input1], eax

  ; print prompt2
  mov eax, prompt2
  call print_string

  ; read int from terminal
  call read_int
  mov [input2], eax

  ; add up the integers
  mov eax, [input1]
  add eax, [input2]
  mov ebx, eax
  dump_regs 1
  dump_mem 2, outmsg1, 1

  ; output the result
  mov eax, outmsg1
  call print_string
  mov eax, [input1]
  call print_int
  mov eax, outmsg2              ;
  call print_string
  mov eax, ebx
  call print_int
  call print_nl

  ; exit from this procedure call and return to C
  popa
  mov eax,0
  leave
  ret
