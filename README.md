# libssh2-nilrt-ipk: A CMake Superbuild for a libssh2 IPK Package

The libssh2-nilrt-ipk project is a [Cmake](https://cmake.org/) [superbuild](https://blog.kitware.com/cmake-superbuilds-git-submodules/) to build a [opkg package (.ipk)](https://openwrt.org/docs/guide-user/additional-software/opkg) of the [libssh2](https://www.libssh2.org) library for the [NI Linux RT](http://www.ni.com/en-us/innovations/white-papers/13/introduction-to-ni-linux-real-time.html) operating system that is used for [National Instruments (NI)](https://www.ni.com) embedded hardware, such as a [CompactRIO (cRIO)](http://www.ni.com/en-us/shop/compactrio.html).

NI provides a package manager (opkg) and a repository (feed) to optionally install and extend the capabilities of their embedded hardware running the NI Linux RT operating system. There are many packages available from NI's official repository, but libssh2 is not available in the repository. The libssh2 library is used for client-side SSH and SFTP communication. It does _not_ implement a SSH server. It is specifically targeted at enabling clients to communicate with a SSH/SFTP server. This project is intended to provide a libssh2 package that can be installed on the embedded hardware from NI using opkg package manager.

This project is structured as a CMake superbuild. There is no source code folder. The "source code" for this project is all related to building the libssh2 source code provided as a compressed tar file and packaging it into a IPK file using CMake. The source code for the libssh2 library is included in this project as a compressed tar file instead of using CMake's [ExternalProject_Add](https://cmake.org/cmake/help/latest/module/ExternalProject.html) download or version control features because the build procedure must be run on a properly configured cRIO that typically does not have access to the Internet. Providing the libssh2 source code via an archive (*.tar.gz) makes it easier to simply download the source contents of a release for this project and transfer to the cRIO in an offline fashion.

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

Ensure that a cRIO has been [suitably configured as a build environment](https://gist.github.com/volks73/ff5bdf361c1dccd6005bfaa31ab80441) before completing the following steps to create the IPK file.

1. Download a compressed tar file from the [Releases](https://github.com/fieldrndservices/libssh2-nilrt-ipk/releases) to a host computer.
2. Connect the cRIO running NI Linux RT to host computer.
3. Power on the cRIO.
4. Transfer the compressed tar file to the `/tmp` folder on the cRIO.

   ```
   scp libssh2-nilrt-ipk.tar.gz admin@XXX.XXX.XXX.XXX:/tmp/
   ``` 
   
   where `XXX.XXX.XXX.XXX` is the IP address, or host name, of the cRIO. Note, the contents of the `/tmp` folder are deleted after each reboot/power cycle of the cRIO.
5. Log into the cRIO via SSH.
6. Navigate to the `/tmp` folder on the cRIO.

   ```
   cd `/tmp`
   ```
   
7. Extract the compressed tar file.

   ```
   tar -xzf libssh2-nilrt-ipk.tar.gz
   ```
   
8. Navigate into the `libssh2-nilrt-ipk` folder.

   ```
   cd libssh2-nilrt-ipk
   ```
   
9. Execute the following commands to build the IPK file:

   ```
   mkdir build
   cd build
   cmake ..
   cmake --build . --target ipk
   ```

   A IPK file will be created in the `build` directory. See the [Quick Start](#quick-start) instructions for installation.

## License

The `libssh2-nilrt-ipk` project is licensed under the [BSD-3-Clause license](https://opensource.org/licenses/BSD-3-Clause). See the [LICENSE](https://github.com/fieldrndservices/libssh2-nilrt-ipk/blob/master/LICENSE) file for more information about licensing and copyright. Note, this license only covers files specific to this project and _not_ libssh2. Please see libssh2's documentation for specifics on licensing and copyright of the libssh2 source code.
