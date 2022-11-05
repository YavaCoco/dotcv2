
# Expectaions
# argv[0]   : unused
# argv[1]   : root_dir
# argv[2]   : target_file(relative to root dir). The directory where this file is present MUST exist, not created by this script
# argv[3:-1]: list of modules

from sys import argv
if len(argv) < 4:
    print("Invalid argument length.")
    exit(1)

root_dir = argv[1]
target_file = argv[2]
mods = [mod.replace('-', '_') for mod in argv[3:]]

try:
    with open(root_dir + '/' + target_file, "w") as f:
        lines = list[str]()

        lines.append('// This file was automatically generated by a scipt, any modification will be overriden when building.')
        lines.append('\n')

        # includes
        lines.append('\n// Includes')
        lines.append('\n#include <static_mods.h>')
        lines.append('\n')

        # Function prototypes
        lines.append('\n// Modules _start function prototypes')
        for mod in mods:
            lines.append(f'\nvoid {mod}_start();')
        lines.append('\n')

        # static modules table
        lines.append('\n// Static modules table')
        lines.append('\nstatic_mod ggen_static_mods[] =')
        lines.append('\n{')
        for mod in mods:
            lines.append('\n\t{')
            lines.append(f'\n\t\t.name = "{mod}",')
            lines.append(f'\n\t\t.f_start = {mod}_start')
            lines.append('\n\t},')
        lines[-1] = lines[-1][:-1] # Remove last ','
        lines.append('\n};')
        lines.append('\n')        

        # Mod count
        lines.append('\n// Mod count')
        lines.append(f'\nsize_t const ggen_static_mods_count = {len(mods)};')
        lines.append('\n')

        f.writelines(lines)
except Exception as e:
    print("Error while writing to target file.")
    print(e)
    exit(1)

    