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
set(LIBSSH2_VERSION "1.8.2")

# CMake extensions
include(ExternalProject)
include(GNUInstallDirs)

# Build each module by including the `External_<module name>` file, which should
# be located in the CMAKE_MODULE_PATH.
include(External_${LIBSSH2})

# Once all of the modules have been built, the outputs from each module build
# can be used to set the field values for the `control` file of the IPK file if needed.

# Package-wide variables
set(PACKAGE_ARCH "cortexa9-vfpv3")
set(PACKAGE_FILE_NAME "${LIBSSH2}_${LIBSSH2_VERSION}-r${PROJECT_VERSION}_${PACKAGE_ARCH}")

# CPack configuration
set(CPACK_CMAKE_GENERATOR "Unix Makefiles")
set(CPACK_GENERATOR "DEB")
set(CPACK_PACKAGE_VENDOR "Field R&D Services, LLC")
set(CPACK_PACKAGE_FILE_NAME ${PACKAGE_FILE_NAME})
set(CPACK_DEBIAN_PACKAGE_NAME ${LIBSSH2})
set(CPACK_DEBIAN_PACKAGE_VERSION ${LIBSSH2_VERSION})
set(CPACK_DEBIAN_PACKAGE_RELEASE "r${PROJECT_VERSION}")
set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE ${PACKAGE_ARCH})
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

# The `include(CPack)` command will create the `package` and `package_source`
# build targets, which will build a deb file if invoked as `cmake --build .
# --target package`. For CMake 3.5 or earlier, it is not possible to change the
# file extension from deb to ipk with the Cpack DEB generator. Newer versions of
# CMake/CPack have the `CPACK_DEBIAN_FILE_NAME` variable that can be set with
# either the `.deb` or `.ipk` file extension. Because of a dependency issue with
# the libarchive package, CMake 3.4 is used. Thus, the deb file must be renamed
# to ipk (they are same structure, just different extensions) after the deb
# package is built.
#
# Because of a bug, or missing feature, in CMake and CPack, it is not possible
# for a custom target or command to depend on the `package` or `package_source`
# build targets created by the `include(CPack)` command. Instead, a custom build
# target is added that first builds the `package` target then renames the deb.
# This is essentially a hack to workaround two problems: older version of
# CMake/CPack and inability to depend on built-in targets.
#
# The real solution is to be able to upgrade to a newer version of CMake (3.6 or
# higher) and just specify the ipk file extension in the
# `CPACK_DEBIAN_FILE_NAME` variable.
add_custom_target(ipk
  COMMAND "${CMAKE_COMMAND}" --build . --target package
  COMMAND mv ${PACKAGE_FILE_NAME}.deb ${PACKAGE_FILE_NAME}.ipk
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  COMMENT "Renaming package from deb to ipk"
)
