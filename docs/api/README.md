# API Documentation

This directory contains the API documentation for qt-simple-template.

## Overview

The API documentation is automatically generated from source code comments using Doxygen. It provides comprehensive information about:

- Classes and their methods
- Function signatures and parameters
- Return values and exceptions
- Usage examples
- Cross-references between components

## Components

### Core Classes

#### Widget

The main application widget that provides the primary user interface.

**Key Features:**

- Theme switching (light/dark)
- Language switching (English/Chinese)
- Event handling
- UI component management

**Public Methods:**

- `applyTheme(const QString& theme)` - Apply a theme to the widget
- `applyEnglishLang(bool enable)` - Switch to English language
- `applyChineseLang(bool enable)` - Switch to Chinese language

#### Slider (Controls Library)

Custom slider control with enhanced functionality.

**Key Features:**

- Standard slider operations
- Custom styling support
- Signal/slot integration
- Range validation

**Public Methods:**

- `setValue(int value)` - Set slider value
- `setRange(int min, int max)` - Set value range
- `value()` - Get current value
- `minimum()` - Get minimum value
- `maximum()` - Get maximum value

### Configuration System

#### config.h

Generated configuration header containing project constants.

**Constants:**

- `PROJECT_NAME` - Project name
- `APP_NAME` - Application display name
- `PROJECT_VER` - Version string
- `PROJECT_VER_MAJOR` - Major version number
- `PROJECT_VER_MINOR` - Minor version number
- `PROJECT_VER_PATCH` - Patch version number

## Generating Documentation

### Prerequisites

```bash
# Install Doxygen and Graphviz
sudo apt-get install doxygen graphviz  # Ubuntu/Debian
brew install doxygen graphviz          # macOS
choco install doxygen.install graphviz # Windows
```

### Build Process

```bash
# Navigate to API documentation directory
cd docs/api

# Generate documentation
doxygen Doxyfile

# Open generated documentation
open html/index.html  # macOS
xdg-open html/index.html  # Linux
start html/index.html  # Windows
```

### Configuration

The Doxygen configuration is stored in `Doxyfile` and includes:

- Source code directories
- Output formats (HTML, LaTeX)
- Documentation extraction settings
- Diagram generation options
- Cross-reference settings

## Documentation Standards

### Code Comments

All public APIs should include Doxygen-compatible comments:

```cpp
/**
 * @brief Apply a theme to the widget
 * 
 * This method loads and applies the specified theme to the widget
 * and all its child components.
 * 
 * @param theme Theme name ("light" or "dark")
 * @return true if theme was applied successfully, false otherwise
 * 
 * @example
 * @code
 * Widget widget;
 * widget.applyTheme("dark");
 * @endcode
 * 
 * @see applyEnglishLang(), applyChineseLang()
 * @since 1.0.0
 */
bool applyTheme(const QString& theme);
```

### Documentation Tags

Use these Doxygen tags consistently:

- `@brief` - Short description
- `@param` - Parameter description
- `@return` - Return value description
- `@example` - Usage example
- `@code/@endcode` - Code blocks
- `@see` - Cross-references
- `@since` - Version introduced
- `@deprecated` - Deprecated features
- `@warning` - Important warnings
- `@note` - Additional notes

## Output Formats

### HTML Documentation

- Interactive navigation
- Search functionality
- Cross-references
- Syntax highlighting
- Responsive design

### PDF Documentation

- Complete API reference
- Printable format
- Bookmarks and index
- Professional layout

## Integration

### Build System

API documentation generation can be integrated into the build system:

```cmake
# Find Doxygen
find_package(Doxygen)

if(DOXYGEN_FOUND)
    # Configure Doxyfile
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/docs/api/Doxyfile.in
                   ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile @ONLY)
    
    # Add documentation target
    add_custom_target(docs
        ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Generating API documentation with Doxygen"
        VERBATIM
    )
endif()
```

### Continuous Integration

- Automatic documentation generation
- Link validation
- Documentation deployment
- Version synchronization

## Maintenance

### Regular Tasks

1. Review and update class documentation
2. Add examples for new features
3. Update cross-references
4. Validate generated output
5. Check for broken links

### Quality Assurance

- Ensure all public APIs are documented
- Verify examples compile and run
- Check documentation completeness
- Validate formatting and style
