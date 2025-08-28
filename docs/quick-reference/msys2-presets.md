# MSYS2 Presets Quick Reference

## Quick Commands

### UCRT64 (Recommended)
```bash
# Debug
cmake --preset MSYS2-UCRT64-Debug
cmake --build --preset MSYS2-UCRT64-Debug
ctest --preset MSYS2-UCRT64-Debug

# Release
cmake --preset MSYS2-UCRT64-Release
cmake --build --preset MSYS2-UCRT64-Release
ctest --preset MSYS2-UCRT64-Release
```

### MINGW64 (Legacy)
```bash
# Debug
cmake --preset MSYS2-MINGW64-Debug
cmake --build --preset MSYS2-MINGW64-Debug

# Release
cmake --preset MSYS2-MINGW64-Release
cmake --build --preset MSYS2-MINGW64-Release
```

### CLANG64 (Advanced)
```bash
# Debug
cmake --preset MSYS2-CLANG64-Debug
cmake --build --preset MSYS2-CLANG64-Debug

# Release
cmake --preset MSYS2-CLANG64-Release
cmake --build --preset MSYS2-CLANG64-Release
```

### Hybrid Mode (Fallback)
```bash
# Debug
cmake --preset MSYS2-Hybrid-Debug
cmake --build --preset MSYS2-Hybrid-Debug

# Release
cmake --preset MSYS2-Hybrid-Release
cmake --build --preset MSYS2-Hybrid-Release
```

## Environment Setup

### UCRT64 (Recommended)
```bash
# Install dependencies
pacman -S mingw-w64-ucrt-x86_64-toolchain
pacman -S mingw-w64-ucrt-x86_64-cmake
pacman -S mingw-w64-ucrt-x86_64-ninja
pacman -S mingw-w64-ucrt-x86_64-qt6-base
pacman -S mingw-w64-ucrt-x86_64-qt6-svg
```

### MINGW64
```bash
# Install dependencies
pacman -S mingw-w64-x86_64-toolchain
pacman -S mingw-w64-x86_64-cmake
pacman -S mingw-w64-x86_64-ninja
pacman -S mingw-w64-x86_64-qt6-base
pacman -S mingw-w64-x86_64-qt6-svg
```

### CLANG64
```bash
# Install dependencies
pacman -S mingw-w64-clang-x86_64-toolchain
pacman -S mingw-w64-clang-x86_64-cmake
pacman -S mingw-w64-clang-x86_64-ninja
pacman -S mingw-w64-clang-x86_64-qt6-base
pacman -S mingw-w64-clang-x86_64-qt6-svg
```

## Packaging Commands

```bash
# NSIS Installer
cmake --build build/MSYS2-UCRT64-Release --target package_nsis_msys2

# Portable ZIP
cmake --build build/MSYS2-UCRT64-Release --target package_msys2_portable

# All packages
cmake --build build/MSYS2-UCRT64-Release --target package_all
```

## Environment Detection

```bash
# Check current environment
echo $MSYSTEM

# Expected outputs:
# MINGW64  - Traditional MinGW
# UCRT64   - Modern UCRT (recommended)
# CLANG64  - LLVM/Clang toolchain
```

## Preset Features

| Preset | Environment | Package Manager | Use Case |
|--------|-------------|-----------------|----------|
| `MSYS2-MINGW64-*` | MINGW64 | MSYS2 only | Legacy compatibility |
| `MSYS2-UCRT64-*` | UCRT64 | MSYS2 only | **Recommended** |
| `MSYS2-CLANG64-*` | CLANG64 | MSYS2 only | Advanced features |
| `MSYS2-Hybrid-*` | Any | MSYS2→vcpkg→Conan | Maximum compatibility |

## Troubleshooting

### Check Environment
```bash
# Verify environment
echo $MSYSTEM
which cmake
which ninja
which gcc  # or clang for CLANG64
```

### Common Fixes
```bash
# Update MSYS2
pacman -Syu

# Reinstall toolchain
pacman -S mingw-w64-ucrt-x86_64-toolchain

# Clear CMake cache
rm -rf build/
```

## IDE Integration

### VS Code
```json
{
    "cmake.configurePreset": "MSYS2-UCRT64-Debug"
}
```

### CLion
- Toolchain: MSYS2 UCRT64
- CMake preset: `MSYS2-UCRT64-Debug`

## Performance Tips

1. **Use UCRT64**: Best performance and compatibility
2. **Ninja builds**: Faster than Make (already configured)
3. **Parallel jobs**: 8 jobs configured by default
4. **Hybrid mode**: Use for package compatibility

## One-Line Setup

```bash
# Complete setup for UCRT64
pacman -S mingw-w64-ucrt-x86_64-{toolchain,cmake,ninja,qt6-base,qt6-svg} && cmake --preset MSYS2-UCRT64-Release && cmake --build --preset MSYS2-UCRT64-Release
```
