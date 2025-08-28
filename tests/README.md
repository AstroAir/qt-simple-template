# Testing Infrastructure

This directory contains the comprehensive testing infrastructure for the qt-simple-template project.

## Test Structure

```txt
tests/
├── CMakeLists.txt          # Main test configuration
├── CTestConfig.cmake       # CTest configuration
├── README.md              # This file
├── unit/                  # Unit tests
│   ├── CMakeLists.txt
│   ├── test_slider.cpp    # Tests for Slider control
│   ├── test_widget.cpp    # Tests for main Widget
│   ├── test_config.cpp    # Tests for configuration
│   ├── test_theme.cpp     # Tests for theme system
│   └── test_i18n.cpp      # Tests for internationalization
├── integration/           # Integration tests
│   ├── CMakeLists.txt
│   ├── test_app_integration.cpp      # Full application workflow tests
│   ├── test_build_integration.cpp    # Build system integration tests
│   └── test_resource_integration.cpp # Resource loading tests
└── benchmarks/           # Performance benchmarks
    ├── CMakeLists.txt
    ├── benchmark_widget_performance.cpp    # Widget performance benchmarks
    ├── benchmark_theme_switching.cpp       # Theme switching benchmarks
    └── benchmark_resource_loading.cpp      # Resource loading benchmarks
```

## Test Types

### Unit Tests

- **test_slider.cpp**: Tests the custom Slider control functionality
- **test_widget.cpp**: Tests the main Widget class behavior
- **test_config.cpp**: Tests configuration system and constants
- **test_theme.cpp**: Tests theme file loading and application
- **test_i18n.cpp**: Tests internationalization functionality

### Integration Tests

- **test_app_integration.cpp**: Tests complete application workflows
- **test_build_integration.cpp**: Tests build system integration
- **test_resource_integration.cpp**: Tests resource loading systems

### Benchmarks

- **benchmark_widget_performance.cpp**: Performance tests for widget operations
- **benchmark_theme_switching.cpp**: Performance tests for theme switching
- **benchmark_resource_loading.cpp**: Performance tests for resource loading

## Running Tests

### Using CMake/CTest

```bash
# Build with testing enabled (default)
cmake --build build --target all

# Run all tests
ctest --test-dir build

# Run tests with verbose output
ctest --test-dir build --verbose

# Run specific test types
ctest --test-dir build -R "test_.*"        # Unit tests only
ctest --test-dir build -R ".*integration.*" # Integration tests only
ctest --test-dir build -R "benchmark_.*"   # Benchmarks only

# Run tests in parallel
ctest --test-dir build -j 4
```

### Using Test Runner Scripts

```bash
# Linux/macOS
python3 scripts/run_tests.py --type all --verbose

# Windows
scripts\run_tests.bat --type all --verbose
```

### Available Script Options

- `--type`: Test type to run (unit, integration, benchmark, all)
- `--build-dir`: Specify build directory
- `--verbose`: Enable verbose output
- `--parallel`: Number of parallel jobs

## Test Framework

The tests use Qt Test framework (QTest) which provides:

- Unit testing capabilities
- GUI testing support
- Benchmarking functionality
- Signal/slot testing
- Data-driven testing
- Integration with CTest

## Test Environment

Tests are configured to run in headless mode using the offscreen platform:

- Environment variable: `QT_QPA_PLATFORM=offscreen`
- Timeout: 30 seconds per test
- Parallel execution supported

## Adding New Tests

### Unit Test Template

```cpp
#include <QtTest>
#include <QApplication>
// Include your class header

class TestYourClass : public QObject
{
    Q_OBJECT

private slots:
    void initTestCase();    // Called before first test
    void cleanupTestCase(); // Called after last test
    void init();           // Called before each test
    void cleanup();        // Called after each test
    
    // Your test methods
    void testSomething();
    void testSomethingElse();

private:
    // Test data members
};

// Implement test methods...

QTEST_MAIN(TestYourClass)
#include "test_your_class.moc"
```

### Adding Test to CMake

1. Add your test file to the appropriate CMakeLists.txt
2. Use the `add_qt_test()` function:

```cmake
add_qt_test(test_your_class
    test_your_class.cpp
)
```

## Continuous Integration

Tests are automatically run in CI/CD pipelines:

- All test types are executed
- Test results are reported
- Coverage information is collected
- Performance regression detection

## Best Practices

1. **Test Naming**: Use descriptive names starting with `test_` for unit tests
2. **Test Isolation**: Each test should be independent and not rely on others
3. **Resource Cleanup**: Always clean up resources in `cleanup()` or destructors
4. **Assertions**: Use appropriate Qt Test macros (QVERIFY, QCOMPARE, etc.)
5. **Documentation**: Document complex test scenarios
6. **Performance**: Keep unit tests fast, use benchmarks for performance testing

## Troubleshooting

### Common Issues

1. **Missing Qt platform plugin**: Ensure `QT_QPA_PLATFORM=offscreen` is set
2. **Resource not found**: Check that resources are properly built and accessible
3. **Test timeout**: Increase timeout in CTestConfig.cmake if needed
4. **Build failures**: Ensure all dependencies are properly linked

### Debug Mode

Run individual tests with debug output:

```bash
./build/tests/unit/test_widget --verbose
```

### Memory Testing

Use Valgrind or similar tools for memory leak detection:

```bash
valgrind --tool=memcheck ./build/tests/unit/test_widget
```
