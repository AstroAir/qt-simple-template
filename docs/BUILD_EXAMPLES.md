# Build Examples and Configuration Guide

This document provides comprehensive examples for building the Qt Simple Template project with different package management configurations.

## Default Build (System Packages)

The build system uses system-installed packages by default. This is the recommended approach for most users.

### Prerequisites by Platform

#### Ubuntu/Debian
```bash
# Install Qt6 and build tools
sudo apt update
sudo apt install qt6-base-dev qt6-tools-dev qt6-svg-dev cmake ninja-build

# Optional: Additional Qt6 modules
sudo apt install qt6-multimedia-dev qt6-network-dev
```

#### Fedora/RHEL/CentOS
```bash
# Install Qt6 and build tools
sudo dnf install qt6-qtbase-devel qt6-qttools-devel qt6-qtsvg-devel cmake ninja-build

# Optional: Additional Qt6 modules
sudo dnf install qt6-qtmultimedia-devel qt6-qtnetwork-devel
```

#### Arch Linux
```bash
# Install Qt6 and build tools
sudo pacman -S qt6-base qt6-tools qt6-svg cmake ninja

# Optional: Additional Qt6 modules
sudo pacman -S qt6-multimedia qt6-networkauth
```

#### macOS (Homebrew)
```bash
# Install Qt6 and build tools
brew install qt6 cmake ninja

# Add Qt6 to PATH (add to ~/.zshrc or ~/.bash_profile)
export PATH="/opt/homebrew/opt/qt6/bin:$PATH"
export CMAKE_PREFIX_PATH="/opt/homebrew/opt/qt6"
```

#### Windows (MSYS2)
```bash
# In MSYS2 UCRT64 terminal
pacman -S mingw-w64-ucrt-x86_64-qt6-base mingw-w64-ucrt-x86_64-qt6-tools
pacman -S mingw-w64-ucrt-x86_64-qt6-svg mingw-w64-ucrt-x86_64-cmake
pacman -S mingw-w64-ucrt-x86_64-ninja
```

### Basic Build Commands

```bash
# Clone the repository
git clone <repository-url>
cd qt-simple-template

# Configure and build (system packages - default)
mkdir build && cd build
cmake ..
cmake --build .

# Alternative with Ninja generator
cmake -G Ninja ..
ninja

# Run the application
./app/qt_simple_template  # Linux/macOS
.\app\qt_simple_template.exe  # Windows
```

## Package Manager Configurations

### vcpkg Integration

#### Setup vcpkg
```bash
# Install vcpkg
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg

# Bootstrap vcpkg
./bootstrap-vcpkg.sh  # Linux/macOS
.\bootstrap-vcpkg.bat  # Windows

# Set environment variable
export VCPKG_ROOT=/path/to/vcpkg  # Linux/macOS
set VCPKG_ROOT=C:\path\to\vcpkg   # Windows
```

#### Build with vcpkg
```bash
# Method 1: Using USE_VCPKG option
mkdir build && cd build
cmake -DUSE_VCPKG=ON ..
cmake --build .

# Method 2: Using FORCE_PACKAGE_MANAGER
cmake -DFORCE_PACKAGE_MANAGER=VCPKG ..
cmake --build .

# Method 3: Using vcpkg toolchain directly
cmake -DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake ..
cmake --build .
```

### Conan Integration

#### Setup Conan
```bash
# Install Conan
pip install conan

# Create default profile
conan profile detect --force

# Optional: Customize profile
conan profile show default
```

#### Build with Conan
```bash
# Method 1: Using automated script
python scripts/build_conan.py --build-type Debug

# Method 2: Manual Conan workflow
conan install . --output-folder build/conan --build missing
cmake --preset conan-debug -DUSE_CONAN=ON
cmake --build build/conan

# Method 3: Using FORCE_PACKAGE_MANAGER
mkdir build && cd build
cmake -DFORCE_PACKAGE_MANAGER=CONAN ..
cmake --build .
```

## Advanced Configuration Examples

### Cross-Platform Build Scripts

