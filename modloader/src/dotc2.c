#include <static_mods.h>

int main(int argc, char** argv)
{
    for(int i = 0; i < ggen_static_mods_count; ++i)
        ggen_static_mods[i].f_start();
}
