# Developer Guide

Welcome to the qt-simple-template developer guide. This documentation is for developers who want to contribute to, modify, or build upon this template.

## Quick Navigation

- [Building](building.md) - Build instructions and requirements
- [Architecture](architecture.md) - Project structure and design
- [Contributing](contributing.md) - How to contribute to the project
- [Coding Standards](coding-standards.md) - Code style and conventions
- [Testing](testing.md) - Testing guidelines and procedures

## Overview

qt-simple-template is a modern Qt6 application template designed to provide:

- **Best Practices** - Modern C++ and Qt development patterns
- **Cross-Platform** - Support for Windows, Linux, and macOS
- **CI/CD Ready** - Automated testing and deployment
- **Template System** - Easy customization for new projects

## Development Environment

### Prerequisites

- **Qt6** (6.2 or later) with Core, Gui, Widgets, Svg, LinguistTools
- **CMake** (3.28 or later)
- **vcpkg** for dependency management
- **C++20** compatible compiler:
  - Visual Studio 2019/2022 (Windows)
  - GCC 10+ or Clang 12+ (Linux)
  - Xcode 12+ (macOS)

### Recommended Tools

- **IDE**: Qt Creator, Visual Studio, CLion, or VS Code
- **Version Control**: Git
- **Language Server**: clangd (for enhanced IDE support)
- **Code Quality**: pre-commit (automated code quality checks)
- **Static Analysis**: clang-tidy, cppcheck
- **Documentation**: Doxygen
- **Testing**: Qt Test framework

## Project Structure

```text
qt-simple-template/
├── CMakeLists.txt              # Main CMake configuration
├── CMakePresets.json           # CMake presets for different platforms
├── vcpkg.json                  # Dependency configuration
├── vcpkg-configuration.json    # vcpkg registry configuration
├── .clang-format              # Code formatting rules
├── .clangd                    # clangd language server configuration
├── .pre-commit-config.yaml    # Pre-commit hooks configuration
├── .gitignore                 # Git ignore patterns
├── LICENSE                    # Project license
├── README.md                  # Project overview
├── app/                       # Main application
│   ├── CMakeLists.txt
│   ├── main.cpp
│   ├── Widget.h/.cpp/.ui
│   ├── config.h.in
│   ├── app.qrc
│   └── i18n/                  # Internationalization files
├── controls/                  # Custom UI controls library
│   ├── CMakeLists.txt
│   └── Slider.h/.cpp
├── assets/                    # Application assets
│   ├── images/
│   └── styles/
├── tests/                     # Test suite
│   ├── unit/
│   ├── integration/
│   └── benchmarks/
├── docs/                      # Documentation
│   ├── api/
│   ├── user-guide/
│   ├── developer-guide/
│   └── template-guide/
├── scripts/                   # Build and utility scripts
├── distrib/                   # Distribution and packaging
└── .github/                   # CI/CD workflows (to be added)
```

## Core Components

### Application Layer (`app/`)

- **main.cpp** - Application entry point
- **Widget** - Main application window
- **config.h.in** - Configuration template
- **Resources** - Images, styles, translations

### Controls Library (`controls/`)

- **Slider** - Custom slider control
- Extensible for additional custom controls

### Build System

- **CMake** - Modern CMake with presets
- **vcpkg** - Dependency management
- **Qt6** - Framework integration

### Testing Framework

- **Qt Test** - Unit and integration testing
- **CTest** - Test execution and reporting
- **Benchmarks** - Performance testing

## Development Workflow

### 1. Setup Development Environment

```bash
# Clone repository
git clone https://github.com/your-org/qt-simple-template.git
cd qt-simple-template

# Install dependencies via vcpkg
vcpkg install

# Configure build
cmake --preset Debug-Windows  # or Debug-Unix

# Build
cmake --build build/Debug
```

### 2. Make Changes

- Follow coding standards
- Add tests for new functionality
- Update documentation
- Ensure cross-platform compatibility

### 3. Test Changes

```bash
# Run all tests
ctest --test-dir build/Debug

# Run specific test types
python scripts/run_tests.py --type unit
```

### 4. Submit Changes

- Create feature branch
- Make atomic commits
- Write descriptive commit messages
- Submit pull request

## Architecture Principles

### Design Patterns

- **MVC/MVP** - Separation of concerns
- **Observer** - Signal/slot mechanism
- **Factory** - Object creation patterns
- **RAII** - Resource management

### Code Organization

- **Modular Design** - Separate libraries for different concerns
- **Interface Segregation** - Small, focused interfaces
- **Dependency Injection** - Loose coupling between components
- **Single Responsibility** - Each class has one clear purpose

### Qt Best Practices

- **Signals and Slots** - Event-driven programming
- **Object Trees** - Automatic memory management
- **Meta-Object System** - Runtime type information
- **Resource System** - Embedded resources

## Build System Details

### CMake Configuration

- **Modern CMake** (3.28+) with targets and properties
- **Cross-Platform** - Windows, Linux, macOS support
- **Presets** - Predefined configurations
- **Testing Integration** - CTest support

### Dependency Management

- **vcpkg** - C++ package manager
- **Qt6** - Framework components
- **Automatic** - Dependencies resolved automatically

