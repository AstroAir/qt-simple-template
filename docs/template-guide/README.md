# Template Guide

This guide explains how to use qt-simple-template as a starting point for your own Qt6 projects.

## Quick Navigation

- [Customization](customization.md) - How to customize the template for your project
- [Examples](examples.md) - Example configurations and use cases
- [Best Practices](best-practices.md) - Recommended practices when using this template

## Overview

qt-simple-template is designed to be a comprehensive starting point for Qt6 applications. It provides:

### Template Features

- **Modern Qt6** - Latest Qt framework with best practices
- **Cross-Platform** - Windows, Linux, macOS support
- **Build System** - CMake with vcpkg dependency management
- **Testing** - Comprehensive test suite with Qt Test
- **CI/CD** - GitHub Actions workflows
- **Packaging** - Multi-platform packaging solutions
- **Documentation** - Complete documentation structure
- **Internationalization** - Multi-language support

### What's Included

- Application framework with main window
- Custom controls library
- Theme system (light/dark)
- Language switching
- Resource management
- Configuration system
- Testing infrastructure
- Build and packaging scripts
- Documentation templates

## Using the Template

### Method 1: GitHub Template (Recommended)

1. **Click** "Use this template" on the GitHub repository
2. **Create** a new repository from the template
3. **Clone** your new repository
4. **Customize** the template for your project

### Method 2: Fork and Modify

1. **Fork** the repository
2. **Clone** your fork
3. **Remove** template-specific content
4. **Customize** for your project

### Method 3: Download and Start Fresh

1. **Download** the repository as ZIP
2. **Extract** to your project directory
3. **Initialize** new Git repository
4. **Customize** the template

## Initial Customization

### 1. Project Information

Update these files with your project details:

**CMakeLists.txt**

```cmake
project(your_project_name LANGUAGES CXX VERSION 1.0.0.0)
```

**vcpkg.json**

```json
{
  "name": "your-project-name",
  "version": "1.0.0",
  "description": "Your project description",
  "homepage": "https://github.com/your-org/your-project",
  "license": "MIT"
}
```

**app/config.h.in**

```cpp
#define PROJECT_NAME "@PROJECT_NAME@"
#define APP_NAME "Your Application Name"
#define PROJECT_VER "@PROJECT_VERSION@"
```

### 2. Branding and Assets

Replace template assets with your own:

- **Logo/Icons**: Replace files in `assets/images/`
- **Themes**: Customize stylesheets in `assets/styles/`
- **Resources**: Update `app/app.qrc` with your resources

### 3. Application Structure

Modify the application structure:

- **Main Window**: Customize `app/Widget.h/.cpp/.ui`
- **Controls**: Add custom controls to `controls/`
- **Features**: Implement your application logic

### 4. Documentation

Update documentation for your project:

