cmake_minimum_required(VERSION 3.4)
project(libssh2-nilrt-ipk VERSION 0.1 LANGUAGES C)
set(PROJECT_URL "https://github.com/fieldrndservices/libssh2-nilrt-ipk")
set(PROJECT_DESCRIPTION "A CMake Super Build to create libssh2 IPK files for the NI Linux RT operating system")

# Module settings
#
# For each git submodule, there should be an `External_<module name>.cmake` file
# in the CMake modules folder. The `External_<module name>.cmake` file is
# responsible for configuration and building the module using the
# ExternalProject extension.
#
# The `External_<module name>.cmake` file is also responsible for setting any
# variables that can be used, or needed, to build the IPK package. For example,
# the paths to the build outputs, like a shared or static library, should be set
# to variables that include the module name.
#
# Additionally, for each git submodule, a CMake variable with its module name
# should be defined. While rare, this is in case the module name changes, it
# only has to be changed in one place.
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})
set(LIBSSH2 "libssh2")

# CMake extensions
include(ExternalProject)
include(GNUInstallDirs)

# Build each module by including the `External_<module name>` file, which should
# be located in the CMAKE_MODULE_PATH.
include(External_${LIBSSH2})

# Once all of the modules have been built, the outputs from each module build
# can be used to set the field values for the `control` file of the IPK file if needed.
set(CPACK_CMAKE_GENERATOR "Unix Makefiles")
set(CPACK_GENERATOR "DEB")
set(CPACK_DEBIAN_PACKAGE_NAME "libssh2")
set(CPACK_DEBIAN_PACKAGE_VERSION "1.8.2")
set(CPACK_DEBIAN_PACKAGE_RELEASE "r0.1")
set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "cortexa9-vfpv3")
set(CPACK_DEBIAN_PACKAGE_DESCRIPTION "Client-side C library implementing the SSH2 protocol")
set(CPACK_DEBIAN_PACKAGE_SECTION "libs")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Christopher R. Field <chris@fieldrndservices.com>")

# CPack uses the `install` command to determine the contents of the package.
install(FILES
  "${LIBSSH2_INCLUDE_DIR}/libssh2.h"
  "${LIBSSH2_INCLUDE_DIR}/libssh2_publickey.h"
  "${LIBSSH2_INCLUDE_DIR}/libssh2_sftp.h"
  DESTINATION
  ${CMAKE_INSTALL_INCLUDEDIR}
)

install(FILES
  "${LIBSSH2_LIBRARY_DIR}/libssh2.so.1.0.1"
  "${LIBSSH2_LIBRARY_DIR}/libssh2.so.1"
  "${LIBSSH2_LIBRARY_DIR}/libssh2.so"
  DESTINATION
  ${CMAKE_INSTALL_LIBDIR}
)

include(CPack)
