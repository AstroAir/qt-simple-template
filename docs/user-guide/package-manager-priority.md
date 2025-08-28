# Package Manager Priority System

The qt-simple-template project includes an intelligent package manager priority system that automatically selects the best available package manager for your environment. This system prioritizes MSYS2 system packages first, then falls back to vcpkg or Conan if needed.

## Overview

The priority system follows this order:

1. **MSYS2** (when in MSYS2 environment with Qt6 packages available)
2. **vcpkg** (when vcpkg is configured or available)
3. **Conan** (when Conan is configured or available)
4. **System packages** (fallback when no package manager is available)

## How It Works

### Automatic Detection

The build system automatically detects your environment and available package managers:

```bash
# In MSYS2 environment with Qt6 packages installed
cmake -S . -B build/auto
# Result: Uses MSYS2 packages

# In environment with vcpkg but no MSYS2
cmake -S . -B build/auto
# Result: Uses vcpkg packages

# In environment with only system Qt6
cmake -S . -B build/auto
# Result: Uses system packages
```

### Environment Detection

The system detects:

- **MSYS2 Environment**: Checks `$MSYSTEM` environment variable
- **MSYS2 Packages**: Verifies Qt6 packages are installed via pacman
- **vcpkg**: Looks for `$VCPKG_ROOT`, toolchain file, or `vcpkg.json`
- **Conan**: Checks for Conan executable, `conanfile.py/txt`, or toolchain

### Package Availability Checking

For MSYS2, the system checks these packages:

- `mingw-w64-{arch}-qt6-base`
- `mingw-w64-{arch}-qt6-svg`
- `mingw-w64-{arch}-qt6-tools`

Where `{arch}` depends on your MSYS2 environment:

- MINGW64: `x86_64`
- UCRT64: `ucrt-x86_64`
- CLANG64: `clang-x86_64`
- etc.

## Usage Examples

### Using CMake Presets

#### Hybrid Presets (Automatic Priority)

```bash
# MSYS2 first, then vcpkg, then Conan
cmake --preset Hybrid-Debug-MSYS2-First
cmake --build build/Hybrid-Debug

# vcpkg first, then MSYS2, then Conan
cmake --preset Hybrid-Debug-vcpkg-First
cmake --build build/Hybrid-vcpkg-Debug
```

#### Forced Package Manager

```bash
# Force MSYS2 only (fails if not available)
cmake --preset Force-MSYS2-Debug

# Force vcpkg only
cmake --preset Force-vcpkg-Debug

# Force Conan only
cmake --preset Force-Conan-Debug

# Force system packages only
cmake --preset Force-System-Debug
```

### Using CMake Variables

#### Custom Priority Order

```bash
cmake -S . -B build/custom \
  -DPACKAGE_MANAGER_PRIORITY_ORDER="VCPKG;CONAN;MSYS2"
```

#### Force Specific Package Manager

```bash
# Force MSYS2
cmake -S . -B build/msys2 -DFORCE_PACKAGE_MANAGER=MSYS2

# Force vcpkg
cmake -S . -B build/vcpkg -DFORCE_PACKAGE_MANAGER=VCPKG

# Force Conan
cmake -S . -B build/conan -DFORCE_PACKAGE_MANAGER=CONAN

# Force system packages
cmake -S . -B build/system -DFORCE_PACKAGE_MANAGER=SYSTEM
```

### Using Build Scripts

#### MSYS2 Build Script

```bash
# Automatic package checking and fallback
./scripts/build_msys2.sh --build-type Debug

# Install missing packages automatically
./scripts/build_msys2.sh --install-deps --build-type Debug

# Check packages without building
./scripts/build_msys2.sh --configure-only
```

#### Validation Script

```bash
# Test all package manager scenarios
./scripts/validate_package_managers.sh
```

## Configuration Options

### CMake Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PACKAGE_MANAGER_PRIORITY_ORDER` | Priority order list | `"MSYS2;VCPKG;CONAN"` |
| `FORCE_PACKAGE_MANAGER` | Force specific manager | `""` (auto-detect) |
| `USE_MSYS2` | Use MSYS2 packages | Auto-detected |
| `USE_VCPKG` | Use vcpkg packages | Auto-detected |
| `USE_CONAN` | Use Conan packages | Auto-detected |

### Environment Variables

| Variable | Description |
|----------|-------------|
| `MSYSTEM` | MSYS2 environment type (MINGW64, UCRT64, etc.) |
| `MSYSTEM_PREFIX` | MSYS2 installation prefix |
| `VCPKG_ROOT` | vcpkg installation directory |

## Troubleshooting

### MSYS2 Package Issues

If MSYS2 packages are missing:

```bash
# Check what's missing
./scripts/validate_package_managers.sh

# Install missing packages
pacman -S mingw-w64-x86_64-qt6-base mingw-w64-x86_64-qt6-svg mingw-w64-x86_64-qt6-tools

# Or use automatic installation
./scripts/build_msys2.sh --install-deps
```

### Fallback Not Working

If fallback to vcpkg/Conan isn't working:

```bash
# Check what package managers are detected
cmake -S . -B build/test -DCMAKE_BUILD_TYPE=Debug
# Look for "Package Manager Selection Summary" in output

# Force a specific package manager to test
cmake -S . -B build/test -DFORCE_PACKAGE_MANAGER=VCPKG
```

### Verbose Logging

Enable verbose output to see package manager selection:

```bash
cmake -S . -B build/verbose --log-level=STATUS
```

The output will show:

- Which package managers were detected
- Which one was selected and why
- Any fallback actions taken

## Advanced Usage

### Custom Priority Order

Create a custom preset with different priority:

```json
{
    "name": "Custom-Priority",
    "generator": "Ninja",
    "binaryDir": "${sourceDir}/build/Custom",
    "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Debug",
        "PACKAGE_MANAGER_PRIORITY_ORDER": "CONAN;VCPKG;MSYS2"
    }
}
```

### Integration with CI/CD

For CI/CD systems, you can:

```bash
# Ensure specific package manager is used
cmake -DFORCE_PACKAGE_MANAGER=VCPKG -S . -B build

# Or allow fallback but prefer specific order
cmake -DPACKAGE_MANAGER_PRIORITY_ORDER="VCPKG;SYSTEM" -S . -B build
```

## Benefits

1. **Automatic Environment Adaptation**: Works seamlessly across different development environments
2. **Fallback Resilience**: Continues working even when preferred package manager is unavailable
3. **Developer Choice**: Allows forcing specific package managers when needed
4. **CI/CD Friendly**: Predictable behavior in automated environments
5. **Cross-Platform**: Consistent behavior across Windows, Linux, and macOS
