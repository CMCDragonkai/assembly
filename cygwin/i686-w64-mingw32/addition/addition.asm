%include "io_header.inc"

; each segment has a different address space, allowing an equal amount of addressable memory for each segment

; statically initialised variables
segment .data

; can these be indented?

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

    ; the C calling convention makes it so that these assembly routines have a _ prefix
    ; this is PURELY on DOS/Windows (and hence MINGW)
    ; Linux does not prepend anything to C symbol names
    ; what does global mean here?

    ; make this label global
    ; labels have internal scope by default in nasm
    ; this makes the label have an external scope
    ; accessed by any module now
    global _asm_addition
_asm_addition:

    ; setup routine
    enter 0,0
    pusha

    ; ask for the first integer
    ; move prompt1 address to eax
    mov eax, prompt1
    call print_string

    ; read the first integer
    call read_int
    ; mov eax value into location of input1
    mov [input1], eax

    ; ask for the second integer
    mov eax, prompt2
    call print_string

    ; read the second integer
    call read_int
    mov [input2], eax

    ; add up the integers
    mov eax, [input1]
    add eax, [input2]
    mov ebx, eax

    dump_regs 1
    dump_mem 2, outmsg1, 1

    ; output results
    mov eax, outmsg1
    call print_string
    mov eax, [input1]
    call print_string
    mov eax, outmsg2
    call print_string
    mov eax, [input2]
    call print_string
    mov eax, ebx
    call print_int
    call print_nl

    ; return back to C
    popa
    mov eax, 0
    leave
    ret
