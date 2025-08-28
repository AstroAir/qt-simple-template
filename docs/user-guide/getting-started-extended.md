# Getting Started with qt-simple-template

This guide covers all the ways you can build and use qt-simple-template with different package managers and toolchains.

## Overview

qt-simple-template now supports multiple package managers and build configurations:

- **vcpkg**: Microsoft's cross-platform package manager (default)
- **Conan**: Professional C++ package manager with excellent versioning
- **MSYS2**: Unix-like environment for Windows with pacman package manager
- **System packages**: Native distribution packages for Linux

## Installation Methods

### Method 1: Template Usage (Recommended)

Use this repository as a GitHub template:

1. Click "Use this template" on GitHub
2. Create your new repository
3. Clone and customize:

```bash
git clone https://github.com/your-username/your-project.git
cd your-project

# Customize the template
python scripts/customize_template.py \
  --project-name "my_awesome_app" \
  --app-name "My Awesome App" \
  --package-manager "conan" \
  --compiler-toolchain "gcc"
```

### Method 2: Direct Clone

Clone and use directly:

```bash
git clone https://github.com/your-org/qt-simple-template.git
cd qt-simple-template
```

## Package Manager Setup

### vcpkg Setup

```bash
# Install vcpkg
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg

# Bootstrap (choose your platform)
./bootstrap-vcpkg.sh      # Linux/macOS
.\bootstrap-vcpkg.bat     # Windows

# Set environment variable
export VCPKG_ROOT=$(pwd)  # Linux/macOS/Git Bash
set VCPKG_ROOT=%CD%       # Windows Command Prompt
$env:VCPKG_ROOT = $PWD    # PowerShell

# Install dependencies (optional, done automatically by CMake)
./vcpkg install qt6-base qt6-svg
```

### Conan Setup

```bash
# Install Conan
pip install conan>=2.0

# Create default profile
conan profile detect --force

# Optional: Customize profile
conan profile show default
```

### MSYS2 Setup (Windows)

1. Download MSYS2 from <https://www.msys2.org/>
2. Install and open MSYS2 terminal
3. Update packages:

```bash
pacman -Syu
```

4. Install development tools:

```bash
pacman -S base-devel git cmake ninja
```

### System Packages Setup (Linux)

#### Ubuntu/Debian

```bash
sudo apt update
sudo apt install \
  qt6-base-dev \
  qt6-svg-dev \
  qt6-tools-dev \
  cmake \
  ninja-build \
  build-essential
```

#### Fedora/RHEL

```bash
sudo dnf install \
  qt6-qtbase-devel \
  qt6-qtsvg-devel \
  qt6-qttools-devel \
  cmake \
  ninja-build \
  gcc-c++
```

#### Arch Linux

```bash
sudo pacman -S \
  qt6-base \
  qt6-svg \
  qt6-tools \
  cmake \
  ninja \
  base-devel
```

## Building

### Using Build Scripts (Recommended)

#### vcpkg

```bash
# Use existing CMake presets
cmake --preset Debug-Unix     # Linux/macOS
cmake --preset Debug-Windows  # Windows
cmake --build build/Debug
```

#### Conan

```bash
# Automated build script
python scripts/build_conan.py --build-type Debug --test

# With specific options
python scripts/build_conan.py \
  --build-type Release \
  --preset Conan-Release-Unix \
  --clean
```

#### MSYS2

```bash
# Automated build script (in MSYS2 terminal)
./scripts/build_msys2.sh --build-type Debug --install-deps --test

# From Windows Command Prompt
scripts\build_msys2.bat --build-type Debug

# With specific MSYS2 environment
scripts\build_msys2.bat --msys2-env UCRT64 --build-type Release
```

#### System Packages

```bash
# Simple build
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug
cmake --build build

# With testing
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON
cmake --build build
ctest --test-dir build
```

### Manual Building

#### vcpkg Manual

```bash
# Configure
cmake -S . -B build \
  -DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake \
  -DCMAKE_BUILD_TYPE=Debug

# Build
cmake --build build

# Test
ctest --test-dir build
```

