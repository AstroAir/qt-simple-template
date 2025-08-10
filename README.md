# qt-simple-template

Example based on C++ + Qt6 + Vcpkg + GithubCI

## Project Structure

The project is organized into the following directories:

- `app`: Contains the main application code.
- `controls`: Contains custom controls used by the application.
- `assets`: Contains assets used by the application, such as styles and images.
- `cmake`: Contains custom CMake modules.
- `.github/workflows`: Contains the GitHub Actions workflow for CI/CD.

## Build Process

The project uses CMake for building. To build the project, you need to have CMake and a C++ compiler installed. You also need to have `vcpkg` installed to manage the dependencies.

### Windows

```bash
cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=C:/vcpkg/scripts/buildsystems/vcpkg.cmake -DVCPKG_TARGET_TRIPLET=x64-windows
cmake --build build --config Release
```

### Linux

```bash
cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=/path/to/vcpkg/scripts/buildsystems/vcpkg.cmake -DVCPKG_TARGET_TRIPLET=x64-linux
cmake --build build --config Release
```

### macOS

```bash
cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=/path/to/vcpkg/scripts/buildsystems/vcpkg.cmake -DVCPKG_TARGET_TRIPLET=x64-osx
cmake --build build --config Release
```

## CI/CD

The project uses GitHub Actions for CI/CD. The workflow is defined in the `.github/workflows/ci.yml` file. The workflow builds the project on Windows, Linux, and macOS, and it packages the application and uploads the artifacts.
