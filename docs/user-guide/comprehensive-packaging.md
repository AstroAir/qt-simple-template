# Comprehensive Multi-Platform Packaging Guide

The qt-simple-template project supports an extensive range of packaging formats across all major platforms. This guide covers all available packaging options and how to use them.

## Overview

The packaging system supports:

### Linux Packages

- **DEB** (Debian/Ubuntu) - Native package format
- **RPM** (RedHat/SUSE/Fedora) - Native package format  
- **AppImage** - Portable application format
- **Snap** - Universal Linux package format
- **Flatpak** - Sandboxed application format
- **Arch** - Arch Linux package format

### Windows Packages

- **NSIS** - Traditional Windows installer
- **MSI** - Windows Installer format
- **Chocolatey** - Windows package manager
- **WinGet** - Microsoft package manager
- **Portable ZIP** - Portable archive format

### macOS Packages

- **DMG** - macOS disk image
- **PKG** - macOS installer package
- **Homebrew** - macOS package manager
- **MacPorts** - macOS package manager

### Cross-Platform

- **Docker** - Container images
- **Conda** - Cross-platform package manager
- **Qt Installer Framework** - Cross-platform installer

## Quick Start

### Build All Platform Packages

```bash
# Build all packages for current platform
cmake --build build --target package_platform

# Build all possible packages
cmake --build build --target package_all
```

### Platform-Specific Quick Commands

#### Linux

```bash
# Debian/Ubuntu
cmake --build build --target package_deb

# RedHat/Fedora/SUSE
cmake --build build --target package_rpm

# AppImage
cmake --build build --target package_appimage

# Snap
cmake --build build --target package_snap

# Flatpak
cmake --build build --target package_flatpak

# Arch Linux
cmake --build build --target package_arch
```

#### Windows

```bash
# NSIS installer
cmake --build build --target package_nsis

# MSI installer
cmake --build build --target package_msi

# Chocolatey package
cmake --build build --target package_chocolatey

# WinGet manifest
cmake --build build --target package_winget

# Portable ZIP
cmake --build build --target package_portable_zip
```

#### macOS

```bash
# DMG image
cmake --build build --target package_dmg

# PKG installer
cmake --build build --target package_pkg

# Homebrew formula
cmake --build build --target package_homebrew

# MacPorts portfile
cmake --build build --target package_macports
```

#### Cross-Platform

```bash
# Docker image
cmake --build build --target package_docker

# Multi-architecture Docker
cmake --build build --target package_docker_multiarch

# Conda package
cmake --build build --target package_conda
```

## Detailed Package Formats

### Linux Distribution Packages

#### DEB Packages (Debian/Ubuntu)

```bash
# Prerequisites
sudo apt install build-essential cmake ninja-build qt6-base-dev

# Build DEB package
cmake --build build --target package_deb

# Install generated package
sudo dpkg -i build/qt-simple-template_*.deb
```

**Features:**

- Automatic dependency resolution
- Integration with APT package manager
- Desktop file and icon installation
- Post-install/pre-remove scripts

#### RPM Packages (RedHat/Fedora/SUSE)

```bash
# Prerequisites (Fedora)
sudo dnf install gcc-c++ cmake ninja-build qt6-qtbase-devel

# Build RPM package
cmake --build build --target package_rpm

# Install generated package
sudo rpm -i build/qt-simple-template-*.rpm
```

**Features:**

- Automatic dependency resolution
- Integration with YUM/DNF/Zypper
- Desktop file and icon installation
- Post-install/pre-uninstall scripts

### Universal Linux Packages

#### AppImage

```bash
# Prerequisites
wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
wget https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage
chmod +x linuxdeploy*.AppImage

# Build AppImage
cmake --build build --target package_appimage

# Run AppImage
./build/qt-simple-template-*.AppImage
```

**Features:**

- Portable - runs on any Linux distribution
- No installation required
- Includes all dependencies
- Desktop integration

#### Snap Packages

```bash
# Prerequisites
sudo snap install snapcraft --classic

# Build Snap package
cmake --build build --target package_snap

# Install locally
sudo snap install build/snap/qt-simple-template_*.snap --dangerous
```

**Features:**

- Universal Linux package format
- Automatic updates
- Sandboxed execution
- Store distribution

#### Flatpak Packages

```bash
# Prerequisites
sudo apt install flatpak flatpak-builder
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.kde.Platform//6.6 org.kde.Sdk//6.6

# Build Flatpak
cmake --build build --target package_flatpak

# Install locally
flatpak install --user build/flatpak-repo com.example.QtSimpleTemplate
```

**Features:**

- Sandboxed execution
- Runtime isolation
- Store distribution
- Automatic dependency management

### Windows Packages

#### MSI Installers

