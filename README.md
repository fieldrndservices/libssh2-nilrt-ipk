# Creating a libssh2 IPK with a NI Linux RT-enabled cRIO 

1. Build the libssh2 shared object library with the cRIO
2. Move into the `bin` folder if not already there after building the libssh2 shared library.

   ```
   $ cd bin
   ```

3. Create the folder structure with the following commands:

   ```
   $ mkdir -p ipk/control
   $ mkdir -p ipk/data/usr/libs
   $ mkdir -p ipk/data/usr/include
   ```
   
4. Copy the build output files for the libssh2 shared object library to the appropriate destinations with the following commands:

   ```
   $ cp ../include/*.h ipk/data/usr/include/
   $ cp src/libssh2.so.1.0.1 ipk/data/usr/lib/
   $ cp -a src/libssh2.so.1 ipk/data/usr/lib/
   ```
   
5. Change permission for the header files in the `include` folder with the following command:

   ```
   $ chmod a-x ipk/data/usr/include/*.h
   ```
   
6. Create the `control` file in the `control` folder with the following content:

   ```
   Package: libssh2
   Version: 1.8.2-r0.1
   Description: client-side C library implementing the SSH2 protocol
   Section: libs
   Priority: optional
   Maintainer: Christopher R. Field <chris@fieldrndservices.com>
   Architecture: cortexa9-vfpv3
   Homepage: https://github.com/fieldrndservices/libssh2-ipk
   ```
   
   Note, the `Architecture` value must be changed to match the cRIO's architecture, either: `cortexa9-vfpv3` or `core2-64`.
   
7. Create the `debian-binary` file with the following command:

   ```
   $ echo 2.0 > ipk/debian-binary
   
   ```

8. Move into the `ipk/control` folder with the following command:

   ```
   $ cd ipk/control
   ```
   
9. Archive the `control` folder with the following command:

   ```
   $ tar --numeric-owner --group=0 --owner=0 -czf ../control.tar.gz ./*
   ```
  
10. Move to the `ipk/data` folder with the following command:

   ```
   $ cd ../data
   ```
   
10. Archive the `data` folder with the following command:

   ```
   $ tar --numeric-owner --group=0 --owner=0 -czf ../data.tar.gz ./* 
   ```
   
11. Move to the parent folder, i.e. `ipk`, with the following command:

   ```
   $ cd ..
   ```
   
12. Create the IPK file with the following command:

   ```
   $ ar r libssh2_1.8.2-r0.1_cortexa9-vfpv3.ipk control.tar.gz data.tar.gz debian-binary
   ```
   
   The "cortexa9-vfpv3" in the IPK file name should be replaced with the cRIO's architecture and should match the value used for the `Architecture` field in the `control` file from earlier (either `cortexa9-vfpv3` or `core2-64`). 