#### Linux/macOS Build Script
```bash
#!/bin/bash
# build.sh

set -e

BUILD_TYPE=${1:-Debug}
PACKAGE_MANAGER=${2:-SYSTEM}

echo "Building with $BUILD_TYPE configuration using $PACKAGE_MANAGER packages"

# Create build directory
mkdir -p build/$BUILD_TYPE
cd build/$BUILD_TYPE

# Configure based on package manager
case $PACKAGE_MANAGER in
    "VCPKG")
        cmake -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DUSE_VCPKG=ON ../..
        ;;
    "CONAN")
        cmake -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DUSE_CONAN=ON ../..
        ;;
    "SYSTEM"|*)
        cmake -DCMAKE_BUILD_TYPE=$BUILD_TYPE ../..
        ;;
esac

# Build
cmake --build . --config $BUILD_TYPE

echo "Build completed successfully!"
```

#### Windows Build Script
```batch
@echo off
REM build.bat

set BUILD_TYPE=%1
if "%BUILD_TYPE%"=="" set BUILD_TYPE=Debug

set PACKAGE_MANAGER=%2
if "%PACKAGE_MANAGER%"=="" set PACKAGE_MANAGER=SYSTEM

echo Building with %BUILD_TYPE% configuration using %PACKAGE_MANAGER% packages

REM Create build directory
if not exist build\%BUILD_TYPE% mkdir build\%BUILD_TYPE%
cd build\%BUILD_TYPE%

REM Configure based on package manager
if "%PACKAGE_MANAGER%"=="VCPKG" (
    cmake -DCMAKE_BUILD_TYPE=%BUILD_TYPE% -DUSE_VCPKG=ON ..\..
) else if "%PACKAGE_MANAGER%"=="CONAN" (
    cmake -DCMAKE_BUILD_TYPE=%BUILD_TYPE% -DUSE_CONAN=ON ..\..
) else (
    cmake -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ..\..
)

REM Build
cmake --build . --config %BUILD_TYPE%

echo Build completed successfully!
```

### CMake Presets Usage

The project includes CMake presets for common configurations:

```bash
# List available presets
cmake --list-presets

# Use system packages (default)
cmake --preset Debug-Unix      # Linux/macOS
cmake --preset Debug-Windows   # Windows

# Use vcpkg
cmake --preset Debug-Unix-vcpkg
cmake --preset Debug-Windows-vcpkg

# Use Conan
cmake --preset Conan-Debug-Unix
cmake --preset Conan-Debug-Windows

# Build with preset
cmake --build --preset Debug-Unix
```

## Troubleshooting Common Issues

### Qt6 Not Found
```bash
# Check Qt6 installation
find /usr -name "Qt6Config.cmake" 2>/dev/null  # Linux
brew --prefix qt6  # macOS

# Set CMAKE_PREFIX_PATH if needed
cmake -DCMAKE_PREFIX_PATH=/path/to/qt6 ..
```

### vcpkg Issues
```bash
# Verify vcpkg installation
$VCPKG_ROOT/vcpkg list qt6

# Install Qt6 manually if needed
$VCPKG_ROOT/vcpkg install qt6-base qt6-tools qt6-svg
```

### Conan Issues
```bash
# Check Conan profile
conan profile show default

# Clean Conan cache if needed
conan remove "*" --confirm
```

### Build System Debug
```bash
# Enable verbose output
cmake --build . --verbose

# Show detailed configuration
cmake -DCMAKE_VERBOSE_MAKEFILE=ON ..
```

## Performance Optimization

### Parallel Builds
```bash
# Use all available cores
cmake --build . --parallel

# Specify core count
cmake --build . --parallel 4

# With Ninja (automatically uses all cores)
cmake -G Ninja ..
ninja
```

### Compiler Optimization
```bash
# Release build with optimizations
cmake -DCMAKE_BUILD_TYPE=Release ..

# Release with debug info
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..

# Minimal size release
cmake -DCMAKE_BUILD_TYPE=MinSizeRel ..
```
