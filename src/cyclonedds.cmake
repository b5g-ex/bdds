set(CMAKE_SYSTEM_NAME Linux)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(CMAKE_FIND_ROOT_PATH $ENV{NERVES_SDK_SYSROOT})
set(CMAKE_SYSROOT $ENV{NERVES_SDK_SYSROOT})

set(CMAKE_STAGING_PREFIX $ENV{DDS_INSTALL_DIR})
# message("CMAKE_STAGING_PREFIX: ${CMAKE_STAGING_PREFIX}")

set(CMAKE_VERBOSE_MAKEFILE TRUE)
set(CMAKE_FIND_DEBUG_MODE TRUE)
