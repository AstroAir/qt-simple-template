# Package Manager Troubleshooting Guide

This guide helps resolve common issues with the package manager priority system in qt-simple-template.

## Quick Diagnostics

### Run the Validation Script

```bash
# Test all package manager scenarios
./scripts/validate_package_managers.sh
```

This script will:

- Check MSYS2 environment and packages
- Verify vcpkg availability
- Test Conan configuration
- Validate CMake configuration with different package managers

### Check Package Manager Selection

```bash
# See which package manager was selected
cmake -S . -B build/diagnostic -DCMAKE_BUILD_TYPE=Debug
# Look for "Package Manager Selection Summary" in the output
```

## Common Issues and Solutions

### 1. MSYS2 Issues

#### Issue: "MSYS2 environment not detected"

**Symptoms:**

- Running in MSYS2 but system doesn't detect it
- Falls back to other package managers unexpectedly

**Solutions:**

```bash
# Check if you're in the correct MSYS2 environment
echo $MSYSTEM
# Should show MINGW64, UCRT64, CLANG64, etc.

# If empty, start the correct MSYS2 environment:
# For MINGW64:
/c/msys64/msys2_shell.cmd -mingw64

# For UCRT64:
/c/msys64/msys2_shell.cmd -ucrt64
```

#### Issue: "Qt6 packages not found in MSYS2"

**Symptoms:**

- MSYS2 detected but Qt6 packages missing
- Error: "Some Qt6 packages are missing in MSYS2"

**Solutions:**

```bash
# Check which packages are missing
pacman -Q mingw-w64-x86_64-qt6-base mingw-w64-x86_64-qt6-svg mingw-w64-x86_64-qt6-tools

# Install missing packages for MINGW64
pacman -S mingw-w64-x86_64-qt6-base mingw-w64-x86_64-qt6-svg mingw-w64-x86_64-qt6-tools

# For UCRT64
pacman -S mingw-w64-ucrt-x86_64-qt6-base mingw-w64-ucrt-x86_64-qt6-svg mingw-w64-ucrt-x86_64-qt6-tools

# For CLANG64
pacman -S mingw-w64-clang-x86_64-qt6-base mingw-w64-clang-x86_64-qt6-svg mingw-w64-clang-x86_64-qt6-tools

# Or use the automated script
./scripts/build_msys2.sh --install-deps
```

#### Issue: "pacman not found"

**Symptoms:**

- Error: "pacman not found, cannot check MSYS2 packages"

**Solutions:**

```bash
# Make sure you're in MSYS2 environment, not Windows Command Prompt
# Check PATH includes MSYS2 bin directory
echo $PATH | grep msys64

# If not found, restart MSYS2 properly
```

### 2. vcpkg Issues

#### Issue: "vcpkg not detected"

**Symptoms:**

- vcpkg installed but not detected by build system
- Falls back to other package managers

**Solutions:**

```bash
# Set VCPKG_ROOT environment variable
export VCPKG_ROOT=/path/to/vcpkg

# Or specify toolchain file explicitly
cmake -DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake -S . -B build

# Check if vcpkg.json exists in project root
ls -la vcpkg.json

# Force vcpkg usage
cmake -DFORCE_PACKAGE_MANAGER=VCPKG -S . -B build
```

#### Issue: "vcpkg packages not installed"

**Symptoms:**

- vcpkg detected but Qt6 packages missing
- CMake can't find Qt6 components

**Solutions:**

```bash
# Install Qt6 packages with vcpkg
vcpkg install qtbase qtsvg qttools

# For specific triplet
vcpkg install qtbase:x64-windows qtsvg:x64-windows qttools:x64-windows

# Check installed packages
vcpkg list | grep qt
```

### 3. Conan Issues

#### Issue: "Conan not detected"

**Symptoms:**

- Conan installed but not detected
- No conan_toolchain.cmake generated

**Solutions:**

```bash
# Check Conan installation
conan --version

# Create Conan profile if missing
conan profile detect --force

# Generate toolchain for the project
conan install . --build=missing -s build_type=Debug

# Check for conanfile
ls -la conanfile.py conanfile.txt

# Force Conan usage
cmake -DFORCE_PACKAGE_MANAGER=CONAN -S . -B build
```

#### Issue: "Conan packages not found"

**Symptoms:**

- Conan detected but Qt6 packages missing
- Build fails with missing Qt6 components

**Solutions:**

```bash
# Install dependencies with Conan
conan install . --build=missing

# For specific build type
conan install . --build=missing -s build_type=Debug

# Check Conan remotes
conan remote list

# Add Conan Center if missing
conan remote add conancenter https://center.conan.io
```

### 4. CMake Configuration Issues

#### Issue: "Package manager selection failed"

**Symptoms:**

- CMake configuration fails
- No suitable package manager found

**Solutions:**

