#include <inttypes.h>
#include <stdint.h>
#include <limits.h>
#include <stdio.h>

#include "bignumbers.h"

void int_struct_hexdump (const void * data, size_t size) {

  for (int i = size; i-- > 0;) {
    printf("%02x", ((const unsigned char *) data)[i]);
  }

}

int main () {

  printf("32 bit Natural Arithmetic:\n\n");

  uint32_t uX;
  uint32_t uY;
  uint64_t uZ;

  uX = UINT_MAX;
  uY = UINT_MAX;

  printf("x (32 bit):" "\t" "0x%x" "\t" "%u\n", uX, uX);
  printf("y (32 bit):" "\t" "0x%x" "\t" "%u\n", uY, uY);

  uZ = asm_add32(uX, uY);

  printf("x + y =" "\t" "0x%016" PRIx64 "\t" "%" PRIu64 "\n", uZ, uZ);

  uZ = asm_mul32(uX, uY);

  printf("x * y =" "\t" "0x%016" PRIx64 "\t" "%" PRIu64 "\n", uZ, uZ);

  printf("\n32 bit Integer Arithmetic:\n\n");

  int32_t X;
  int32_t Y;
  int64_t Z;

  X = INT_MAX;
  Y = INT_MIN;

  printf("x (32 bit):" "\t" "0x%x" "\t" "%i\n", X, X);
  printf("y (32 bit):" "\t" "0x%x" "\t" "%i\n", Y, Y);

  Z = asm_addi32(X, Y);

  printf("x + y =" "\t" "0x%016" PRIx64 "\t" "%" PRIi64 "\n", Z, Z);

  Z = asm_muli32(X, Y);

  printf("x * y =" "\t" "0x%016" PRIx64 "\t" "%" PRIi64 "\n", Z, Z);

  X = INT_MIN;
  Y = INT_MIN;

  printf("x (32 bit):" "\t" "0x%x" "\t" "%i\n", X, X);
  printf("y (32 bit):" "\t" "0x%x" "\t" "%i\n", Y, Y);

  Z = asm_addi32(X, Y);

  printf("x + y =" "\t" "0x%016" PRIx64 "\t" "%" PRIi64 "\n", Z, Z);

  Z = asm_muli32(X, Y);

  printf("x * y =" "\t" "0x%016" PRIx64 "\t" "%" PRIi64 "\n", Z, Z);

  X = -1;
  Y = -1;

  printf("x (32 bit):" "\t" "0x%x" "\t" "%i\n", X, X);
  printf("y (32 bit):" "\t" "0x%x" "\t" "%i\n", Y, Y);

  Z = asm_addi32(X, Y);

  printf("x + y =" "\t" "0x%016" PRIx64 "\t" "%" PRIi64 "\n", Z, Z);

  Z = asm_muli32(X, Y);

  printf("x * y =" "\t" "0x%016" PRIx64 "\t" "%" PRIi64 "\n", Z, Z);

  printf("\n64 bit Natural Arithmetic:\n\n");

  uint64_t uX64;
  uint64_t uY64;
  uint128_t uZ128;

  uX64 = 1;
  uY64 = 1;

  printf("x (64 bit):" "\t" "0x%016" PRIx64 "\t" "%" PRIu64 "\n", uX64, uX64);
  printf("y (64 bit):" "\t" "0x%016" PRIx64 "\t" "%" PRIu64 "\n", uY64, uY64);

  uZ128 = asm_add64(uX64, uY64);

  printf("x + y =" "\t" "0x");
  int_struct_hexdump(&uZ128, sizeof(uZ128));
  printf("\n");

  uX64 = 1;
  uY64 = ULLONG_MAX;

  printf("x (64 bit):" "\t" "0x%016" PRIx64 "\t" "%" PRIu64 "\n", uX64, uX64);
  printf("y (64 bit):" "\t" "0x%016" PRIx64 "\t" "%" PRIu64 "\n", uY64, uY64);

  uZ128 = asm_add64(uX64, uY64);

  printf("x + y =" "\t" "0x");
  int_struct_hexdump(&uZ128, sizeof(uZ128));
  printf("\n");

  uX64 = ULLONG_MAX;
  uY64 = ULLONG_MAX;

  printf("x (64 bit):" "\t" "0x%016" PRIx64 "\t" "%" PRIu64 "\n", uX64, uX64);
  printf("y (64 bit):" "\t" "0x%016" PRIx64 "\t" "%" PRIu64 "\n", uY64, uY64);

  uZ128 = asm_add64(uX64, uY64);

  printf("x + y =" "\t" "0x");
  int_struct_hexdump(&uZ128, sizeof(uZ128));
  printf("\n");

  printf("\n64 bit Integer Arithmetic:\n\n");

  printf("\n128 bit Natural Arithmetic:\n\n");

  uint128_t uX128 = uZ128;
  uint128_t uY128 = uZ128;

  printf("x (128 bit):" "\t");
  int_struct_hexdump(&uX128, sizeof(uX128));
  printf("\n");
  printf("y (128 bit):" "\t");
  int_struct_hexdump(&uY128, sizeof(uY128));
  printf("\n");

  uint256_t uZ256 = asm_add128(uX128, uY128);

  printf("x + y =" "\t" "0x");
  int_struct_hexdump(&uZ256, sizeof(uZ256));
  printf("\n");

  return 0;

}

