# qt-simple-template

A modern, production-ready Qt6 application template with multiple package manager support, comprehensive testing, and CI/CD integration.

## Features

✨ **System Packages First**: Uses system-installed packages by default with optional package manager support
🔧 **Modern Build System**: CMake 3.28+ with presets and cross-platform support
📦 **Flexible Package Management**: Optional vcpkg, Conan, or MSYS2 integration
🧪 **Comprehensive Testing**: Unit tests, integration tests, and benchmarks
📚 **Documentation**: API docs with Doxygen, user guides, and developer documentation
🚀 **CI/CD Ready**: GitHub Actions workflows for all platforms and package managers
🎨 **Customizable Template**: Automated project generation with configurable options
🌍 **Cross-Platform**: Windows (MSVC/MinGW), Linux (GCC/Clang), macOS (Clang)
🔒 **Quality Assurance**: Static analysis, code formatting, and security scanning

## 🏗️ MVC Architecture

The application follows a comprehensive Model-View-Controller architecture pattern:

### Directory Structure

```txt
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

### Build Options

The build system uses **system packages by default** and provides optional package manager integration:

#### 🏠 System Packages (Default - Recommended)

Uses packages installed through your system's package manager (apt, brew, pacman, etc.):

```bash
# Install Qt6 through your system package manager first:

# Ubuntu/Debian
sudo apt install qt6-base-dev qt6-tools-dev qt6-svg-dev

# macOS (Homebrew)
brew install qt6

# Arch Linux
sudo pacman -S qt6-base qt6-tools qt6-svg

# Windows (MSYS2)
pacman -S mingw-w64-x86_64-qt6-base mingw-w64-x86_64-qt6-tools mingw-w64-x86_64-qt6-svg

# Build with system packages (default behavior)
mkdir build && cd build
cmake ..
cmake --build .
```

#### 🔷 vcpkg (Optional - Cross-platform package management)

```bash
# Install vcpkg
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg && ./bootstrap-vcpkg.sh  # Linux/macOS
cd vcpkg && .\bootstrap-vcpkg.bat  # Windows
export VCPKG_ROOT=/path/to/vcpkg

# Build with vcpkg
cmake --preset Debug-Unix -DUSE_VCPKG=ON     # Linux/macOS
cmake --preset Debug-Windows -DUSE_VCPKG=ON  # Windows
cmake --build build/Debug
```

#### 🔶 Conan (Optional - Professional dependency management)

```bash
# Install Conan
pip install conan
conan profile detect --force

# Build with Conan (automated script)
python scripts/build_conan.py --build-type Debug

# Or manual with Conan
conan install . --output-folder build/Conan-Debug --build missing
cmake --preset Conan-Debug-Unix -DUSE_CONAN=ON
cmake --build build/Conan-Debug
```

#### 🔧 Force Specific Package Manager

```bash
# Force system packages (explicit)
cmake -DFORCE_PACKAGE_MANAGER=SYSTEM ..

# Force vcpkg
cmake -DFORCE_PACKAGE_MANAGER=VCPKG ..

# Force Conan
cmake -DFORCE_PACKAGE_MANAGER=CONAN ..

# Force MSYS2 (Windows only)
cmake -DFORCE_PACKAGE_MANAGER=MSYS2 ..
```

### Running the Application

```bash
# Linux/macOS
./build/app/qt_simple_template

# Windows
.\build\app\qt_simple_template.exe
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