- **README.md**: Project overview and instructions
- **docs/**: Customize documentation structure
- **LICENSE**: Choose appropriate license

## Template Variables

The template uses several placeholder variables that should be replaced:

### Project Variables

- `{{PROJECT_NAME}}` - Technical project name
- `{{APP_NAME}}` - User-friendly application name
- `{{DESCRIPTION}}` - Project description
- `{{AUTHOR}}` - Author/organization name
- `{{EMAIL}}` - Contact email
- `{{WEBSITE}}` - Project website
- `{{YEAR}}` - Copyright year

### Build Variables

- `{{VERSION}}` - Project version
- `{{QT_VERSION}}` - Qt version requirement
- `{{CMAKE_VERSION}}` - CMake version requirement

### Customization Script

Use the provided customization script:

```bash
# Linux/macOS
python3 scripts/customize_template.py \
  --name "MyProject" \
  --app-name "My Application" \
  --description "My Qt application" \
  --author "Your Name" \
  --email "your.email@example.com"

# Windows
python scripts\customize_template.py ^
  --name "MyProject" ^
  --app-name "My Application" ^
  --description "My Qt application" ^
  --author "Your Name" ^
  --email "your.email@example.com"
```

## Common Customizations

### Adding New Features

1. **Create** new source files in appropriate directories
2. **Update** CMakeLists.txt to include new files
3. **Add** tests for new functionality
4. **Update** documentation

### Custom Controls

1. **Add** new control files to `controls/`
2. **Update** `controls/CMakeLists.txt`
3. **Export** control in library interface
4. **Add** tests and documentation

### Additional Dependencies

1. **Add** dependencies to `vcpkg.json`
2. **Update** CMakeLists.txt to find and link libraries
3. **Update** documentation with new requirements

### Internationalization

1. **Add** new language files to `app/i18n/`
2. **Update** CMakeLists.txt translation configuration
3. **Add** language switching logic
4. **Test** with different locales

## Template Structure Customization

### Removing Unwanted Features

If you don't need certain features:

**Remove Theme System**

1. Remove theme-related code from Widget class
2. Delete theme stylesheets
3. Remove theme resources from app.qrc
4. Update tests to remove theme testing

**Remove Internationalization**

1. Remove i18n directory and files
2. Remove translation configuration from CMakeLists.txt
3. Remove language switching code
4. Simplify UI without language options

**Simplify Controls**

1. Remove controls library if not needed
2. Update main CMakeLists.txt
3. Remove controls from app dependencies
4. Remove related tests

### Adding New Modules

To add new functionality modules:

1. **Create** new directory (e.g., `network/`, `database/`)
2. **Add** CMakeLists.txt for the module
3. **Include** module in main CMakeLists.txt
4. **Add** tests for the module
5. **Document** the new module

## Build System Customization

### CMake Configuration

Customize CMake for your needs:

- **Compiler flags** - Add specific compiler options
- **Dependencies** - Add or remove dependencies
- **Install rules** - Customize installation
- **Packaging** - Modify packaging configuration

### vcpkg Dependencies

Manage dependencies through vcpkg:

- **Add libraries** - Include new dependencies
- **Version constraints** - Specify version requirements
- **Features** - Enable/disable library features
- **Custom ports** - Add custom vcpkg ports

### Platform-Specific Configuration

Customize for specific platforms:

- **Windows** - MSVC-specific settings
- **Linux** - GCC/Clang configuration
- **macOS** - Xcode and framework settings

## Testing Customization

### Test Structure

Adapt the test structure:

- **Add test categories** - Create new test types
- **Custom test helpers** - Add utility functions
- **Test data** - Include test data files
- **Mock objects** - Create mock implementations

### CI/CD Integration

Customize continuous integration:

- **Build matrix** - Add/remove platforms
- **Test configuration** - Modify test execution
- **Quality gates** - Add code quality checks
- **Deployment** - Customize release process

## Documentation Customization

### Structure

Adapt documentation structure:

- **Add sections** - Include project-specific docs
- **Remove sections** - Remove irrelevant documentation
- **Reorganize** - Adjust organization for your project

### Generation

Customize documentation generation:

- **Doxygen** - Modify API documentation settings
- **Static site** - Set up documentation website
- **Examples** - Add project-specific examples

## Maintenance

### Keeping Up-to-Date

Stay current with template improvements:

1. **Monitor** template repository for updates
2. **Review** changes and improvements
3. **Merge** relevant updates into your project
4. **Test** thoroughly after updates

### Contributing Back

Share improvements with the community:

1. **Identify** general improvements
2. **Create** pull requests to template repository
3. **Document** new features or fixes
4. **Help** other users with issues

## Migration Guide

### From Older Versions

When migrating from older template versions:

1. **Backup** your current project
2. **Compare** template changes
3. **Update** build configuration
4. **Test** thoroughly
5. **Update** documentation

### To Newer Qt Versions

When upgrading Qt versions:

1. **Update** vcpkg.json Qt version
2. **Check** deprecated API usage
3. **Update** CMake Qt requirements
4. **Test** on all platforms
5. **Update** CI/CD configuration
