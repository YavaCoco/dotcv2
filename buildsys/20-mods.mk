
MODS_DIR := mods/

# prefix MODS_DIR/$(mod)/
SETUP_FILE := setup.mk

#! dir list without /
MODS := $(patsubst $(MODS_DIR)%/,%,$(sort $(dir $(wildcard $(MODS_DIR)*/))))
VMODS := # valid mods
MODSCN := $(foreach MOD,$(MODS),$(shell $(ECHO) -n '$(MOD)' | $(TR) '[:lower:]-' '[:upper:]_'))

modpath = $(MODS_DIR)$(MOD)/
modvar = $(MOD)_$(1)
modcapname = $(shell $(ECHO) -n '$(MOD)' | $(TR) '[:lower:]-' '[:upper:]_')

CPU_VERSION := 1.0

define modverif
$(if 
	$(call fexist,$(modpath)$(SETUP_FILE)),
	$(eval VMODS += $(MOD)),
)
endef

DYN_MODS :=
STC_MODS :=

define modinc
$(eval $(MOD)_SRC_DIR := src/)
$(eval $(MOD)_INC_DIR := inc/)
$(eval include $(modpath)$(SETUP_FILE))
$(eval $(MOD)_SRC_DIR := $(modpath)$($(MOD)_SRC_DIR))
$(eval $(MOD)_INC_DIR := $(modpath)$($(MOD)_INC_DIR))
$(eval $(MOD)_SRC := $(shell $(FIND) $($(MOD)_SRC_DIR) -name '*.c'))
$(eval $(MOD)_INC := $(shell $(FIND) $($(MOD)_INC_DIR) -name '*.h'))
$(eval $(MOD)_INC += $(shell $(FIND) $($(MOD)_SRC_DIR) -name '*.h'))

$(eval $(MOD)_OBJ := $(patsubst %,$(OBJ_DIR)%.o,$($(MOD)_SRC)))

$(if $($(MOD)_OBJ),,$(error $(MOD) has no source file.))

$(if $(filter-out $(MOD_$(modcapname)),s),$(eval DYN_MODS += $(MOD)),)
$(if $(filter-out $(MOD_$(modcapname)),d),$(eval STC_MODS += $(MOD)),)

endef

$(foreach MOD,$(MODS),$(modverif))
$(foreach MOD,$(VMODS),$(modinc))

# Dynamic library
.PHONY: $(patsubst %,%-dyn,$(VMODS))
$(patsubst %,%-dyn,$(VMODS)): $(LIB_DIR)$$(patsubst %-dyn,%,$$@).so

$(patsubst %,$(LIB_DIR)%.so,$(VMODS)): $$($$(patsubst $(LIB_DIR)%.so,%,$$@)_OBJ)
	$(eval MOD := $(patsubst $(LIB_DIR)%.so,%,$@))
	$(MKDIR) -p $(dir $@)
	$(LD) $(CFLAGS) $($(MOD)_CFLAGS) $(LDFLAGS) $($(MOD)_LDFLAGS) -shared $^ -o $@


# Static library
$(patsubst %,%-stc,$(VMODS)): $(STC_DIR)$$(patsubst %-stc,%,$$@).a

$(patsubst %,$(STC_DIR)%.a,$(VMODS)): $$($$(patsubst $(STC_DIR)%.a,%,$$@)_OBJ)
	$(MKDIR) -p $(dir $@)
	$(AR) rcs $@ $?

# Object files
$(OBJ_DIR)$(MODS_DIR)%.c.o: $(MODS_DIR)%.c $$($$(word 1,$$(subst /, ,$$*))_INC)
	$(eval MOD := $(word 1,$(subst /, ,$(patsubst $(OBJ_DIR)$(MODS_DIR)%,%,$@))))
	$(MKDIR) -p $(dir $@)
	$(CC) $(CFLAGS) $($(MOD)_CFLAGS) $(patsubst %,-I%,$($(MOD)_INC_DIR)) -c $< -o $@

.PHONY: mods stc-mods dyn-mods
stc-mods: $(patsubst %,%-stc,$(STC_MODS))
dyn-mods: $(patsubst %,%-dyn,$(DYN_MODS))
mods: stc-mods dyn-mods

