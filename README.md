# qt-simple-template

A modern, production-ready Qt6 application template with multiple package manager support, comprehensive testing, and CI/CD integration.

## Features

✨ **Multiple Package Managers**: vcpkg, Conan, MSYS2, and system packages
🔧 **Modern Build System**: CMake 3.28+ with presets and cross-platform support
🧪 **Comprehensive Testing**: Unit tests, integration tests, and benchmarks
📚 **Documentation**: API docs with Doxygen, user guides, and developer documentation
🚀 **CI/CD Ready**: GitHub Actions workflows for all platforms and package managers
🎨 **Customizable Template**: Automated project generation with configurable options
🌍 **Cross-Platform**: Windows (MSVC/MinGW), Linux (GCC/Clang), macOS (Clang)
🔒 **Quality Assurance**: Static analysis, code formatting, and security scanning

## 🏗️ MVC Architecture

The application follows a comprehensive Model-View-Controller architecture pattern:

### Directory Structure

```
app/
├── include/
│   ├── interfaces/     # Abstract interfaces (IModel, IView, IController, IService)
│   ├── models/         # Data models (ApplicationModel, BaseModel)
│   ├── views/          # User interface (MainWindow, BaseView)
│   ├── controllers/    # Business logic (ApplicationController, BaseController)
│   ├── services/       # Application services (ConfigurationService)
│   └── utils/          # Utilities (Logger)
└── src/               # Implementation files
```

### Key Components

- **Models**: Thread-safe data management with property system
- **Views**: Qt-based UI components with automatic updates
- **Controllers**: Business logic and MVC coordination
- **Services**: Configuration, logging, and application services
- **Interfaces**: Abstract contracts for extensibility

See [MVC Architecture Guide](docs/architecture/mvc-architecture.md) for detailed information.

## Quick Start

### Prerequisites

- CMake 3.28 or later
- Qt 6.7.0 or later
- One of the supported package managers
- C++20 compatible compiler

### Package Manager Options

Choose the package manager that best fits your workflow:

#### 🔷 vcpkg (Default - Recommended for cross-platform)

```bash
# Install vcpkg
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg && ./bootstrap-vcpkg.sh  # Linux/macOS
cd vcpkg && .\bootstrap-vcpkg.bat  # Windows
export VCPKG_ROOT=/path/to/vcpkg

# Build
cmake --preset Debug-Unix     # Linux/macOS
cmake --preset Debug-Windows  # Windows
cmake --build build/Debug
```

#### 🔶 Conan (Professional dependency management)

```bash
# Install Conan
pip install conan
conan profile detect --force

# Build (automated script)
python scripts/build_conan.py --build-type Debug

# Or manual
conan install . --output-folder build/Conan-Debug --build missing
cmake --preset Conan-Debug-Unix
cmake --build build/Conan-Debug
```

#### 🔸 MSYS2 (Windows with Unix-like tools + Priority System)

```bash
# Install MSYS2 from https://www.msys2.org/
# The build system now automatically prioritizes MSYS2 packages when available

# Automated script with dependency installation
./scripts/build_msys2.sh --build-type Debug --install-deps

# From Windows Command Prompt
scripts\build_msys2.bat --build-type Debug

# Manual installation
pacman -S mingw-w64-x86_64-qt6-base mingw-w64-x86_64-qt6-svg mingw-w64-x86_64-qt6-tools
pacman -S mingw-w64-x86_64-cmake mingw-w64-x86_64-ninja

# Build with MSYS2-specific presets (recommended)
cmake --preset MSYS2-UCRT64-Release    # UCRT64 environment (recommended)
cmake --build --preset MSYS2-UCRT64-Release

# Alternative environments
cmake --preset MSYS2-MINGW64-Release   # MINGW64 environment
cmake --preset MSYS2-CLANG64-Release   # CLANG64 environment

# Hybrid mode with fallback
cmake --preset MSYS2-Hybrid-Release    # MSYS2 → vcpkg → Conan fallback

# Legacy method
cmake --preset Hybrid-Debug-MSYS2-First
cmake --build build/Hybrid-Debug
```

#### 🔹 System Packages (Linux distributions)

```bash
# Ubuntu/Debian
sudo apt install qt6-base-dev qt6-svg-dev qt6-tools-dev cmake ninja-build
cmake -S . -B build -G Ninja
cmake --build build

# Fedora/RHEL
sudo dnf install qt6-qtbase-devel qt6-qtsvg-devel cmake ninja-build

# Arch Linux
sudo pacman -S qt6-base qt6-svg qt6-tools cmake ninja
```

### Running the Application

```bash
# Linux/macOS
./build/Debug/app/qt_simple_template

# Windows
.\build\Debug\app\qt_simple_template.exe
```

## 📦 Comprehensive Multi-Platform Packaging

The project includes extensive packaging support for all major platforms and distribution channels:

### Linux Packages

- **DEB** (Debian/Ubuntu) - `cmake --build build --target package_deb`
- **RPM** (RedHat/SUSE/Fedora) - `cmake --build build --target package_rpm`
- **AppImage** (Universal) - `cmake --build build --target package_appimage`
- **Snap** (Universal) - `cmake --build build --target package_snap`
- **Flatpak** (Sandboxed) - `cmake --build build --target package_flatpak`
- **Arch** (Arch Linux) - `cmake --build build --target package_arch`

### Windows Packages

- **NSIS** (Traditional installer) - `cmake --build build --target package_nsis`
- **MSI** (Windows Installer) - `cmake --build build --target package_msi`
- **Chocolatey** (Package manager) - `cmake --build build --target package_chocolatey`
- **WinGet** (Microsoft package manager) - `cmake --build build --target package_winget`
- **Portable ZIP** - `cmake --build build --target package_portable_zip`

### macOS Packages

- **DMG** (Disk image) - `cmake --build build --target package_dmg`
- **PKG** (Installer package) - `cmake --build build --target package_pkg`
- **Homebrew** (Package manager) - `cmake --build build --target package_homebrew`
- **MacPorts** (Package manager) - `cmake --build build --target package_macports`

### Cross-Platform

- **Docker** (Container images) - `cmake --build build --target package_docker`
- **Conda** (Cross-platform) - `cmake --build build --target package_conda`
- **Qt Installer Framework** - `cmake --build build --target package_qtifw`

### Quick Packaging Commands

```bash
# Build all packages for current platform
cmake --build build --target package_platform

# Build all possible packages
cmake --build build --target package_all

# Validate available packaging tools
./scripts/validate_packaging.sh
```

See the [Comprehensive Packaging Guide](docs/user-guide/comprehensive-packaging.md) for detailed instructions.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
