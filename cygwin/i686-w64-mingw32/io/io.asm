; there's also symbol directives
; symbol equ value
; macro constants is more flexible as they can be redefined
; and they can be more than simple constant numbers



; data directives are used in the data or bss segment
; data segment can have the size and initialised values
; bss segment can have only the size
; this means data segment resides on the executable file on disk
; while bss segment only lives in the executable image in memory

; the data segment uses dX directives
; db - byte
; dw - word
; dd - dword
; dq - qword
; dt - 10 bytes

; the bss segment uses resX directives
; the X is replaced with a letter that determines the size of the object, or objects that will be stored
; there can be:
; resb - byte
; resw - word
; resd - dword
; resq - qword
; rest - 10 bytes

; we can initialise values using suffixes

; db 0 ; byte with initial value 0
; db 110101b ; byte with 110101 binary (53 in decimal)
; db 12h ; byte 12 in hex
; db 17o ; byte for 17 in octal
; db "A" ; byte using ASCII code for A (65)
; db 'A' ; same
; db 0, 1, 2 ; 1 byte of 0, 1 byte of 1, 1 byte of 2, all in contiguous memory
; db 'w', 'o', 'r', 'd', 0 ; defines a C string "word"
; db 'word', 0 ; same thing

; the dd directive can be used to define both integer and single precision floating point constants
; the dq can only be used to define double precision floating point constants
; a double word is 4 bytes (32 bits), while qword is 8 bytes meaning 64 bits

; times directive can be used to repeat a directive
; times 100 db 0

; for bss, you can have an extra number which means the number of sizes you reserve, remember bss can't initialise data, so the number parameter is intended as a multiplier
; resw 100 - used for bss, to reserve 100 words

; a plain label is used as an address offset
; if label is inside square braces, then it is interpreted as the data at the address
; so that means [label] means get the data at that address, it's kind of like dereferencing an address

; when storing immediate literals, consider the size

; mov dword [L6], 1
; make sure to specify the size, that the 1 will be stored as
; so this makes 1 stored as a dword
; because 1 is ambiguous, it could be a byte, word or double word, since L6 is a double word, it can store a dword, word or byte
; we can also use byte, word, qword, and tword

; dump_regs prints out the values of the registers in hexadecimal
; also shows the FLAGS register
; zero flag is set, then ZF, if it is 0, then it is not displayed

; dump_mem takes an integer as a label
; also 2nd argument is an actual memory address which can be a label
; the 3rd argument is the number of paragraphs (16 bytes) to display after the address, I think this refers to the size of the memory to read and display, so 2 would be 32 bytes.. but this is still strange! (perhaps memory should be organised into pages, like 4K blocks?)

; dump_stack dumps the stack, stack is a double word,
; first is an integer label, second is the number of double words to display below the address of EBP
; third is the number of double words to display above EBP
; remember EBP is the base pointer relative to the ESP...
; a stack frame can be relative to these 2 pointers, and different programs use different calling conventions

; nasm constants
%define NL 10
%define CF_MASK 00000001h
%define PF_MASK 00000004h
%define AF_MASK 00000010h
%define ZF_MASK 00000040h
%define SF_MASK 00000080h
%define DF_MASK 00000400h
%define OF_MASK 00000800h

; if an ELF_TYPE (does this matter?)
; define underscore versions!?
; linux doesn't underscore things
; windows does
; so we make it compatible with each other by defining _scanf as a macro for scanf
; BUT only if we have ELF_TYPE which means an ELF executables!
%ifdef ELF_TYPE
    %define _scanf   scanf
    %define _printf  printf
    %define _getchar getchar
    %define _putchar putchar
    %define _fputs   fputs
%endif

%ifdef OBJ_TYPE
    segment .data public align=4 class=data use32
%else
    segment .data
%endif

int_format	    db  "%i", 0
string_format       db  "%s", 0
reg_format	    db  "Register Dump # %d", NL
		    db  "EAX = %.8X EBX = %.8X ECX = %.8X EDX = %.8X", NL
                    db  "ESI = %.8X EDI = %.8X EBP = %.8X ESP = %.8X", NL
                    db  "EIP = %.8X FLAGS = %.4X %s %s %s %s %s %s %s", NL
	            db  0
carry_flag	    db  "CF", 0
zero_flag	    db  "ZF", 0
sign_flag	    db  "SF", 0
parity_flag	    db	"PF", 0
overflow_flag	    db	"OF", 0
dir_flag	    db	"DF", 0
aux_carry_flag	    db	"AF", 0
unset_flag	    db	"  ", 0
mem_format1         db  "Memory Dump # %d Address = %.8X", NL, 0
mem_format2         db  "%.8X ", 0
mem_format3         db  "%.2X ", 0
stack_format        db  "Stack Dump # %d", NL
	            db  "EBP = %.8X ESP = %.8X", NL, 0
