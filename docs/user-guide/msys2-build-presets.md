# MSYS2 Build Presets Guide

This guide explains how to use the MSYS2-specific build presets in qt-simple-template for optimal development and packaging on Windows.

## Overview

The project includes comprehensive MSYS2 build presets that support all major MSYS2 environments and integrate with the package manager priority system.

## Available MSYS2 Presets

### Configure Presets

#### MINGW64 Environment
- **MSYS2-MINGW64-Debug**: Debug build for MINGW64 environment
- **MSYS2-MINGW64-Release**: Release build for MINGW64 environment

#### UCRT64 Environment (Recommended)
- **MSYS2-UCRT64-Debug**: Debug build for UCRT64 environment
- **MSYS2-UCRT64-Release**: Release build for UCRT64 environment

#### CLANG64 Environment
- **MSYS2-CLANG64-Debug**: Debug build for CLANG64 environment
- **MSYS2-CLANG64-Release**: Release build for CLANG64 environment

#### Hybrid Mode
- **MSYS2-Hybrid-Debug**: Debug build with package manager fallback
- **MSYS2-Hybrid-Release**: Release build with package manager fallback

### Build Presets

All configure presets have corresponding build presets with the same names, optimized for parallel compilation (8 jobs).

### Test Presets

All configure presets have corresponding test presets that output detailed information on test failures.

## Environment Detection

The presets automatically detect the MSYS2 environment using the `$env{MSYSTEM}` variable:

- **MINGW64**: Traditional MinGW-w64 GCC toolchain
- **UCRT64**: Modern UCRT-based GCC toolchain (recommended for new projects)
- **CLANG64**: LLVM/Clang toolchain

## Package Manager Integration

### Pure MSYS2 Mode
The environment-specific presets (`MSYS2-MINGW64-*`, `MSYS2-UCRT64-*`, `MSYS2-CLANG64-*`) force the use of MSYS2 packages only:

```cmake
FORCE_PACKAGE_MANAGER=MSYS2
```

### Hybrid Mode
The hybrid presets (`MSYS2-Hybrid-*`) use the package manager priority system:

```cmake
PACKAGE_MANAGER_PRIORITY_ORDER=MSYS2;VCPKG;CONAN
```

This allows fallback to vcpkg or Conan if packages are not available in MSYS2.

## Usage Examples

### Basic Usage

```bash
# Configure for UCRT64 Debug (recommended)
cmake --preset MSYS2-UCRT64-Debug

# Build
cmake --build --preset MSYS2-UCRT64-Debug

# Test
ctest --preset MSYS2-UCRT64-Debug
```

### Environment-Specific Usage

```bash
# In MINGW64 environment
export MSYSTEM=MINGW64
cmake --preset MSYS2-MINGW64-Release
cmake --build --preset MSYS2-MINGW64-Release

# In UCRT64 environment
export MSYSTEM=UCRT64
cmake --preset MSYS2-UCRT64-Release
cmake --build --preset MSYS2-UCRT64-Release

# In CLANG64 environment
export MSYSTEM=CLANG64
cmake --preset MSYS2-CLANG64-Release
cmake --build --preset MSYS2-CLANG64-Release
```

### Hybrid Mode Usage

```bash
# Use hybrid mode for maximum compatibility
cmake --preset MSYS2-Hybrid-Release
cmake --build --preset MSYS2-Hybrid-Release
```

## Prerequisites

### MSYS2 Installation

1. **Install MSYS2**:
   ```bash
   # Download from https://www.msys2.org/
   # Or use package managers:
   winget install MSYS2.MSYS2
   # or
   choco install msys2
   ```

2. **Update MSYS2**:
   ```bash
   pacman -Syu
   ```

### Environment-Specific Dependencies

#### MINGW64 Environment
```bash
# Launch MINGW64 terminal
pacman -S mingw-w64-x86_64-toolchain
pacman -S mingw-w64-x86_64-cmake
pacman -S mingw-w64-x86_64-ninja
pacman -S mingw-w64-x86_64-qt6-base
pacman -S mingw-w64-x86_64-qt6-svg
```

#### UCRT64 Environment (Recommended)
```bash
# Launch UCRT64 terminal
pacman -S mingw-w64-ucrt-x86_64-toolchain
pacman -S mingw-w64-ucrt-x86_64-cmake
pacman -S mingw-w64-ucrt-x86_64-ninja
pacman -S mingw-w64-ucrt-x86_64-qt6-base
pacman -S mingw-w64-ucrt-x86_64-qt6-svg
```

#### CLANG64 Environment
```bash
# Launch CLANG64 terminal
pacman -S mingw-w64-clang-x86_64-toolchain
pacman -S mingw-w64-clang-x86_64-cmake
pacman -S mingw-w64-clang-x86_64-ninja
pacman -S mingw-w64-clang-x86_64-qt6-base
pacman -S mingw-w64-clang-x86_64-qt6-svg
```

## Environment Comparison

| Environment | Compiler | Runtime | Recommended Use |
|-------------|----------|---------|-----------------|
| MINGW64     | GCC      | MSVCRT  | Legacy compatibility |
| UCRT64      | GCC      | UCRT    | **New projects (recommended)** |
| CLANG64     | Clang    | UCRT    | Advanced features, static analysis |

### UCRT64 Advantages
- Modern Universal C Runtime
- Better C++ standard library support
- Improved performance
- Better Windows integration
- Future-proof

## Packaging with MSYS2

### Manual Packaging Commands

```bash
# Build release version
cmake --preset MSYS2-UCRT64-Release
cmake --build --preset MSYS2-UCRT64-Release

# Create packages
cmake --build build/MSYS2-UCRT64-Release --target package_nsis_msys2
cmake --build build/MSYS2-UCRT64-Release --target package_msys2_portable
```

### Available Package Targets

- `package_nsis_msys2`: NSIS installer for MSYS2 builds
- `package_msys2_portable`: Portable ZIP package
- `package_all`: All available packages for the platform

## Troubleshooting

### Common Issues

1. **Environment Not Detected**:
   ```bash
   # Ensure you're in the correct MSYS2 terminal
   echo $MSYSTEM
   # Should output: MINGW64, UCRT64, or CLANG64
   ```

2. **Missing Dependencies**:
   ```bash
   # Install missing packages
   pacman -S mingw-w64-ucrt-x86_64-qt6-base
   ```

3. **Path Issues**:
   ```bash
   # Verify CMake and Ninja are in PATH
   which cmake
   which ninja
   ```

### Performance Tips

1. **Use Ninja Generator**: All presets use Ninja for faster builds
2. **Parallel Jobs**: Build presets use 8 parallel jobs by default
3. **UCRT64 Recommended**: Use UCRT64 for best performance and compatibility

## Integration with IDEs

### Visual Studio Code
```json
{
    "cmake.configurePreset": "MSYS2-UCRT64-Debug",
    "cmake.buildPreset": "MSYS2-UCRT64-Debug",
    "cmake.testPreset": "MSYS2-UCRT64-Debug"
}
```

### CLion
1. Go to Settings → Build, Execution, Deployment → CMake
2. Add new profile with preset: `MSYS2-UCRT64-Debug`
3. Set toolchain to MSYS2 environment

### Qt Creator
1. Configure kit with MSYS2 compiler
2. Set CMake preset in project settings
3. Use MSYS2 environment paths

## CI/CD Integration

The MSYS2 presets integrate seamlessly with GitHub Actions and other CI systems. See the [CI/CD documentation](../ci-cd/github-actions.md) for complete workflows.

This comprehensive MSYS2 support ensures optimal development experience on Windows with native package management and excellent performance.
