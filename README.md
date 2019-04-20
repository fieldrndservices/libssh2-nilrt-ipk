# libssh2-nilrt-ipk: A CMake Superbuild for a libssh2 IPK Package

The libssh2-nilrt-ipk project is a [Cmake](https://cmake.org/) [superbuild](https://blog.kitware.com/cmake-superbuilds-git-submodules/) to build a [opkg package (.ipk)](https://openwrt.org/docs/guide-user/additional-software/opkg) of the [libssh2](https://www.libssh2.org) library for the [NI Linux RT](http://www.ni.com/en-us/innovations/white-papers/13/introduction-to-ni-linux-real-time.html) operating system that is used for [National Instruments (NI)](https://www.ni.com) embedded hardware, such as a [CompactRIO (cRIO)](http://www.ni.com/en-us/shop/compactrio.html).

NI provides a package manager (opkg) and a repository (feed) to optionally install and extend the capabilities of their embedded hardware running the NI Linux RT operating system. There are many packages available from NI's official repository, but libssh2 is not available in the repository. The libssh2 library is used for client-side SSH and SFTP communication. It does _not_ implement a SSH server. It is specifically targeted at enabling clients to communicate with a SSH/SFTP server. This project is intended to provide a libssh2 package that can be installed on the embedded hardware from NI using opkg package manager.

This project is structured as a CMake superbuild, using [git](https://git-scm.com/) [submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules). Thus, there is no source code folder. The "source code" for this project is all related to building the libssh2 source code provided as a git submodule and packaging it into a IPK file using CMake. The source code for the libssh2 library is "imported" into this project as a git submodule instead of using CMake's [ExternalProject_Add](https://cmake.org/cmake/help/latest/module/ExternalProject.html) features because the build procedure must be run on a properly configured cRIO that typically does not have access to the Internet. Importing the libssh2 source code via a git submodule makes it easier to simply download the entire contents of this project and transfer to the cRIO in an offline fashion.

## Quick Start

1. Download a IPK file from available from the [Releases](https://github.com/fieldrndservices/libssh2-nilrt-ipk/releases) to a host computer. Make sure the architecture matches the cRIO's processor, i.e. ARM (cortexa9-vfpv3) or Intel (core2-64).
2. Connect a cRIO to the host computer.
3. Power on the cRIO.
4. Transfer the IPK file to the cRIO.
5. Log into the cRIO with a suitable SSH client from the host computer.
6. Navigate to the directory containing the IPK file.
7. Execute the following command:

   ```
   opkg install libssh2*.ipk
   ```

   The libssh2 library will now be available to the cRIO.
   
## Build

Ensure that a cRIO has been suitably configured as a build environment before completing the following steps to create the IPK file.

1. Clone this project on a host computer.

   ```
   git clone https://github.com/fieldrndservices/libssh2-nilrt-ipk.git
   ```
   
2. Update the git submodules to get the [libssh2](https://github.com/libssh2/libssh2) source code.

   ```
   git submodule update --init --recursive
   ```
   
3. Connect the cRIO running NI Linux RT to host computer.
4. Power on the cRIO.
5. Transfer the contents of the cloned source code, including the `libssh2` directory, to the cRIO's `/tmp` directory. Note, the contents of the `/tmp` folder are deleted after each reboot/power cycle of the cRIO. It may help to first create an archive (ZIP or compressed tar, *.tar.gz) file to easily transfer the contents. The `.git` hidden file does _not_ need to be transferred.
6. Log into the cRIO via SSH.
7. Navigate to the source code on the cRIO.

   ```
   cd `/tmp/libssh2-nilrt-ipk`
   ```

8. Execute the following commands to build the IPK file:

   ```
   mkdir build
   cd build
   cmake ..
   cmake --build . --target ipk
   ```

   A IPK file will be created in the `build` directory. See the [Quick Start](#quick-start) instructions for installation.

## License

The `libssh2-nilrt-ipk` project is licensed under the [BSD-3-Clause license](https://opensource.org/licenses/BSD-3-Clause). See the [LICENSE](https://github.com/fieldrndservices/libssh2-nilrt-ipk/blob/master/LICENSE) file for more information about licensing and copyright. Note, this license only covers files specific to this project and _not_ submodules (libssh2). Please see the submodules for specifics on their respective licensing and copyright.
