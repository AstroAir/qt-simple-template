# Package Manager Configuration Guide

This guide explains how to configure and use different package managers with the Qt Simple Template project.

## Overview

The build system prioritizes packages in the following order:

1. **System Packages** (Default) - Uses system-installed packages via package managers like apt, brew, pacman
2. **vcpkg** (Optional) - Cross-platform C++ package manager by Microsoft
3. **Conan** (Optional) - Professional C++ package manager with advanced features

## System Packages (Default)

System packages are the default and recommended approach for most users. They provide:

- ✅ Fast builds (no compilation of dependencies)
- ✅ System integration and consistency
- ✅ Automatic security updates through system package manager
- ✅ Smaller disk usage
- ✅ Better compatibility with system libraries

### Platform-Specific Installation

#### Ubuntu/Debian
```bash
# Essential packages
sudo apt install qt6-base-dev qt6-tools-dev qt6-svg-dev

# Development tools
sudo apt install cmake ninja-build build-essential

# Optional Qt6 modules
sudo apt install qt6-multimedia-dev qt6-network-dev qt6-webengine-dev
```

#### Fedora/RHEL/CentOS
```bash
# Essential packages
sudo dnf install qt6-qtbase-devel qt6-qttools-devel qt6-qtsvg-devel

# Development tools
sudo dnf install cmake ninja-build gcc-c++

# Optional Qt6 modules
sudo dnf install qt6-qtmultimedia-devel qt6-qtnetwork-devel
```

#### Arch Linux
```bash
# Essential packages
sudo pacman -S qt6-base qt6-tools qt6-svg

# Development tools
sudo pacman -S cmake ninja base-devel

# Optional Qt6 modules
sudo pacman -S qt6-multimedia qt6-networkauth qt6-webengine
```

#### macOS (Homebrew)
```bash
# Essential packages
brew install qt6 cmake ninja

# Set environment variables (add to ~/.zshrc or ~/.bash_profile)
echo 'export PATH="/opt/homebrew/opt/qt6/bin:$PATH"' >> ~/.zshrc
echo 'export CMAKE_PREFIX_PATH="/opt/homebrew/opt/qt6"' >> ~/.zshrc
```

#### Windows (MSYS2)
```bash
# In MSYS2 UCRT64 terminal (recommended)
pacman -S mingw-w64-ucrt-x86_64-qt6-base
pacman -S mingw-w64-ucrt-x86_64-qt6-tools
pacman -S mingw-w64-ucrt-x86_64-qt6-svg
pacman -S mingw-w64-ucrt-x86_64-cmake
pacman -S mingw-w64-ucrt-x86_64-ninja
```

## vcpkg Integration

vcpkg is Microsoft's cross-platform package manager that provides:

- ✅ Consistent versions across platforms
- ✅ Easy dependency management
- ✅ Integration with Visual Studio and CMake
- ❌ Longer build times (compiles from source)
- ❌ Larger disk usage

### Setup vcpkg

```bash
# Clone vcpkg
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg

# Bootstrap (Linux/macOS)
./bootstrap-vcpkg.sh

# Bootstrap (Windows)
.\bootstrap-vcpkg.bat

# Set environment variable
export VCPKG_ROOT=$(pwd)  # Linux/macOS
set VCPKG_ROOT=%CD%       # Windows CMD
$env:VCPKG_ROOT = $PWD    # Windows PowerShell
```

### Configure vcpkg for Qt

```bash
# Install Qt6 packages
./vcpkg install qt6-base qt6-tools qt6-svg

# For specific triplets
./vcpkg install qt6-base:x64-windows qt6-tools:x64-windows qt6-svg:x64-windows
./vcpkg install qt6-base:x64-linux qt6-tools:x64-linux qt6-svg:x64-linux
./vcpkg install qt6-base:x64-osx qt6-tools:x64-osx qt6-svg:x64-osx
```

### Build with vcpkg

```bash
# Method 1: Enable vcpkg option
cmake -DUSE_VCPKG=ON ..

# Method 2: Force vcpkg
cmake -DFORCE_PACKAGE_MANAGER=VCPKG ..

# Method 3: Direct toolchain
cmake -DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake ..
```

## Conan Integration

Conan is a professional package manager that provides:

- ✅ Advanced dependency resolution
- ✅ Binary package caching
- ✅ Custom package recipes
- ✅ Enterprise features
- ❌ More complex setup
- ❌ Learning curve

