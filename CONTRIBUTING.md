# Contributing to Qt Simple Template

Thank you for your interest in contributing to Qt Simple Template! This document provides guidelines and information for contributors.

## 🎯 How to Contribute

We welcome contributions in many forms:
- 🐛 **Bug reports** - Help us identify and fix issues
- 💡 **Feature requests** - Suggest new functionality
- 📝 **Documentation** - Improve guides, examples, and API docs
- 🔧 **Code contributions** - Bug fixes, features, and improvements
- 🧪 **Testing** - Help test new features and report issues
- 🎨 **Examples** - Add new examples and tutorials

## 🚀 Getting Started

### Prerequisites

Before contributing, ensure you have:
- Qt 6.2 or later installed
- CMake 3.28 or later
- C++20 compatible compiler
- Git for version control
- Basic familiarity with Qt and CMake

### Development Setup

1. **Fork the repository**
   ```bash
   # Fork on GitHub, then clone your fork
   git clone https://github.com/YOUR_USERNAME/qt-simple-template.git
   cd qt-simple-template
   ```

2. **Set up development environment**
   ```bash
   # Install dependencies (choose your package manager)
   vcpkg install  # or conan install, or use system packages
   
   # Configure and build
   cmake --preset Debug-Windows  # or Debug-Unix
   cmake --build build/Debug
   ```

3. **Run tests to verify setup**
   ```bash
   cd build/Debug
   ctest --output-on-failure
   ```

4. **Set up pre-commit hooks** (recommended)
   ```bash
   pip install pre-commit
   pre-commit install
   ```

## 📋 Contribution Process

### 1. Planning Your Contribution

**For bug fixes:**
- Check existing issues to avoid duplicates
- Create an issue if one doesn't exist
- Discuss the approach before implementing

**For new features:**
- Open an issue to discuss the feature first
- Wait for maintainer feedback before starting
- Consider backward compatibility

**For documentation:**
- Check for existing documentation gaps
- Follow the established style and structure

### 2. Making Changes

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/issue-number-description
   ```

2. **Make your changes**
   - Follow the coding standards (see below)
   - Write tests for new functionality
   - Update documentation as needed
   - Ensure all tests pass

3. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add new feature description"
   # Follow conventional commit format
   ```

4. **Push and create pull request**
   ```bash
   git push origin feature/your-feature-name
   # Create PR on GitHub
   ```

## 📏 Coding Standards

### C++ Code Style

We use **clang-format** for consistent formatting:
```bash
# Format all files
find . -name "*.cpp" -o -name "*.h" | xargs clang-format -i

# Or use the pre-commit hook
pre-commit run clang-format --all-files
```

**Key style guidelines:**
- **Indentation**: 4 spaces (no tabs)
- **Line length**: 120 characters maximum
- **Naming conventions**:
  - Classes: `PascalCase` (e.g., `MyWidget`)
  - Functions/methods: `camelCase` (e.g., `getValue()`)
  - Variables: `camelCase` (e.g., `myVariable`)
  - Member variables: `m_` prefix (e.g., `m_value`)
  - Constants: `UPPER_CASE` (e.g., `MAX_SIZE`)

### CMake Style

- Use lowercase commands: `add_executable()` not `ADD_EXECUTABLE()`
- Indent with 2 or 4 spaces consistently
- Use modern CMake practices (targets, not variables)

### Documentation

- **API documentation**: Use Doxygen comments for all public APIs
- **Code comments**: Explain "why", not "what"
- **README files**: Include for all examples and major components

## 🧪 Testing Guidelines

### Writing Tests

- **Unit tests**: Test individual components in isolation
- **Integration tests**: Test component interactions
- **Example tests**: Ensure examples build and run

### Test Structure

```cpp
#include <QtTest/QtTest>
#include "YourClass.h"

class TestYourClass : public QObject
{
    Q_OBJECT

private slots:
    void initTestCase();    // Run once before all tests
    void init();           // Run before each test
    void testBasicFunctionality();
    void testEdgeCases();
    void cleanup();        // Run after each test
    void cleanupTestCase(); // Run once after all tests
};

QTEST_MAIN(TestYourClass)
#include "test_yourclass.moc"
```

### Running Tests

```bash
# Run all tests
ctest --output-on-failure

# Run specific test
ctest -R test_name

# Run with verbose output
ctest -V
```

## 📚 Documentation Guidelines

### API Documentation

Use Doxygen format for all public APIs:

```cpp
/**
 * @brief Brief description of the function
 * @param parameter Description of parameter
 * @return Description of return value
 * @throws ExceptionType When this exception is thrown
 * 
 * Detailed description of the function behavior,
 * including usage examples if helpful.
 */
ReturnType functionName(ParameterType parameter);
```

### Example Documentation

Each example should include:
- **README.md**: Purpose, build instructions, key concepts
- **Inline comments**: Explain important code sections
- **CMakeLists.txt**: Proper build configuration

## 🔍 Code Review Process

### Submitting Pull Requests

1. **Fill out the PR template** completely
2. **Link related issues** using keywords (fixes #123)
3. **Provide clear description** of changes
4. **Include screenshots** for UI changes
5. **Ensure CI passes** before requesting review

### Review Criteria

Pull requests are evaluated on:
- **Functionality**: Does it work as intended?
- **Code quality**: Is it well-written and maintainable?
- **Testing**: Are there adequate tests?
- **Documentation**: Is it properly documented?
- **Compatibility**: Does it maintain backward compatibility?

### Addressing Feedback

- **Respond promptly** to review comments
- **Make requested changes** in new commits
- **Explain your reasoning** if you disagree with feedback
- **Ask for clarification** if comments are unclear

## 🏷️ Commit Message Format

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(widgets): add custom progress indicator widget
fix(cmake): resolve vcpkg integration issue on Windows
docs(examples): add comprehensive hello-world tutorial
test(controls): add unit tests for Slider widget
```

## 🐛 Reporting Issues

### Bug Reports

Include the following information:
- **Qt version** and platform
- **Build configuration** (Debug/Release, package manager)
- **Steps to reproduce** the issue
- **Expected vs actual behavior**
- **Error messages** or logs
- **Minimal code example** if applicable

### Feature Requests

Describe:
- **Use case** and motivation
- **Proposed solution** or API
- **Alternatives considered**
- **Additional context** or examples

## 🏆 Recognition

Contributors are recognized in:
- **CONTRIBUTORS.md** file
- **Release notes** for significant contributions
- **GitHub contributors** page

## 📞 Getting Help

- **GitHub Discussions**: For questions and general discussion
- **GitHub Issues**: For bug reports and feature requests
- **Code Review**: For implementation feedback

## 📜 License

By contributing to Qt Simple Template, you agree that your contributions will be licensed under the same license as the project (MIT License).

---

Thank you for contributing to Qt Simple Template! 🎉
