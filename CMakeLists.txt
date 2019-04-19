cmake_minimum_required(VERSION 3.4)
project(libssh2-nilrt-ipk VERSION 0.1 LANGUAGES C)
set(PROJECT_URL "https://github.com/fieldrndservices/libssh2-nilrt-ipk")
set(PROJECT_DESCRIPTION "A CMake Super Build to create libssh2 IPK files for the NI Linux RT operating system")

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})

include(ExternalProject)
include(External_libssh2)
include(CPack)