### Setup Conan

```bash
# Install Conan
pip install conan

# Create and configure profile
conan profile detect --force

# View profile
conan profile show default

# Customize profile if needed
conan profile update settings.compiler.cppstd=20 default
```

### Configure Conan for Qt

The project includes `conanfile.py` and `conanfile.txt` for Conan integration:

```python
# conanfile.py (excerpt)
def requirements(self):
    self.requires("qt/6.7.0")
    
def configure(self):
    if self.settings.os == "Windows":
        self.options["qt"].shared = True
```

### Build with Conan

```bash
# Method 1: Automated script
python scripts/build_conan.py --build-type Debug

# Method 2: Manual workflow
conan install . --output-folder build/conan --build missing
cmake --preset conan-debug -DUSE_CONAN=ON
cmake --build build/conan

# Method 3: Force Conan
cmake -DFORCE_PACKAGE_MANAGER=CONAN ..
```

## Configuration Options

### CMake Options

| Option | Default | Description |
|--------|---------|-------------|
| `USE_VCPKG` | `OFF` | Enable vcpkg package manager |
| `USE_CONAN` | `OFF` | Enable Conan package manager |
| `USE_MSYS2` | `OFF` | Enable MSYS2 package manager |
| `FORCE_PACKAGE_MANAGER` | `""` | Force specific package manager |

### Force Package Manager Values

| Value | Description |
|-------|-------------|
| `SYSTEM` | Use system packages (explicit) |
| `VCPKG` | Force vcpkg usage |
| `CONAN` | Force Conan usage |
| `MSYS2` | Force MSYS2 usage (Windows only) |

### Environment Variables

| Variable | Description |
|----------|-------------|
| `VCPKG_ROOT` | Path to vcpkg installation |
| `CMAKE_PREFIX_PATH` | Additional paths for find_package |
| `Qt6_DIR` | Direct path to Qt6 CMake files |

## Best Practices

### Choosing a Package Manager

**Use System Packages when:**
- Developing on a single platform
- Want fast builds and small disk usage
- System has recent Qt6 packages available
- Contributing to system package ecosystem

**Use vcpkg when:**
- Need consistent versions across platforms
- Working in a team with mixed platforms
- Using Visual Studio on Windows
- Want reproducible builds

**Use Conan when:**
- Need advanced dependency management
- Working with complex dependency graphs
- Using enterprise features
- Need custom package recipes

### Performance Considerations

```bash
# Enable parallel builds
cmake --build . --parallel $(nproc)  # Linux
cmake --build . --parallel %NUMBER_OF_PROCESSORS%  # Windows

# Use Ninja generator for faster builds
cmake -G Ninja ..
ninja

# Use ccache for faster rebuilds (Linux/macOS)
export CMAKE_CXX_COMPILER_LAUNCHER=ccache
```

### Troubleshooting

#### Common Issues

1. **Qt6 not found with system packages**
   ```bash
   # Check installation
   pkg-config --modversion Qt6Core  # Linux
   brew list qt6  # macOS
   
   # Set CMAKE_PREFIX_PATH
   cmake -DCMAKE_PREFIX_PATH=/usr/lib/x86_64-linux-gnu/cmake/Qt6 ..
   ```

2. **vcpkg toolchain not found**
   ```bash
   # Verify VCPKG_ROOT
   echo $VCPKG_ROOT
   ls $VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake
   ```

3. **Conan packages not found**
   ```bash
   # Check Conan installation
   conan search qt
   conan profile show default
   
   # Clean and reinstall
   conan remove "*" --confirm
   conan install . --build missing
   ```

#### Debug Configuration

```bash
# Enable verbose CMake output
cmake -DCMAKE_VERBOSE_MAKEFILE=ON ..

# Show package manager selection
cmake -DCMAKE_MESSAGE_LOG_LEVEL=STATUS ..

# Debug find_package calls
cmake -DCMAKE_FIND_DEBUG_MODE=ON ..
```

## Migration Guide

### From Package Manager to System Packages

1. Install system Qt6 packages
2. Remove package manager options from CMake command
3. Clean build directory
4. Reconfigure and build

### From System Packages to Package Manager

1. Set up chosen package manager (vcpkg/Conan)
2. Add appropriate CMake option
3. Clean build directory
4. Reconfigure and build

### Between Package Managers

1. Clean build directory completely
2. Change package manager option
3. Reconfigure with new package manager
4. Build project
