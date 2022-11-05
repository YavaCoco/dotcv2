# This file is interpreted by a python script, and as such shouldn't use any make syntax fancier than variable assingment
# The only lines allowed here are:
# Lines starting with #
# Lines in the form `[A-Za-z0-9_-]+\s*:=\s*[sdi]`

# Select which modules are statically linked, dynamically linked, or ignored
# Use s for static linking
# Use d for dynamic linking
# Use i to ignore

# Statically link all essential devices(just because)
MOD_CPU := s
MOD_CPU_CTL := s
MOD_MEM_CTL := s
MOD_IO_CTL := s
MOD_FWARE_CTL := s
MOD_FWARE_ROM := s

MOD_MEM := s
