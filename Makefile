$(info $$(CC) is [$(CC)])
$(info $$(RM) is [$(RM)])
$(info $$(MIX_TARGET) is [$(MIX_TARGET)])
$(info $$(MIX_APP_PATH) is [$(MIX_APP_PATH)])
$(info $$(MIX_BUILD_PATH) is [$(MIX_BUILD_PATH)])
$(info $$(NERVES_SDK_SYSROOT) is [$(NERVES_SDK_SYSROOT)])
$(info $$(LIBS) is [$(LIBS)])

ifeq ($(MIX_TARGET),host)
DDS_INSTALL_DIR ?= /usr/local
else
export DDS_INSTALL_DIR = $(MIX_BUILD_PATH)/nerves/rootfs_overlay/usr
endif

$(info $$(DDS_INSTALL_DIR) is [$(DDS_INSTALL_DIR)])

DDS_SRC_DIR = src/cyclonedds
DDS_BUILD_DIR = $(MIX_BUILD_PATH)/cyclonedds
DDS_CMAKE = cyclonedds.cmake

#================
MIX_APP_PRIV_DIR = $(MIX_APP_PATH)/priv
MIX_APP_OBJ_DIR  = $(MIX_APP_PATH)/obj

CFLAGS ?= -O2 -Wall -Wextra -Wno-unused-parameter
CFLAGS += -fPIC
LDFLAGS += -fPIC -shared

# Set Erlang-specific compile and linker flags
ERL_CFLAGS ?= -I$(ERL_EI_INCLUDE_DIR)
ERL_LDFLAGS ?= -L$(ERL_EI_LIBDIR) -lei

CFLAGS += -I$(DDS_INSTALL_DIR)/include
LIBS += -L$(DDS_INSTALL_DIR)/lib -lddsc

DDS_APP_HEADERS = $(wildcard src/ddstest/*.h)
DDS_APP_SRC = $(wildcard src/ddstest/*.c)
DDS_APP_OBJ = $(DDS_APP_SRC:src/ddstest/%.c=$(MIX_APP_OBJ_DIR)/%.o)
DDS_APP_NIF = $(MIX_APP_PRIV_DIR)/ddstest_nif.so
#================

all: install-dds install-dds-app
	@echo "all"

install-dds-app: $(MIX_APP_PRIV_DIR) $(MIX_APP_OBJ_DIR) $(DDS_APP_NIF)

install-dds: build-dds
	@echo $@
	@cmake --build $(DDS_BUILD_DIR) --target install

build-dds:
	@echo $@
	@mkdir -p $(DDS_BUILD_DIR)
	@cp src/$(DDS_CMAKE) $(DDS_BUILD_DIR)/$(DDS_CMAKE)
	@cmake -D CMAKE_TOOLCHAIN_FILE=$(DDS_CMAKE) -S $(DDS_SRC_DIR) -B $(DDS_BUILD_DIR)
	@cmake --build $(DDS_BUILD_DIR)

$(DDS_APP_OBJ): $(DDS_APP_HEADERS) Makefile

$(MIX_APP_OBJ_DIR)/%.o: src/ddstest/%.c
	@echo "MIX_APP_OBJ_DIR"
	@echo $@
	$(CC) -o $@ $< -c $(ERL_CFLAGS) $(CFLAGS)

$(DDS_APP_NIF): $(DDS_APP_OBJ)
	@echo "DDS_APP_NIF"
	@echo $@
	$(CC) -o $@ $^ $(LDFLAGS) $(ERL_LDFLAGS) $(LIBS)

$(MIX_APP_PRIV_DIR) $(MIX_APP_OBJ_DIR):
	@mkdir -p $@

clean: clean-dds clean-dds-app
	@echo "clean"

clean-dds:
	@rm -rf $(DDS_BUILD_DIR)

clean-dds-app:
	@rm -rf $(DDS_APP_NIF) $(DDS_APP_OBJ)

.PHONY: all install-dds install-dds-app clean clean-dds clean-dds-app
