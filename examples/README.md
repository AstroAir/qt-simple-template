# Qt Simple Template Examples

This directory contains practical examples demonstrating various features and use cases of the Qt Simple Template project.

## 📁 Directory Structure

```
examples/
├── basic-usage/           # Basic Qt application patterns
├── advanced-features/     # Advanced Qt functionality
├── custom-widgets/        # Custom widget development
├── integration-examples/  # Third-party library integration
└── README.md             # This file
```

## 🚀 Getting Started

Each example is self-contained and includes:
- Complete source code
- CMakeLists.txt for building
- README.md with explanation
- Screenshots or demos (where applicable)

### Building Examples

```bash
# Build all examples
cmake --build build --target examples

# Build specific example
cmake --build build --target example_basic_usage
```

### Running Examples

```bash
# From build directory
./examples/basic-usage/basic_usage_example
./examples/advanced-features/advanced_features_example
# ... etc
```

## 📚 Example Categories

### 1. Basic Usage (`basic-usage/`)

Fundamental Qt patterns and best practices:
- **Hello World** - Minimal Qt application
- **Layouts** - Different layout managers
- **Signals & Slots** - Event handling
- **Resources** - Using Qt Resource System
- **Internationalization** - Multi-language support

### 2. Advanced Features (`advanced-features/`)

More sophisticated Qt functionality:
- **Model/View** - Data presentation patterns
- **Custom Painting** - QPainter and custom drawing
- **Threading** - Background processing
- **Networking** - HTTP requests and WebSocket
- **Database** - SQLite integration
- **Plugins** - Dynamic loading

### 3. Custom Widgets (`custom-widgets/`)

Creating reusable UI components:
- **Custom Button** - Enhanced button widget
- **Progress Indicator** - Animated progress display
- **Chart Widget** - Simple data visualization
- **Color Picker** - Color selection widget
- **File Browser** - Custom file explorer

### 4. Integration Examples (`integration-examples/`)

Third-party library integration:
- **JSON Processing** - Using nlohmann/json
- **HTTP Client** - Using libcurl or Qt Network
- **Image Processing** - Using OpenCV
- **Logging** - Using spdlog
- **Configuration** - Using toml++

## 🎯 Learning Path

**Beginner:**
1. Start with `basic-usage/hello-world`
2. Explore `basic-usage/layouts`
3. Learn `basic-usage/signals-slots`

**Intermediate:**
1. Study `advanced-features/model-view`
2. Try `custom-widgets/custom-button`
3. Experiment with `advanced-features/threading`

**Advanced:**
1. Implement `advanced-features/plugins`
2. Create complex `custom-widgets`
3. Integrate external libraries

## 🔧 Development Tips

### Code Style
All examples follow the project's coding standards:
- Use `.clang-format` for formatting
- Follow Qt naming conventions
- Include comprehensive comments

### Testing
Each example includes basic tests:
```bash
# Run example tests
ctest -R example_tests
```

### Documentation
Examples are documented with:
- Inline code comments
- README.md explanations
- API documentation (Doxygen)

## 🤝 Contributing Examples

Want to add a new example? Please:

1. Create a new directory under the appropriate category
2. Include complete, working code
3. Add CMakeLists.txt for building
4. Write clear README.md documentation
5. Add tests if applicable
6. Follow the project's coding standards

### Example Template Structure

```
examples/category/new-example/
├── CMakeLists.txt
├── README.md
├── main.cpp
├── ExampleWidget.h
├── ExampleWidget.cpp
├── ExampleWidget.ui (if applicable)
└── tests/
    └── test_example.cpp
```

## 📖 Additional Resources

- [Qt Documentation](https://doc.qt.io/)
- [Qt Examples and Tutorials](https://doc.qt.io/qt-6/qtexamplesandtutorials.html)
- [Project Documentation](../docs/)
- [API Reference](../docs/api/)

## 🐛 Issues and Feedback

Found a problem with an example? Please:
1. Check the example's README.md
2. Verify your Qt and CMake versions
3. Report issues on the project's issue tracker
4. Include your platform and build configuration

Happy coding! 🎉
