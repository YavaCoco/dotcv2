
# prefix BLD_DIR
OBJ_DIR  := $(BLD_DIR)$(OBJ_DIR)
DIST_DIR := $(BLD_DIR)$(DIST_DIR)
STC_DIR := $(BLD_DIR)$(STC_DIR)
GEN_DIR := $(BLD_DIR)$(GEN_DIR)

# prefix DIST_DIR
BIN_DIR := $(DIST_DIR)$(BIN_DIR)
LIB_DIR := $(DIST_DIR)$(LIB_DIR)
HOME_DIR := $(DIST_DIR)$(HOME_DIR)

# prefix BUILDSYS
PY_DIR := $(BUILDSYS)$(PY_DIR)

# no prefix
ROOT_DIR := $(shell $(PWD))/

# flags
ifndef RELEASE
CFLAGS += -O0 -ggdb3 -DPREFIX="/"
else
CFLAGS += -O3
endif

# Functions
## Check if file exists
fexist = $(or $(and $(wildcard $(1)),1),)
