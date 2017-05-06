#pragma once

#include <cdecl.h>

// the structs are laid out least significant to most significant
// to print them properly for hex layout (formatting)
// you need to print them backwards
// this actually happens for normal int types as well on x86
typedef struct {
  uint64_t l, h;
} uint128_t;

typedef struct {
  uint64_t l, h;
} int128_t;

typedef struct {
  uint128_t l, h;
} uint256_t;

typedef struct {
  uint128_t l, h;
} int256_t;

uint64_t PRE_CDECL asm_add32 (uint32_t, uint32_t) POST_CDECL;

uint64_t PRE_CDECL asm_mul32 (uint32_t, uint32_t) POST_CDECL;

int64_t PRE_CDECL asm_addi32 (int32_t, int32_t) POST_CDECL;

int64_t PRE_CDECL asm_muli32 (int32_t, int32_t) POST_CDECL;

uint128_t PRE_CDECL asm_add64 (uint64_t, uint64_t) POST_CDECL;

uint256_t PRE_CDECL asm_add128 (uint128_t, uint128_t) POST_CDECL;
