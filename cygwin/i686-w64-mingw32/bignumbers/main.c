#include <stdint.h>
#include <limits.h>
#include <stdio.h>

#include "bignumbers.h"

// this is a 32 bit program!
// designed for 32 bit machines!

int main () {

  printf("32 bit Natural Arithmetic:\n\n");

  uint32_t uX;
  uint32_t uY;
  uint64_t uZ;

  uX = UINT_MAX;
  uY = UINT_MAX;

  printf("x UINT_MAX (32 bit):\t0x%x\t%u\n", uX, uX);
  printf("y UINT_MAX (32 bit):\t0x%x\t%u\n", uY, uY);

  uZ = asm_add32(uX, uY);

  printf("x + y =\t0x%016llx\t%llu\n", uZ, uZ);

  uZ = asm_mul32(uX, uY);

  printf("x * y =\t0x%llx\t%llu\n", uZ, uZ);

  printf("\n32 bit Integer Arithmetic:\n\n");

  int32_t X;
  int32_t Y;
  int64_t Z;

  X = INT_MAX;
  Y = INT_MIN;

  printf("x INT_MAX (32 bit):\t0x%x\t%i\n", X, X);
  printf("y INT_MAX (32 bit):\t0x%x\t%i\n", Y, Y);

  Z = asm_muli32(X, Y);

  printf("x * y =" "\t" "0x%016llx" "\t" "%lli\n", Z, Z);

  Z = asm_addi32(X, Y);

  printf("x + y =" "\t" "0x%016llx" "\t" "%lli" "\n", Z, Z);

  X = INT_MIN;
  Y = INT_MIN;

  printf("x INT_MAX (32 bit):\t0x%x\t%i\n", X, X);
  printf("y INT_MAX (32 bit):\t0x%x\t%i\n", Y, Y);

  Z = asm_addi32(X, Y);

  printf("x + y =" "\t" "0x%016llx" "\t" "%lli" "\n", Z, Z);

  X = -1;
  Y = -1;

  printf("x INT_MAX (32 bit):\t0x%x\t%i\n", X, X);
  printf("y INT_MAX (32 bit):\t0x%x\t%i\n", Y, Y);

  Z = asm_addi32(X, Y);

  printf("x + y =" "\t" "0x%016llx" "\t" "%lli" "\n", Z, Z);

  printf("\n64 bit Natural Arithmetic:\n\n");

  uint64_t X64;
  uint64_t Y64;
  uint128_t Z128;

  X64 = 1;
  Y64 = 1;

  printf("x (64 bit):\t0x%016llx\t%llu\n", X64, X64);
  printf("y (64 bit):\t0x%016llx\t%llu\n", Y64, Y64);

  Z128 = asm_add64(X64, Y64);

  printf("x + y =" "\t" "0x%016llx%016llx\n", Z128.h, Z128.l);

  X64 = 1;
  Y64 = ULLONG_MAX;

  printf("x (64 bit):\t0x%016llx\t%llu\n", X64, X64);
  printf("y (64 bit):\t0x%016llx\t%llu\n", Y64, Y64);

  Z128 = asm_add64(X64, Y64);

  printf("x + y =" "\t" "0x%016llx%016llx\n", Z128.h, Z128.l);

  return 0;

}