stack_line_format   db  "%+4d  %.8X  %.8X", NL, 0
math_format1        db  "Math Coprocessor Dump # %d Control Word = %.4X"
                    db  " Status Word = %.4X", NL, 0
valid_st_format     db  "ST%d: %.10g", NL, 0
invalid_st_format   db  "ST%d: Invalid ST", NL, 0
empty_st_format     db  "ST%d: Empty", NL, 0

;
; code is put in the _TEXT segment
;
%ifdef OBJ_TYPE
segment text public align=1 class=code use32
%else
segment .text
%endif
	global	read_int, print_int, print_string, read_char
	global  print_char, print_nl, sub_dump_regs, sub_dump_mem
        global  sub_dump_math, sub_dump_stack
        extern  _scanf, _printf, _getchar, _putchar, _fputs

read_int:
	enter	4,0
	pusha
	pushf

	lea	eax, [ebp-4]
	push	eax
	push	dword int_format
	call	_scanf
	pop	ecx
	pop	ecx

	popf
	popa
	mov	eax, [ebp-4]
	leave
	ret

print_int:
	enter	0,0
	pusha
	pushf

	push	eax
	push	dword int_format
	call	_printf
	pop	ecx
	pop	ecx

	popf
	popa
	leave
	ret

print_string:
	enter	0,0
	pusha
	pushf

	push	eax
	push    dword string_format
	call	_printf
	pop	ecx
	pop	ecx

	popf
	popa
	leave
	ret

read_char:
	enter	4,0
	pusha
	pushf

	call	_getchar
	mov	[ebp-4], eax

	popf
	popa
	mov	eax, [ebp-4]
	leave
	ret

print_char:
	enter	0,0
	pusha
	pushf

	push	eax
	call	_putchar
	pop	ecx

	popf
	popa
	leave
	ret


print_nl:
	enter	0,0
	pusha
	pushf

	push	dword 10	; 10 == ASCII code for \n
	call	_putchar
	pop	ecx

	popf
	popa
	leave
	ret


sub_dump_regs:
	enter   4,0
	pusha
	pushf
	mov     eax, [esp]      ; read FLAGS back off stack
	mov	[ebp-4], eax    ; save flags

;
; show which FLAGS are set
;
	test	eax, CF_MASK
	jz	cf_off
	mov	eax, carry_flag
	jmp	short push_cf
cf_off:
	mov	eax, unset_flag
push_cf:
	push	eax

	test	dword [ebp-4], PF_MASK
	jz	pf_off
	mov	eax, parity_flag
	jmp	short push_pf
pf_off:
	mov	eax, unset_flag
push_pf:
	push	eax

	test	dword [ebp-4], AF_MASK
	jz	af_off
	mov	eax, aux_carry_flag
	jmp	short push_af
af_off:
	mov	eax, unset_flag
push_af:
	push	eax

	test	dword [ebp-4], ZF_MASK
	jz	zf_off
	mov	eax, zero_flag
	jmp	short push_zf
zf_off:
	mov	eax, unset_flag
push_zf:
	push	eax

	test	dword [ebp-4], SF_MASK
	jz	sf_off
	mov	eax, sign_flag
	jmp	short push_sf
sf_off:
	mov	eax, unset_flag
push_sf:
	push	eax

	test	dword [ebp-4], DF_MASK
	jz	df_off
	mov	eax, dir_flag
	jmp	short push_df
df_off:
	mov	eax, unset_flag
push_df:
	push	eax

	test	dword [ebp-4], OF_MASK
	jz	of_off
	mov	eax, overflow_flag
	jmp	short push_of
of_off:
	mov	eax, unset_flag
push_of:
	push	eax

	push    dword [ebp-4]   ; FLAGS
	mov	eax, [ebp+4]
	sub	eax, 10         ; EIP on stack is 10 bytes ahead of orig
	push	eax             ; EIP
	lea     eax, [ebp+12]
	push    eax             ; original ESP
	push    dword [ebp]     ; original EBP
        push    edi
        push    esi
	push    edx
	push	ecx
	push	ebx
	push	dword [ebp-8]   ; original EAX
	push	dword [ebp+8]   ; # of dump
	push	dword reg_format
	call	_printf
	add	esp, 76
	popf
	popa
	leave
	ret     4

sub_dump_stack:
	enter   0,0
	pusha
	pushf

	lea     eax, [ebp+20]
	push    eax             ; original ESP
	push    dword [ebp]     ; original EBP
	push	dword [ebp+8]   ; # of dump
	push	dword stack_format
	call	_printf
	add	esp, 16

	mov	ebx, [ebp]	; ebx = original ebp
	mov	eax, [ebp+16]   ; eax = # dwords above ebp
	shl	eax, 2          ; eax *= 4
	add	ebx, eax	; ebx = & highest dword in stack to display
	mov	edx, [ebp+16]
	mov	ecx, edx
	add	ecx, [ebp+12]
	inc	ecx		; ecx = # of dwords to display

