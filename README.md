# CrossBuild
Docker image for cross-compiling C/C++ code

### Using

Example using CMake to build x86 Windows target:

```
$ docker run --rm -v $(pwd):/workdir dinocore/crossbuild cmake -DCMAKE_TOOLCHAIN_FILE=/cmake/x86-win.cmake

```