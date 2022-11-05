
# BEGIN config
ML_CFLAGS :=
ML_LDFLAGS :=

ML_DIR := modloader/
# prefix ML_DIR
ML_SRC_DIR := src/
ML_INC_DIR := inc/

# prefix BIN_DIR
ML_EXEC := dotc2

#END config

ML_GEN :=

ML_SRC_DIR := $(ML_DIR)$(ML_SRC_DIR)
ML_INC_DIR := $(ML_DIR)$(ML_INC_DIR)

ML_EXEC := $(BIN_DIR)$(ML_EXEC)

ML_SRC := $(shell $(FIND) $(ML_SRC_DIR) -name '*.c')
ML_INC := $(shell $(FIND) $(ML_INC_DIR) -name '*.h')
ML_INC += $(shell $(FIND) $(ML_SRC_DIR) -name '*.h')

ML_SRC += $(ML_GEN)

ML_OBJ := $(patsubst %,$(OBJ_DIR)%.o,$(ML_SRC))


ifeq ($(ML_OBJ),)
$(error No source file found for modloader)
endif

define ml_gen_target

$(eval GEN_SCRIPT := $(PY_DIR)$(patsubst $(BLD_DIR)%,%,$(GEN_DIR))$(1).py)
$(eval GEN_TARGET := $(GEN_DIR)$(1))
$(eval GEN_PROLOGUE := $(MKDIR) -p $(dir $(GEN_TARGET)))
$(eval ML_GEN += $(GEN_TARGET))
$(eval .PHONY: $(GEN_TARGET))
endef

$(call ml_gen_target,static_mods.c)
$(GEN_TARGET): $(GEN_SCRIPT)
	$(GEN_PROLOGUE)
	$(PY) $(GEN_SCRIPT) $(ROOT_DIR) $(GEN_TARGET) $(VMODS)

.PHONY: dotc2 dotc2-gen run debug
dotc2: $(ML_EXEC)

dotc2-gen: $(ML_GEN)

run: dotc2
	$(MKDIR) -p $(HOME_DIR)
	$(CD) $(HOME_DIR) && $(ROOT_DIR)$(ML_EXEC)

debug: dotc2
	$(MKDIR) -p $(HOME_DIR)
	$(CD) $(HOME_DIR) && $(GDB) $(ROOT_DIR)$(ML_EXEC)

$(ML_EXEC): $(ML_GEN) $(ML_OBJ) $(patsubst %,$(STC_DIR)%.a,$(STC_MODS))
	$(MKDIR) -p $(dir $@)
	$(LD) $(CFLAGS) $(ML_CFLAGS) -I$(ML_INC_DIR) $(LDFLAGS) $(ML_LDFLAGS) $^ -o $@

$(OBJ_DIR)$(ML_DIR)%.c.o: $(ML_DIR)%.c $(ML_INC)
	$(MKDIR) -p $(dir $@)
	$(CC) $(CFLAGS) $(ML_CFLAGS) -I$(ML_INC_DIR) -c $< -o $@