```bash
# Prerequisites: Install WiX Toolset v3.11+

# Build MSI installer
cmake --build build --target package_msi

# Install silently
msiexec /i build/qt-simple-template-*.msi /quiet
```

**Features:**

- Windows Installer technology
- Group Policy deployment
- Repair and rollback capabilities
- Add/Remove Programs integration

#### Chocolatey Packages

```bash
# Build Chocolatey package
cmake --build build --target package_chocolatey

# Test locally
choco install build/chocolatey/qt-simple-template.nupkg -source .
```

**Features:**

- Windows package manager
- Dependency management
- Automatic updates
- Command-line installation

#### WinGet Packages

```bash
# Generate WinGet manifest
cmake --build build --target package_winget

# Submit to winget-pkgs repository
# Copy build/winget/ contents to winget-pkgs PR
```

**Features:**

- Microsoft's official package manager
- Built into Windows 10/11
- Automatic updates
- Store integration

### macOS Packages

#### PKG Installers

```bash
# Build PKG installer
cmake --build build --target package_pkg

# Install
sudo installer -pkg build/qt-simple-template-*.pkg -target /
```

**Features:**

- Native macOS installer format
- System integration
- Uninstaller support
- Distribution signing

#### Code Signing and Notarization

```bash
# Set environment variables
export APPLE_DEVELOPER_ID="Developer ID Application: Your Name"
export APPLE_NOTARIZATION_USERNAME="your-apple-id@example.com"
export APPLE_NOTARIZATION_PASSWORD="app-specific-password"
export APPLE_TEAM_ID="YOUR_TEAM_ID"

# Build signed and notarized DMG
cmake --build build --target package_notarized_dmg
```

### Container Packages

#### Docker Images

```bash
# Build Docker image
cmake --build build --target package_docker

# Run container
docker run -it --rm qt-simple-template:latest

# Build multi-architecture images
cmake --build build --target package_docker_multiarch
```

**Features:**

- Consistent runtime environment
- Easy deployment
- Multi-architecture support
- Container orchestration ready

### Package Manager Integration

#### Homebrew (macOS)

```bash
# Generate Homebrew formula
cmake --build build --target package_homebrew

# Test formula
brew install --build-from-source build/homebrew/qt-simple-template.rb
```

#### Conda (Cross-platform)

```bash
# Build Conda package
cmake --build build --target package_conda

# Install from local build
conda install --use-local qt-simple-template
```

## Advanced Configuration

### Custom Package Metadata

Edit the following files to customize package information:

- `packaging/*/` - Platform-specific configurations
- `CMakeLists.txt` - Project metadata
- `cmake/PackagingConfig.cmake` - Packaging logic

### Architecture Support

The packaging system automatically detects and supports:

- **x86_64** (Intel/AMD 64-bit)
- **ARM64** (Apple Silicon, ARM64)
- **ARMv7** (32-bit ARM)

### Signing and Security

#### Windows Code Signing

```bash
# Set certificate information
set WINDOWS_CERTIFICATE_PATH=path/to/certificate.p12
set WINDOWS_CERTIFICATE_PASSWORD=password

# Build signed packages
cmake --build build --target package_msi
```

#### macOS Code Signing

```bash
# Set Apple Developer credentials
export APPLE_DEVELOPER_ID="Developer ID Application: Your Name"

# Build signed packages
cmake --build build --target package_signed_dmg
```

## CI/CD Integration

### GitHub Actions Example

```yaml
- name: Build Linux packages
  run: |
    cmake --build build --target package_deb
    cmake --build build --target package_appimage
    cmake --build build --target package_snap

- name: Upload packages
  uses: actions/upload-artifact@v3
  with:
    name: linux-packages
    path: |
      build/*.deb
      build/*.AppImage
      build/snap/*.snap
```

### GitLab CI Example

```yaml
package:linux:
  script:
    - cmake --build build --target package_platform
  artifacts:
    paths:
      - build/*.deb
      - build/*.rpm
      - build/*.AppImage
```

## Troubleshooting

### Common Issues

#### Missing Dependencies

```bash
# Check what tools are available
cmake --build build --target package_all 2>&1 | grep "Found\|not found"
```

#### Permission Issues

```bash
# Linux: Ensure proper permissions for packaging tools
sudo chown -R $USER:$USER build/

# macOS: Check keychain access for signing
security find-identity -v -p codesigning
```

#### Package Validation

```bash
# Validate DEB package
dpkg-deb --info build/*.deb

# Validate RPM package
rpm -qip build/*.rpm

# Validate AppImage
./build/*.AppImage --appimage-help
```

For more specific troubleshooting, see the [Package Manager Troubleshooting Guide](../troubleshooting/package-manager-issues.md).
