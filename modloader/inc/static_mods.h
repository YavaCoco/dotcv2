#ifndef DCVM2_STATIC_MODS_H
#define DCVM2_STATIC_MODS_H

#include <stddef.h>

typedef void(*fmod_start)();

struct STATIC_MOD;
typedef struct STATIC_MOD static_mod;
struct STATIC_MOD
{
    char* name;
    fmod_start f_start;
};

extern static_mod ggen_static_mods[];
extern size_t const ggen_static_mods_count;

#endif