# Template Usage Guide

This guide explains how to use qt-simple-template to create your own Qt6 project.

## Quick Start

### Method 1: GitHub Template (Recommended)
1. Click "Use this template" on the GitHub repository page
2. Create a new repository from the template
3. Clone your new repository
4. Run the customization script

### Method 2: Manual Setup
1. Download or clone this repository
2. Remove the `.git` directory
3. Initialize a new Git repository
4. Run the customization script

## Customization

### Interactive Customization
```bash
# Run interactive customization
python scripts/customize_template.py --interactive

# Or on Windows
scripts\customize_template.bat --interactive
```

### Command Line Customization
```bash
# Customize with specific values
python scripts/customize_template.py \
  --project-name "my_awesome_app" \
  --app-name "My Awesome App" \
  --project-description "An awesome Qt6 application" \
  --author-name "Your Name" \
  --author-email "your.email@example.com" \
  --project-website "https://github.com/yourname/my-awesome-app"
```

### Available Options
- `--project-name` - Technical project name (no spaces, used in CMake)
- `--app-name` - User-friendly application name
- `--project-description` - Brief description of your project
- `--author-name` - Your name or organization
- `--author-email` - Contact email address
- `--project-website` - Project website or repository URL
- `--project-version` - Initial version (default: 1.0.0)
- `--copyright-year` - Copyright year (default: current year)
- `--license-type` - License type (MIT, Apache-2.0, GPL-3.0, BSD-3-Clause, Custom)
- `--qt-version` - Minimum Qt version requirement
- `--cmake-version` - Minimum CMake version requirement
- `--cpp-standard` - C++ standard (17, 20, 23)

### Feature Toggles
- `--enable-testing` / `--disable-testing` - Include/exclude testing infrastructure
- `--enable-docs` / `--disable-docs` - Include/exclude documentation
- `--enable-i18n` / `--disable-i18n` - Include/exclude internationalization
- `--enable-themes` / `--disable-themes` - Include/exclude theme system

## What Gets Customized

### Files Modified
- `CMakeLists.txt` - Project name, version, requirements
- `vcpkg.json` - Package information and dependencies
- `README.md` - Project documentation
- `LICENSE` - License text with your information
- `app/config.h.in` - Application configuration

### Optional Removals
Based on your feature selections, these may be removed:
- `tests/` - Testing infrastructure
- `docs/` - Documentation structure
- `app/i18n/` - Internationalization files
- Theme-related code and assets

## After Customization

### 1. Review Changes
Check the modified files to ensure everything looks correct:
```bash
git diff  # If you initialized Git
```

### 2. Build Your Project
```bash
# Install dependencies
vcpkg install

# Configure build
cmake --preset Debug-Windows  # Windows
cmake --preset Debug-Unix     # Linux/macOS

# Build
cmake --build build/Debug
```

### 3. Test Your Project
```bash
# Run tests (if enabled)
ctest --test-dir build/Debug

# Run the application
./build/Debug/app/your_project_name
```

### 4. Start Development
- Modify `app/Widget.h/.cpp/.ui` for your main window
- Add custom controls to `controls/`
- Update assets in `assets/`
- Add your application logic

## Template Structure

### Core Components
- **app/** - Main application code
- **controls/** - Custom UI controls library
- **assets/** - Images, styles, and resources
- **tests/** - Test suite (optional)
- **docs/** - Documentation (optional)
- **scripts/** - Build and utility scripts

### Build System
- **CMakeLists.txt** - Main build configuration
- **CMakePresets.json** - Build presets for different platforms
- **vcpkg.json** - Dependency management
- **.clang-format** - Code formatting rules

## Customization Examples

### Minimal Project
```bash
python scripts/customize_template.py \
  --project-name "simple_app" \
  --app-name "Simple App" \
  --disable-testing \
  --disable-docs \
  --disable-i18n
```

### Full-Featured Project
```bash
python scripts/customize_template.py \
  --project-name "advanced_app" \
  --app-name "Advanced Application" \
  --project-description "A feature-rich Qt6 application" \
  --author-name "Development Team" \
  --license-type "Apache-2.0" \
  --enable-testing \
  --enable-docs \
  --enable-i18n \
  --enable-themes
```

### Enterprise Project
```bash
python scripts/customize_template.py \
  --project-name "enterprise_solution" \
  --app-name "Enterprise Solution" \
  --project-description "Professional enterprise application" \
  --author-name "Your Company" \
  --author-email "contact@yourcompany.com" \
  --project-website "https://yourcompany.com/products/enterprise-solution" \
  --license-type "Custom" \
  --qt-version "6.5" \
  --cpp-standard "20"
```

## Advanced Customization

### Manual Template Editing
For complex customizations, you can:
1. Edit `template.json` to add new variables
2. Create additional template files
3. Modify the customization script
4. Add custom post-generation commands

### Adding New Variables
Edit `template.json`:
```json
{
  "variables": {
    "MY_CUSTOM_VAR": {
      "description": "My custom variable",
      "type": "string",
      "default": "default_value",
      "required": false
    }
  }
}
```

### Custom License
If you select "Custom" license:
1. Edit `LICENSE.template` 
2. Add your custom license text
3. Use template variables as needed

## Validation

### Validate Template
Before customization, validate the template:
```bash
python scripts/validate_template.py
```

### Strict Validation
Treat warnings as errors:
```bash
python scripts/validate_template.py --strict
```

## Troubleshooting

### Common Issues

**Python not found**
- Install Python 3.6 or later
- Ensure Python is in your PATH

**Template validation fails**
- Check that all required files are present
- Verify template.json syntax
- Ensure template variables are properly defined

**Build fails after customization**
- Verify vcpkg dependencies are installed
- Check CMake configuration
- Ensure Qt6 is properly installed

**Missing features after customization**
- Check if features were disabled during customization
- Review conditional file operations in template.json
- Manually restore files if needed

### Getting Help
1. Check the troubleshooting documentation
2. Review the template validation output
3. Check the project issues on GitHub
4. Contact the template maintainers

## Contributing

### Improving the Template
1. Fork the repository
2. Make your improvements
3. Test with the validation script
4. Submit a pull request

### Adding Features
1. Update template.json with new variables
2. Create or modify template files
3. Update documentation
4. Add tests for new functionality

### Reporting Issues
When reporting issues:
1. Include your operating system
2. Provide the customization command used
3. Include error messages
4. Attach relevant log files
