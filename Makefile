# $(info $$(MIX_TARGET) is [$(MIX_TARGET)])
# $(info $$(MIX_APP_PATH) is [$(MIX_APP_PATH)])
# $(info $$(MIX_BUILD_PATH) is [$(MIX_BUILD_PATH)])

# NERVES_SDK_SYSROOT is used in src/cyclonedds.cmake
# $(info $$(NERVES_SDK_SYSROOT) is [$(NERVES_SDK_SYSROOT)])

# Output directory

MIX_APP_PRIV_DIR = $(MIX_APP_PATH)/priv
MIX_APP_OBJ_DIR  = $(MIX_APP_PATH)/obj

# Cyclone DDS

ifeq ($(MIX_TARGET),host)
DDS_INSTALL_DIR ?= /usr/local
else
export DDS_INSTALL_DIR = $(MIX_BUILD_PATH)/nerves/rootfs_overlay/usr
endif

# DDS_INSTALL_DIR is used in src/cyclonedds.cmake
# $(info $$(DDS_INSTALL_DIR) is [$(DDS_INSTALL_DIR)])

DDS_SRC_DIR = src/cyclonedds
DDS_BUILD_DIR = $(MIX_BUILD_PATH)/cyclonedds
DDS_CMAKE = cyclonedds.cmake

# DDS APP

DDS_APP_NIF = $(MIX_APP_PRIV_DIR)/ddstest_nif.so
DDS_APP_DIR = src/ddstest
DDS_APP_HEADERS = $(wildcard $(DDS_APP_DIR)/*.h)
DDS_APP_SRC = $(wildcard $(DDS_APP_DIR)/*.c)
DDS_APP_OBJ = $(DDS_APP_SRC:$(DDS_APP_DIR)/%.c=$(MIX_APP_OBJ_DIR)/%.o)

# Compile settings

CFLAGS ?= -O2 -Wall -Wextra -Wno-unused-parameter
CFLAGS += -fPIC
LDFLAGS += -fPIC -shared

# Set Erlang-specific compile and linker flags

ERL_CFLAGS ?= -I$(ERL_EI_INCLUDE_DIR)
ERL_LDFLAGS ?= -L$(ERL_EI_LIBDIR) -lei

CFLAGS += -I$(DDS_INSTALL_DIR)/include
LIBS += -L$(DDS_INSTALL_DIR)/lib -lddsc

# Make

all: install-dds install-dds-app

install-dds-app: $(MIX_APP_PRIV_DIR) $(MIX_APP_OBJ_DIR) $(DDS_APP_NIF)

install-dds: build-dds
	@cmake --build $(DDS_BUILD_DIR) --target install

build-dds:
	@mkdir -p $(DDS_BUILD_DIR)
	-@test ! -d $(DDS_SRC_DIR) && git clone https://github.com/eclipse-cyclonedds/cyclonedds.git --depth 1 --branch 0.9.0a1 $(DDS_SRC_DIR)
	@cp src/$(DDS_CMAKE) $(DDS_BUILD_DIR)/$(DDS_CMAKE)
	@cmake -D CMAKE_TOOLCHAIN_FILE=$(DDS_CMAKE) -S $(DDS_SRC_DIR) -B $(DDS_BUILD_DIR)
	@cmake --build $(DDS_BUILD_DIR)

$(DDS_APP_OBJ): $(DDS_APP_HEADERS) Makefile

$(MIX_APP_OBJ_DIR)/%.o: $(DDS_APP_DIR)/%.c
	$(CC) -o $@ $< -c $(ERL_CFLAGS) $(CFLAGS)

$(DDS_APP_NIF): $(DDS_APP_OBJ)
	$(CC) -o $@ $^ $(LDFLAGS) $(ERL_LDFLAGS) $(LIBS)

$(MIX_APP_PRIV_DIR) $(MIX_APP_OBJ_DIR):
	@mkdir -p $@

clean: clean-dds clean-dds-app

clean-dds:
	@rm -rf $(DDS_BUILD_DIR)

clean-dds-app:
	@rm -rf $(DDS_APP_NIF) $(DDS_APP_OBJ)

.PHONY: all install-dds install-dds-app clean clean-dds clean-dds-app
