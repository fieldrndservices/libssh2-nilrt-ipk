set(_source "${CMAKE_CURRENT_SOURCE_DIR}/libssh2")
set(_build "${CMAKE_CURRENT_BINARY_DIR}/libssh2")

ExternalProject_Add(libssh2
  SOURCE_DIR ${_source}
  BINARY_DIR ${_build}
  CMAKE_ARGS -DBUILD_SHARED_LIBS=ON -DBUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF -DBUILD_DOCS=OFF -DCRYPTO_BACKEND=OpenSSL
)