stack_line_loop:
	push	edx
	push	ecx		; save ecx & edx

	push	dword [ebx]	; value on stack
	push	ebx		; address of value on stack
	mov	eax, edx
	sal	eax, 2		; eax = 4*edx
	push	eax		; offset from ebp
	push	dword stack_line_format
	call	_printf
	add	esp, 16

	pop	ecx
	pop	edx

	sub	ebx, 4
	dec	edx
	loop	stack_line_loop

	popf
	popa
	leave
	ret     12


sub_dump_mem:
	enter	0,0
	pusha
	pushf

	push	dword [ebp+12]
	push	dword [ebp+16]
	push	dword mem_format1
	call	_printf
	add	esp, 12
	mov	esi, [ebp+12]      ; address
	and	esi, 0FFFFFFF0h    ; move to start of paragraph
	mov	ecx, [ebp+8]
	inc	ecx
mem_outer_loop:
	push	ecx
	push	esi
	push	dword mem_format2
	call	_printf
	add	esp, 8

	xor	ebx, ebx
mem_hex_loop:
	xor	eax, eax
	mov	al, [esi + ebx]
	push	eax
	push	dword mem_format3
	call	_printf
	add	esp, 8
	inc	ebx
	cmp	ebx, 16
	jl	mem_hex_loop

	mov	eax, '"'
	call	print_char
	xor	ebx, ebx
mem_char_loop:
	xor	eax, eax
	mov	al, [esi+ebx]
	cmp	al, 32
	jl	non_printable
	cmp	al, 126
	jg	non_printable
	jmp	short mem_char_loop_continue
non_printable:
	mov	eax, '?'
mem_char_loop_continue:
	call	print_char

	inc	ebx
	cmp	ebx, 16
	jl	mem_char_loop

	mov	eax, '"'
	call	print_char
	call	print_nl

	add	esi, 16
	pop	ecx
	loop	mem_outer_loop

	popf
	popa
	leave
	ret	12

; function sub_dump_math
;   prints out state of math coprocessor without modifying the coprocessor
;   or regular processor state
; Parameters:
;  dump number - dword at [ebp+8]
; Local variables:
;   ebp-108 start of fsave buffer
;   ebp-116 temp double
; Notes: This procedure uses the Pascal convention.
;   fsave buffer structure:
;   ebp-108   control word
;   ebp-104   status word
;   ebp-100   tag word
;   ebp-80    ST0
;   ebp-70    ST1
;   ebp-60    ST2 ...
;   ebp-10    ST7
;
sub_dump_math:
	enter	116,0
	pusha
	pushf

	fsave	[ebp-108]	; save coprocessor state to memory
	mov	eax, [ebp-104]  ; status word
	and	eax, 0FFFFh
	push	eax
	mov	eax, [ebp-108]  ; control word
	and	eax, 0FFFFh
	push	eax
	push	dword [ebp+8]
	push	dword math_format1
	call	_printf
	add	esp, 16
;
; rotate tag word so that tags in same order as numbers are
; in the stack
;
	mov	cx, [ebp-104]	; ax = status word
	shr	cx, 11
	and	cx, 7           ; cl = physical state of number on stack top
	mov	bx, [ebp-100]   ; bx = tag word
	shl     cl,1		; cl *= 2
	ror	bx, cl		; move top of stack tag to lowest bits

	mov	edi, 0		; edi = stack number of number
	lea	esi, [ebp-80]   ; esi = address of ST0
	mov	ecx, 8          ; ecx = loop counter
tag_loop:
	push	ecx
	mov	ax, 3
	and	ax, bx		; ax = current tag
	or	ax, ax		; 00 -> valid number
	je	valid_st
	cmp	ax, 1		; 01 -> zero
	je	zero_st
	cmp	ax, 2		; 10 -> invalid number
	je	invalid_st
	push	edi		; 11 -> empty
	push	dword empty_st_format
	call	_printf
	add	esp, 8
	jmp	short cont_tag_loop
zero_st:
	fldz
	jmp	short print_real
valid_st:
	fld	tword [esi]
print_real:
	fstp	qword [ebp-116]
	push	dword [ebp-112]
	push	dword [ebp-116]
	push	edi
	push	dword valid_st_format
	call	_printf
	add	esp, 16
	jmp	short cont_tag_loop
invalid_st:
	push	edi
	push	dword invalid_st_format
	call	_printf
	add	esp, 8
cont_tag_loop:
	ror	bx, 2		; mov next tag into lowest bits
	inc	edi
	add	esi, 10         ; mov to next number on stack
	pop	ecx
	loop    tag_loop

	frstor	[ebp-108]       ; restore coprocessor state
	popf
	popa
	leave
	ret	4
