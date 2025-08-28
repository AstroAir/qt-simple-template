# Installation Guide

This guide provides detailed instructions for installing applications built with qt-simple-template on different operating systems.

## System Requirements

### Minimum Requirements

- **CPU**: 1 GHz processor or faster
- **Memory**: 512 MB RAM
- **Storage**: 100 MB available disk space
- **Graphics**: DirectX 9 compatible graphics card (Windows) or equivalent

### Recommended Requirements

- **CPU**: 2 GHz dual-core processor or faster
- **Memory**: 1 GB RAM or more
- **Storage**: 500 MB available disk space
- **Graphics**: OpenGL 3.3 compatible graphics card

### Operating System Support

- **Windows**: Windows 10 (version 1903 or later), Windows 11
- **Linux**: Ubuntu 20.04 LTS or later, other distributions with equivalent libraries
- **macOS**: macOS 10.15 (Catalina) or later

## Windows Installation

### Using the Installer (Recommended)

1. **Download** the Windows installer (.exe) from the releases page
2. **Run** the installer as Administrator (right-click > "Run as administrator")
3. **Follow** the installation wizard:
   - Accept the license agreement
   - Choose installation directory (default: `C:\Program Files\qt-simple-template`)
   - Select components to install
   - Choose Start Menu folder
4. **Complete** the installation and launch the application

### Installation Options

- **Full Installation**: Includes all components and documentation
- **Minimal Installation**: Core application only
- **Custom Installation**: Choose specific components

### Silent Installation

For automated deployment:

```cmd
installer.exe /S /D=C:\MyApp
```

### Portable Installation

1. Download the portable ZIP package
2. Extract to desired location
3. Run the executable directly (no installation required)

## Linux Installation

### Using Package Managers

#### Ubuntu/Debian (APT)

```bash
# Add repository (if available)
sudo add-apt-repository ppa:your-org/qt-simple-template
sudo apt update

# Install application
sudo apt install qt-simple-template
```

#### Fedora/CentOS (DNF/YUM)

```bash
# Install from repository
sudo dnf install qt-simple-template
```

#### Arch Linux (Pacman)

```bash
# Install from AUR
yay -S qt-simple-template
```

### Using AppImage (Universal)

1. **Download** the AppImage file
2. **Make executable**:

   ```bash
   chmod +x qt-simple-template-*.AppImage
   ```

3. **Run** the application:

   ```bash
   ./qt-simple-template-*.AppImage
   ```

### Manual Installation

1. **Download** the Linux tarball (.tar.gz)
2. **Extract** the archive:

   ```bash
   tar -xzf qt-simple-template-*.tar.gz
   cd qt-simple-template
   ```

3. **Install** dependencies:

   ```bash
   sudo apt install qt6-base-dev qt6-svg-dev  # Ubuntu/Debian
   sudo dnf install qt6-qtbase-devel qt6-qtsvg-devel  # Fedora
   ```

4. **Run** the application:

   ```bash
   ./qt-simple-template
   ```

### Creating Desktop Entry

Create a desktop shortcut:

```bash
cat > ~/.local/share/applications/qt-simple-template.desktop << EOF
[Desktop Entry]
Name=Qt Simple Template
Comment=A modern Qt6 application
Exec=/path/to/qt-simple-template
Icon=/path/to/icon.png
Type=Application
Categories=Utility;
EOF
```

## macOS Installation

### Using DMG Installer (Recommended)

1. **Download** the macOS disk image (.dmg)
2. **Open** the DMG file by double-clicking
3. **Drag** the application to the Applications folder
4. **Eject** the disk image
5. **Launch** from Applications folder or Launchpad

### First Launch on macOS

macOS may show a security warning for unsigned applications:

1. **Control-click** the application icon
2. **Select** "Open" from the context menu
3. **Click** "Open" in the security dialog
4. The application will launch and be trusted for future use

### Using Homebrew

```bash
# Add tap (if available)
brew tap your-org/qt-simple-template

# Install application
brew install qt-simple-template
```

### Manual Installation

1. **Download** the macOS archive (.zip or .tar.gz)
2. **Extract** the archive
3. **Move** the .app bundle to Applications folder
4. **Launch** the application

## Verification

### Verify Installation

After installation, verify the application works correctly:

1. **Launch** the application
2. **Check** the About dialog for version information
3. **Test** basic functionality:
   - Theme switching
   - Language switching
   - Menu operations

### Command Line Verification

```bash
# Check version
qt-simple-template --version

# Run with debug output
qt-simple-template --debug
```

## Dependencies

### Runtime Dependencies

The application requires these libraries at runtime:

- Qt6 Core, Gui, Widgets, Svg
- C++ Runtime Library
- OpenGL drivers

### Automatic Dependency Installation

- **Windows**: Dependencies are bundled with the installer
- **Linux**: Package managers handle dependencies automatically
- **macOS**: Dependencies are included in the app bundle

### Manual Dependency Installation

#### Windows

Download and install Visual C++ Redistributable:

- [Microsoft Visual C++ Redistributable](https://docs.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist)

#### Linux

```bash
# Ubuntu/Debian
sudo apt install qt6-base-dev libqt6svg6

# Fedora
sudo dnf install qt6-qtbase qt6-qtsvg

# Arch Linux
sudo pacman -S qt6-base qt6-svg
```

#### macOS

Dependencies are typically bundled with the application.

## Troubleshooting Installation

### Common Issues

#### Windows

**Issue**: "Application failed to start because Qt6Core.dll was not found"
**Solution**: Install Visual C++ Redistributable or use the full installer

**Issue**: "Windows protected your PC" warning
**Solution**: Click "More info" then "Run anyway" (for trusted sources)

#### Linux

**Issue**: "error while loading shared libraries: libQt6Core.so.6"
**Solution**: Install Qt6 development packages or use AppImage

**Issue**: Application doesn't start from desktop
**Solution**: Check executable permissions and desktop entry path

#### macOS

**Issue**: "App is damaged and can't be opened"
**Solution**: Remove quarantine attribute:

```bash
xattr -d com.apple.quarantine /Applications/YourApp.app
```

**Issue**: "App can't be opened because it is from an unidentified developer"
**Solution**: Use Control-click to open or adjust security settings

### Getting Help

If you encounter installation issues:

1. Check the troubleshooting guide
2. Review system requirements
3. Consult the FAQ
4. Contact support with system details

## Uninstallation

### Windows

1. **Use** Control Panel > Programs and Features
2. **Select** the application and click "Uninstall"
3. **Follow** the uninstall wizard
4. **Remove** remaining configuration files from `%APPDATA%` if desired

### Linux

```bash
# Package manager installation
sudo apt remove qt-simple-template  # Ubuntu/Debian
sudo dnf remove qt-simple-template  # Fedora

# Manual installation
rm -rf /path/to/installation
rm ~/.config/qt-simple-template/
```

### macOS

1. **Move** the application to Trash from Applications folder
2. **Empty** Trash
3. **Remove** configuration files from `~/Library/Preferences/` if desired

## Upgrade Instructions

### Automatic Updates

If automatic updates are enabled:

1. Application will check for updates on startup
2. Download and install updates automatically
3. Restart application when prompted

### Manual Updates

1. **Download** the latest version
2. **Uninstall** the previous version (optional)
3. **Install** the new version following installation instructions
4. **Migrate** settings if necessary

### Preserving Settings

User settings are typically preserved during upgrades:

- **Windows**: `%APPDATA%\qt-simple-template\`
- **Linux**: `~/.config/qt-simple-template/`
- **macOS**: `~/Library/Preferences/qt-simple-template/`