### Packaging

- **Windows** - NSIS installer
- **Linux** - AppImage, DEB, RPM
- **macOS** - DMG with app bundle

## Testing Strategy

### Test Types

- **Unit Tests** - Individual component testing
- **Integration Tests** - Component interaction testing
- **Benchmarks** - Performance measurement
- **GUI Tests** - User interface testing

### Test Framework

- **Qt Test** - Native Qt testing framework
- **CTest** - CMake test runner
- **Continuous Integration** - Automated testing

### Coverage

- **Code Coverage** - Line and branch coverage
- **Test Coverage** - Feature coverage
- **Platform Coverage** - Multi-platform testing

## Documentation

### Code Documentation

- **Doxygen** - API documentation generation
- **Comments** - Inline code documentation
- **Examples** - Usage examples in documentation

### User Documentation

- **User Guide** - End-user documentation
- **Installation** - Setup instructions
- **Troubleshooting** - Common issues and solutions

### Developer Documentation

- **Architecture** - System design documentation
- **Contributing** - Contribution guidelines
- **Coding Standards** - Style and conventions

## Continuous Integration

### Automated Workflows

- **Build** - Multi-platform builds
- **Test** - Automated test execution
- **Quality** - Code quality checks
- **Package** - Automated packaging
- **Deploy** - Release automation

### Quality Gates

- **Compilation** - Must compile without errors
- **Tests** - All tests must pass
- **Coverage** - Minimum coverage requirements
- **Style** - Code formatting compliance
- **Analysis** - Static analysis checks

## Release Process

### Version Management

- **Semantic Versioning** - MAJOR.MINOR.PATCH
- **Git Tags** - Version tagging
- **Changelog** - Release notes

### Release Steps

1. **Prepare** - Update version, changelog
2. **Test** - Comprehensive testing
3. **Build** - Release builds
4. **Package** - Create installers
5. **Deploy** - Publish release
6. **Announce** - Release announcement

## Contributing

### Getting Started

1. Read the contributing guidelines
2. Set up development environment
3. Find an issue to work on
4. Make your changes
5. Submit a pull request

### Code Review Process

- **Automated Checks** - CI/CD validation
- **Peer Review** - Code review by maintainers
- **Testing** - Verify functionality
- **Documentation** - Update documentation
- **Merge** - Integration into main branch

## Development Environment Setup

### clangd Language Server

The project includes a `.clangd` configuration file optimized for Qt6 development. clangd provides enhanced IDE features like code completion, diagnostics, and navigation.

#### Installation

**Windows:**
```bash
# Using MSYS2
pacman -S mingw-w64-x86_64-clang-tools-extra

# Or download from LLVM releases
# https://github.com/llvm/llvm-project/releases
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get install clangd-15
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-15 100
```

**macOS:**
```bash
brew install llvm
```

#### IDE Configuration

**VS Code:**
1. Install the "clangd" extension
2. Disable the Microsoft C/C++ extension for this workspace
3. The `.clangd` file will be automatically detected

**Qt Creator:**
1. Go to Tools → Options → C++ → Code Model
2. Set "Code model backend" to "Clangd"
3. Restart Qt Creator

**CLion:**
1. Go to File → Settings → Languages & Frameworks → C/C++ → Clangd
2. Enable "Use clangd as language engine"
3. The configuration will be automatically detected

#### Compilation Database

The project automatically generates `compile_commands.json` when you configure with CMake. This file contains compilation information that clangd uses to understand your code.

```bash
# The compilation database is generated automatically when you build
cmake --preset Debug-Windows  # or your preferred preset
```

### Pre-commit Hooks

The project uses pre-commit hooks for automated code quality checks. These hooks run automatically before each commit to ensure code quality and consistency.

#### Installation

**Install pre-commit:**
```bash
# Using pip
pip install pre-commit

# Using conda
conda install -c conda-forge pre-commit

# Using homebrew (macOS)
brew install pre-commit
```

#### Setup

1. **Install the hooks:**
   ```bash
   pre-commit install
   ```

2. **Run hooks manually (optional):**
   ```bash
   # Run on all files
   pre-commit run --all-files

   # Run on staged files only
   pre-commit run
   ```

#### Configured Hooks

The project includes the following pre-commit hooks:

- **clang-format** - C++ code formatting using the project's `.clang-format` configuration
- **clang-tidy** - Static analysis with Qt-specific checks
- **cppcheck** - Additional static analysis
- **cmake-format** - CMake file formatting
- **yamllint** - YAML file linting
- **General hooks** - Trailing whitespace, end-of-file fixes, JSON/YAML validation

#### Troubleshooting

**Hook failures:**
- Most formatting issues are automatically fixed by the hooks
- For clang-tidy issues, review the suggestions and fix manually
- Use `git commit --no-verify` to bypass hooks temporarily (not recommended)

**Performance:**
- First run may be slow as tools are downloaded and compilation database is generated
- Subsequent runs are much faster due to caching

### Community

- **Issues** - Bug reports and feature requests
- **Discussions** - Design discussions
- **Pull Requests** - Code contributions
- **Documentation** - Documentation improvements