```bash
# Check what package managers are available
./scripts/validate_package_managers.sh

# Force system packages as fallback
cmake -DFORCE_PACKAGE_MANAGER=SYSTEM -S . -B build

# Check CMake version
cmake --version
# Ensure CMake 3.28 or later

# Clear CMake cache
rm -rf build/
```

#### Issue: "Qt6 not found"

**Symptoms:**

- Package manager selected but Qt6 still not found
- CMake error: "Could not find a package configuration file provided by Qt6"

**Solutions:**

```bash
# Check Qt6 installation paths
find /usr -name "Qt6Config.cmake" 2>/dev/null
find $VCPKG_ROOT -name "Qt6Config.cmake" 2>/dev/null

# Set Qt6_DIR manually
cmake -DQt6_DIR=/path/to/qt6/lib/cmake/Qt6 -S . -B build

# For MSYS2, check MSYSTEM_PREFIX
echo $MSYSTEM_PREFIX
ls $MSYSTEM_PREFIX/lib/cmake/Qt6/
```

### 5. Build Script Issues

#### Issue: "Build script fails with package errors"

**Symptoms:**

- `./scripts/build_msys2.sh` fails
- Package checking errors

**Solutions:**

```bash
# Run with verbose output
./scripts/build_msys2.sh --build-type Debug 2>&1 | tee build.log

# Check package availability first
./scripts/build_msys2.sh --configure-only

# Install dependencies automatically
./scripts/build_msys2.sh --install-deps

# Clean and retry
./scripts/build_msys2.sh --clean --build-type Debug
```

### 6. Preset Issues

#### Issue: "CMake preset not found"

**Symptoms:**

- Error: "No such preset in CMakePresets.json"
- Preset exists but not recognized

**Solutions:**

```bash
# Check preset file exists
ls -la CMakePresets-extended.json

# List available presets
cmake --list-presets

# Use preset with explicit file
cmake --preset Hybrid-Debug-MSYS2-First --preset-file CMakePresets-extended.json

# Check preset syntax
cat CMakePresets-extended.json | jq .
```

## Advanced Troubleshooting

### Debug Package Manager Detection

Add debug output to CMake configuration:

```bash
cmake -S . -B build/debug \
  -DCMAKE_BUILD_TYPE=Debug \
  --log-level=DEBUG \
  -DFORCE_PACKAGE_MANAGER="" 2>&1 | grep -E "(MSYS2|vcpkg|Conan|Package)"
```

### Test Individual Components

Test each package manager separately:

```bash
# Test MSYS2 only
cmake -DFORCE_PACKAGE_MANAGER=MSYS2 -S . -B build/test-msys2

# Test vcpkg only
cmake -DFORCE_PACKAGE_MANAGER=VCPKG -S . -B build/test-vcpkg

# Test Conan only
cmake -DFORCE_PACKAGE_MANAGER=CONAN -S . -B build/test-conan

# Test system only
cmake -DFORCE_PACKAGE_MANAGER=SYSTEM -S . -B build/test-system
```

### Environment Debugging

Check environment variables:

```bash
# MSYS2 variables
echo "MSYSTEM: $MSYSTEM"
echo "MSYSTEM_PREFIX: $MSYSTEM_PREFIX"

# vcpkg variables
echo "VCPKG_ROOT: $VCPKG_ROOT"

# PATH
echo "PATH: $PATH"

# CMake variables
cmake -S . -B build/env-test -LA | grep -E "(PACKAGE_MANAGER|Qt6|MSYS2|VCPKG|CONAN)"
```

## Getting Help

### Collect Diagnostic Information

When reporting issues, include:

```bash
# System information
uname -a
cmake --version

# Environment
echo "MSYSTEM: $MSYSTEM"
echo "VCPKG_ROOT: $VCPKG_ROOT"

# Package manager status
./scripts/validate_package_managers.sh

# CMake configuration log
cmake -S . -B build/diagnostic --log-level=STATUS 2>&1 | tee cmake-config.log
```

### Common Log Messages

| Message | Meaning | Action |
|---------|---------|--------|
| "MSYS2 environment detected" | MSYS2 found | ✅ Good |
| "MSYS2 package not found" | Missing Qt6 package | Install with pacman |
| "vcpkg toolchain detected" | vcpkg configured | ✅ Good |
| "Conan toolchain detected" | Conan configured | ✅ Good |
| "No package manager found" | All failed | Check installations |
| "Fallback successful" | Automatic fallback worked | ✅ Good |

### Support Resources

- [Package Manager Priority Documentation](package-manager-priority.md)
- [MSYS2 Official Documentation](https://www.msys2.org/)
- [vcpkg Documentation](https://vcpkg.io/)
- [Conan Documentation](https://docs.conan.io/)
- [CMake Documentation](https://cmake.org/documentation/)