#### Conan Manual

```bash
# Install dependencies
conan install . --output-folder build --build missing --settings build_type=Debug

# Configure
cmake -S . -B build \
  -DCMAKE_TOOLCHAIN_FILE=build/conan_toolchain.cmake \
  -DCMAKE_BUILD_TYPE=Debug

# Build
cmake --build build
```

#### MSYS2 Manual

```bash
# Install Qt (choose your environment)
pacman -S mingw-w64-x86_64-qt6-base mingw-w64-x86_64-qt6-svg  # MINGW64
pacman -S mingw-w64-ucrt-x86_64-qt6-base mingw-w64-ucrt-x86_64-qt6-svg  # UCRT64

# Configure and build
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug
cmake --build build
```

## Testing

### Running Tests

```bash
# All package managers
ctest --test-dir build --output-on-failure

# With parallel execution
ctest --test-dir build --parallel 4

# Specific test pattern
ctest --test-dir build -R "unit_test_*"

# With GUI tests (Linux)
QT_QPA_PLATFORM=offscreen ctest --test-dir build
```

### Test Categories

- **Unit Tests**: Fast, isolated component tests
- **Integration Tests**: Component interaction tests
- **Benchmark Tests**: Performance measurements
- **GUI Tests**: User interface tests (headless)

## IDE Integration

### Visual Studio Code

1. Install CMake Tools extension
2. Open project folder
3. Select CMake preset:
   - `Ctrl+Shift+P` → "CMake: Select Configure Preset"
   - Choose your preferred preset (vcpkg/Conan/MSYS2)

### Visual Studio (Windows)

1. Open folder in Visual Studio
2. CMake presets will be automatically detected
3. Select configuration from dropdown

### Qt Creator

1. Open CMakeLists.txt
2. Configure with your preferred kit
3. Qt Creator will use system Qt or detect vcpkg/Conan

### CLion

1. Open project
2. CLion will detect CMake configuration
3. Select toolchain in Settings → Build → Toolchains

## Troubleshooting

### Common Issues

#### vcpkg

- **Qt not found**: Ensure `VCPKG_ROOT` is set and vcpkg is bootstrapped
- **Triplet issues**: Check vcpkg triplet matches your platform
- **Build failures**: Update vcpkg with `git pull`

#### Conan

- **Profile not found**: Run `conan profile detect --force`
- **Package conflicts**: Use `--build missing` to rebuild packages
- **Version issues**: Check conanfile.py for version constraints

#### MSYS2

- **Package not found**: Update package database with `pacman -Sy`
- **Qt modules missing**: Install specific Qt packages for your environment
- **Path issues**: Ensure you're in the correct MSYS2 environment

#### System Packages

- **Qt version too old**: Use package manager to install newer Qt6
- **Missing development packages**: Install `-dev` or `-devel` packages
- **CMake too old**: Install newer CMake from official sources

### Performance Tips

1. **Use Ninja generator** for faster builds: `-G Ninja`
2. **Enable parallel builds**: `cmake --build build --parallel`
3. **Use package caching** in CI/CD environments
4. **Precompiled headers** for large projects
5. **ccache/sccache** for compiler caching

### Getting Help

1. Check the [documentation](docs/)
2. Review [GitHub Issues](https://github.com/your-org/qt-simple-template/issues)
3. Consult package manager documentation:
   - [vcpkg docs](https://vcpkg.io/)
   - [Conan docs](https://docs.conan.io/)
   - [MSYS2 docs](https://www.msys2.org/)
4. Qt6 documentation: <https://doc.qt.io/qt-6/>

## Next Steps

After successful build:

1. **Customize the template** for your project needs
2. **Set up CI/CD** using provided GitHub Actions workflows
3. **Add your application logic** in `app/` directory
4. **Create custom controls** in `controls/` directory
5. **Write tests** in `tests/` directory
6. **Update documentation** in `docs/` directory

Happy coding! 🚀
