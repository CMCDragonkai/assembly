; this is like a C header file
; for non-C people, it's basically an interface with macros!
; in nasm, these are called "directives"

extern read_int, print_int, print_string
extern read_char, print_char, print_nl
extern sub_dump_regs, sub_dump_mem, sub_dump_math, sub_dump_stack

; dump_regs :: register
%macro dump_regs 1
push dword %1
call sub_dump_regs
%endmacro

; dump_mem :: label -> start_address -> no_of_paragraphs
; word = 2 bytes
; dword = 4 bytes
; qword = 8 bytes
; paragraph = 16 bytes
%macro dump_mem 3
push dword %1
push dword %2
push dword %3
call sub_dump_mem
%endmacro

; dump_math :: math
%macro dump_math 1
push dword %1
call sub_dump_math
%endmacro

; dump_stack :: stack_entry1 -> stack_entry2 -> stack_entry3
%macro dump_stack 3
push dword %3
push dword %2
push dword %1
call sub_dump_stack
%endmacro
