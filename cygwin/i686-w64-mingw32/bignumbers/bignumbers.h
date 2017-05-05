#pragma once

#include <cdecl.h>

uint64_t PRE_CDECL asm_add32 (uint32_t, uint32_t) POST_CDECL;

uint64_t PRE_CDECL asm_mul32 (uint32_t, uint32_t) POST_CDECL;

int64_t PRE_CDECL asm_addi32 (int32_t, int32_t) POST_CDECL;

int64_t PRE_CDECL asm_muli32 (int32_t, int32_t) POST_CDECL;

