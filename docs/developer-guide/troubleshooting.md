# Troubleshooting Guide

This guide covers common issues and solutions when setting up and using clangd and pre-commit hooks in the Qt6 project.

## clangd Issues

### clangd Not Finding Headers

**Problem:** clangd shows errors like "file not found" for Qt headers or project headers.

**Solutions:**

1. **Ensure compile_commands.json exists:**
   ```bash
   # Check if the file exists in your build directory
   ls build/Debug/compile_commands.json
   
   # If missing, reconfigure CMake
   cmake --preset Debug-Windows
   ```

2. **Verify clangd is using the correct compilation database:**
   - clangd searches for `compile_commands.json` in parent directories
   - Ensure your build directory is named `build/` or create a symlink:
   ```bash
   ln -s build/Debug/compile_commands.json compile_commands.json
   ```

3. **Check Qt installation paths:**
   - Verify Qt is properly installed and detected by CMake
   - Check CMake output for Qt paths during configuration

### clangd Performance Issues

**Problem:** clangd is slow or uses too much memory.

**Solutions:**

1. **Adjust memory limit in .clangd:**
   ```yaml
   MemoryLimit: 4096  # Reduce from 8192 to 4GB
   ```

2. **Disable background indexing temporarily:**
   ```yaml
   Index:
     Background: Skip
   ```

3. **Exclude large directories:**
   Add to `.clangd`:
   ```yaml
   CompileFlags:
     Remove:
       - -I/path/to/large/system/headers
   ```

### clangd MOC File Errors

**Problem:** clangd shows errors in MOC-generated files or Qt signal/slot connections.

**Solutions:**

1. **Verify MOC files are excluded:**
   The `.clangd` configuration should already exclude MOC files, but verify:
   ```yaml
   # MOC files are automatically handled
   ```

2. **Check Q_OBJECT macro:**
   Ensure classes with signals/slots have the `Q_OBJECT` macro

3. **Rebuild MOC files:**
   ```bash
   cmake --build build/Debug --target clean
   cmake --build build/Debug
   ```

### IDE-Specific Issues

**VS Code:**
- Disable Microsoft C/C++ extension for this workspace
- Install only the "clangd" extension
- Restart VS Code after configuration changes

**Qt Creator:**
- Ensure "Use clangd" is enabled in C++ settings
- Clear code model cache: Tools → C++ → Clear Cache and Restart

**CLion:**
- Disable bundled C++ language engine
- Enable clangd in settings
- Invalidate caches and restart

## Pre-commit Issues

### Pre-commit Installation Problems

**Problem:** `pre-commit install` fails or hooks don't run.

**Solutions:**

1. **Verify pre-commit installation:**
   ```bash
   pre-commit --version
   pip install --upgrade pre-commit
   ```

2. **Check Git repository:**
   ```bash
   # Ensure you're in a Git repository
   git status
   
   # Reinstall hooks
   pre-commit uninstall
   pre-commit install
   ```

3. **Python environment issues:**
   ```bash
   # Use virtual environment
   python -m venv venv
   source venv/bin/activate  # Linux/macOS
   # or
   venv\Scripts\activate     # Windows
   pip install pre-commit
   ```

### Hook Execution Failures

**Problem:** Pre-commit hooks fail during execution.

**Solutions:**

1. **CMake configuration failures:**
   ```bash
   # Ensure CMake can configure successfully
   cmake --preset Debug-Windows
   
   # If using different build directory, update .pre-commit-config.yaml
   ```

2. **Missing tools:**
   ```bash
   # Install required tools
   # Windows (MSYS2):
   pacman -S mingw-w64-x86_64-clang-tools-extra
   
   # Linux:
   sudo apt-get install clang-format clang-tidy cppcheck
   
   # macOS:
   brew install llvm cppcheck
   ```

3. **Tool version conflicts:**
   ```bash
   # Check tool versions
   clang-format --version
   clang-tidy --version
   
   # Update .pre-commit-config.yaml if needed
   ```

### Slow Hook Performance

**Problem:** Pre-commit hooks take too long to run.

**Solutions:**

1. **Use existing build directory:**
   The configuration already specifies multiple build directories to try

2. **Skip hooks temporarily:**
   ```bash
   # Skip all hooks for urgent commits
   git commit --no-verify -m "urgent fix"
   
   # Skip specific hooks
   SKIP=clang-tidy git commit -m "skip tidy"
   ```

3. **Optimize hook configuration:**
   Edit `.pre-commit-config.yaml` to reduce scope:
   ```yaml
   # Add to hook args:
   --files=app/.*\.cpp$  # Only check app directory
   ```

### Hook-Specific Issues

**clang-format hook:**
- Ensure `.clang-format` file exists
- Check file permissions
- Verify clang-format version compatibility

**clang-tidy hook:**
- May fail if compilation database is incomplete
- Check for missing dependencies in CMake configuration
- Reduce checks if too strict: edit `--checks` argument

**cppcheck hook:**
- May report false positives
- Add suppressions to reduce noise
- Check cppcheck version compatibility

## Build System Issues

### CMake Configuration Problems

**Problem:** CMake fails to configure with new settings.

**Solutions:**

1. **Clear CMake cache:**
   ```bash
   rm -rf build/
   cmake --preset Debug-Windows
   ```

2. **Check package manager setup:**
   ```bash
   # Verify vcpkg/Conan installation
   vcpkg list
   # or
   conan profile detect
   ```

3. **Environment variables:**
   ```bash
   # Set required environment variables
   export VCPKG_ROOT=/path/to/vcpkg
   export Qt6_DIR=/path/to/qt6
   ```

### Compilation Database Issues

**Problem:** `compile_commands.json` is empty or incomplete.

**Solutions:**

1. **Check CMake generator:**
   ```bash
   # Ninja and Makefiles support compile_commands.json
   cmake -G Ninja -S . -B build
   ```

2. **Verify CMAKE_EXPORT_COMPILE_COMMANDS:**
   Should be automatically set, but verify in CMakeLists.txt

3. **Manual generation:**
   ```bash
   cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -S . -B build
   ```

## General Tips

### Debugging Steps

1. **Check tool versions:**
   ```bash
   clangd --version
   clang-format --version
   clang-tidy --version
   pre-commit --version
   cmake --version
   ```

2. **Verbose output:**
   ```bash
   # clangd verbose logging
   clangd --log=verbose
   
   # pre-commit verbose output
   pre-commit run --verbose --all-files
   ```

3. **Clean rebuild:**
   ```bash
   rm -rf build/
   cmake --preset Debug-Windows
   cmake --build build/Debug
   ```

### Getting Help

- Check project issues on GitHub
- Review clangd documentation: https://clangd.llvm.org/
- Pre-commit documentation: https://pre-commit.com/
- Qt documentation for MOC-related issues

### Performance Optimization

1. **Use SSD storage** for build directories
2. **Increase RAM** for better clangd performance
3. **Use ccache** for faster compilation
4. **Exclude unnecessary directories** from indexing

Remember to restart your IDE after making configuration changes to ensure they take effect.
