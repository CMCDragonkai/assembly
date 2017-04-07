#include "cdecl.h"

// ffi into assembly
// we expect the assembly to work via cdecl
// but this is a macro, I'm not sure what it resolves to
// no underscore is required here?
int PRE_CDECL asm_addition (void) POST_CDECL;

// this program is a thin wrapper around assembly
// it allows us to make use of the C compiler to produce the actual executable
// rather than writing all the bootstrap code in assembly
// which would be time consuming and specific to different OSes and toolchains

int main() {

    return asm_addition();

}
