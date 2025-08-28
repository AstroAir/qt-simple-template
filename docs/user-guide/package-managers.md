# Package Manager Guide

qt-simple-template supports multiple package managers to give you flexibility in dependency management. This guide covers all supported options and helps you choose the best one for your project.

## Supported Package Managers

### 1. vcpkg (Default)

**Best for**: Cross-platform development, Microsoft ecosystem integration

vcpkg is Microsoft's C++ package manager that provides excellent CMake integration and cross-platform support.

#### Advantages

- Excellent CMake integration
- Wide package availability
- Cross-platform support
- Active development and maintenance
- Good Windows support

#### Setup

```bash
# Install vcpkg
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
./bootstrap-vcpkg.sh  # Linux/macOS
.\bootstrap-vcpkg.bat  # Windows

# Set environment variable
export VCPKG_ROOT=/path/to/vcpkg  # Linux/macOS
set VCPKG_ROOT=C:\path\to\vcpkg   # Windows
```

#### Building

```bash
# Configure and build
cmake --preset Debug-Unix     # Linux/macOS
cmake --preset Debug-Windows  # Windows
cmake --build build/Debug
```

### 2. Conan

**Best for**: Professional development, complex dependency management

Conan is a modern, decentralized package manager with excellent versioning and dependency resolution.

#### Advantages

- Professional-grade dependency management
- Excellent versioning support
- Binary package caching
- Recipe-based approach
- Good CI/CD integration

#### Setup

```bash
# Install Conan
pip install conan

# Create default profile
conan profile detect --force
```

#### Building

```bash
# Using the build script (recommended)
python scripts/build_conan.py --build-type Debug

# Manual approach
conan install . --output-folder build/Conan-Debug --build missing
cmake --preset Conan-Debug-Unix
cmake --build build/Conan-Debug
```

### 3. MSYS2 (Windows)

**Best for**: Windows development with Unix-like tools, MinGW compilation

MSYS2 provides a Unix-like environment on Windows with the pacman package manager.

#### Advantages

- Unix-like development environment on Windows
- Fast package installation with pacman
- Multiple compiler toolchains (MinGW, UCRT, Clang)
- Good for cross-compilation
- Native Windows binaries

#### Setup

1. Download and install MSYS2 from <https://www.msys2.org/>
2. Open MSYS2 terminal
3. Update packages: `pacman -Syu`

#### Building

```bash
# Using the build script (recommended)
./scripts/build_msys2.sh --build-type Debug --install-deps

# From Windows Command Prompt
scripts\build_msys2.bat --build-type Debug

# Manual approach
pacman -S mingw-w64-x86_64-qt6-base mingw-w64-x86_64-qt6-svg
cmake --preset MSYS2-Debug
cmake --build build/MSYS2-Debug
```

### 4. System Packages

**Best for**: Linux distribution packages, minimal setup

Use your system's package manager for Qt6 and other dependencies.

#### Ubuntu/Debian

```bash
sudo apt install qt6-base-dev qt6-svg-dev qt6-tools-dev cmake ninja-build
cmake -S . -B build -G Ninja
cmake --build build
```

#### Fedora/RHEL

```bash
sudo dnf install qt6-qtbase-devel qt6-qtsvg-devel qt6-qttools-devel cmake ninja-build
cmake -S . -B build -G Ninja
cmake --build build
```

#### Arch Linux

```bash
sudo pacman -S qt6-base qt6-svg qt6-tools cmake ninja
cmake -S . -B build -G Ninja
cmake --build build
```

## Package Manager Comparison

| Feature | vcpkg | Conan | MSYS2 | System |
|---------|-------|-------|-------|--------|
| **Cross-platform** | ✅ | ✅ | ❌ (Windows only) | ❌ |
| **Binary caching** | ✅ | ✅ | ✅ | ✅ |
| **Version control** | ⚠️ Limited | ✅ Excellent | ⚠️ Limited | ❌ |
| **Setup complexity** | Medium | Medium | Low | Very Low |
| **Build speed** | Medium | Fast | Fast | Very Fast |
| **Package availability** | High | High | High | Varies |
| **CI/CD friendly** | ✅ | ✅ | ⚠️ Limited | ✅ |

## Choosing a Package Manager

### Use vcpkg if

- You're developing cross-platform applications
- You're working in a Microsoft ecosystem
- You want good CMake integration out of the box
- You prefer a centralized package repository

### Use Conan if

- You need professional-grade dependency management
- You're working with complex dependency graphs
- You want excellent version control and conflict resolution
- You're building for multiple configurations/platforms

### Use MSYS2 if

- You're developing primarily for Windows
- You prefer Unix-like development tools
- You want fast package installation
- You're familiar with pacman package manager

### Use System Packages if

- You're developing for a specific Linux distribution
- You want minimal setup overhead
- You're comfortable with system package management
- You don't need specific package versions

## Migration Between Package Managers

### From vcpkg to Conan

1. Create `conanfile.py` or `conanfile.txt`
2. Install dependencies: `conan install . --build missing`
3. Use Conan CMake presets or update CMakeLists.txt
4. Update CI/CD workflows

### From Conan to vcpkg

1. Ensure `vcpkg.json` is properly configured
2. Set `VCPKG_ROOT` environment variable
3. Use vcpkg CMake presets
4. Update CI/CD workflows

### From MSYS2 to vcpkg/Conan

1. Install vcpkg or Conan
2. Configure dependencies in respective files
3. Update build scripts and presets
4. Test cross-platform compatibility

## CI/CD Integration

### GitHub Actions

The template includes workflows for all package managers:

- `.github/workflows/ci.yml` - vcpkg builds
- `.github/workflows/conan-ci.yml` - Conan builds  
- `.github/workflows/msys2-ci.yml` - MSYS2 builds

### Custom CI Systems

Each package manager provides different integration approaches:

**vcpkg**: Use vcpkg toolchain file

```cmake
-DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake
```

**Conan**: Use generated toolchain

```cmake
-DCMAKE_TOOLCHAIN_FILE=build/conan_toolchain.cmake
```

**MSYS2**: Use MSYS2 environment

```bash
msys2 -c "cmake --build build"
```

## Troubleshooting

### Common Issues

#### vcpkg

- **Issue**: Package not found
- **Solution**: Update vcpkg registry: `git pull` in vcpkg directory

#### Conan

- **Issue**: Profile not found
- **Solution**: Create profile: `conan profile detect --force`

#### MSYS2

- **Issue**: Qt not found
- **Solution**: Install Qt packages for your environment:

  ```bash
  pacman -S mingw-w64-x86_64-qt6-base mingw-w64-x86_64-qt6-svg
  ```

#### System Packages

- **Issue**: Version conflicts
- **Solution**: Use package manager to resolve conflicts or consider vcpkg/Conan

### Performance Tips

1. **Enable package caching** in CI/CD
2. **Use binary packages** when available
3. **Parallelize builds** with `-j` flag
4. **Cache build directories** between runs
5. **Use precompiled headers** for large projects

## Best Practices

1. **Document your choice**: Clearly document which package manager your project uses
2. **Provide alternatives**: Consider supporting multiple package managers
3. **Version pinning**: Pin dependency versions for reproducible builds
4. **CI testing**: Test with your chosen package manager in CI
5. **Team consistency**: Ensure all team members use the same package manager
6. **Backup plans**: Have fallback options for critical dependencies
