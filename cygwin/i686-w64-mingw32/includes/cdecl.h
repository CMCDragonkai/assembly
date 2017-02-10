#pragma once

// The calling convention defines the way a function or a piece of code should arrange data before calling a function, and what to do after. It responds to questions like "In which order should I pass the arguments ?", "Should I clean something ?", "Where is the result ?", ...

// the 3 most common:
// cdecl
// stdcall
// fastcall

// see: http://redstack.net/blog/x86-calling-conventions.html

// what happens when __GNUC__ isn't defined, so what exactly si __cdecl then?
// how come when __GNUC__ is defined, there's a special value for POST_CDECL but not PRE_CDECL and vice versa for non-__GNUC__?

#if defined(__GNUC__)
    #define PRE_CDECL
    #define POST_CDECL __attribute__((cdecl))
#else
    #define PRE_CDECL __cdecl
    #define POST_CDECL
#endif
