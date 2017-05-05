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

  printf("x + y =\t0x%llx\t%llu\n", uZ, uZ);

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

  printf("x * y =\t0x%llx\t%lli\n", Z, Z);

  Z = asm_addi32(X, Y);

  printf("x + y =" "\t" "0x%llx" "\t" "%lli" "\n", Z, Z);

  X = INT_MIN;
  Y = INT_MIN;
  Z = asm_addi32(X, Y);

  printf("x + y =" "\t" "0x%llx" "\t" "%lli" "\n", Z, Z);

  return 0;

}
