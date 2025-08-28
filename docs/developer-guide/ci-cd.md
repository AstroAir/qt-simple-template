# CI/CD Documentation

This document describes the Continuous Integration and Continuous Deployment (CI/CD) setup for qt-simple-template.

## Overview

The project uses GitHub Actions for CI/CD with multiple workflows covering different aspects of development:

- **CI Workflow**: Main build and test pipeline
- **Release Workflow**: Automated release creation and packaging
- **Code Quality**: Static analysis, formatting, and security checks
- **Nightly Builds**: Extended testing and performance monitoring
- **Template Validation**: Ensures template functionality works correctly

## Workflows

### 1. CI Workflow (`.github/workflows/ci.yml`)

**Triggers:**

- Push to `main` or `develop` branches
- Pull requests to `main` or `develop` branches
- Manual dispatch

**Matrix Strategy:**

- **Windows**: MSVC 2022 (Debug/Release)
- **Linux**: GCC (Debug/Release)
- **macOS**: Clang (Debug/Release)

**Steps:**

1. Checkout code with submodules
2. Set up vcpkg with caching
3. Install Qt 6.7.0
4. Install platform-specific dependencies
5. Configure CMake with presets
6. Build application
7. Run tests with appropriate display setup
8. Package release builds
9. Upload artifacts

**Key Features:**

- Cross-platform build matrix
- Automated dependency management
- Comprehensive testing with proper GUI setup
- Artifact collection for debugging

### 2. Release Workflow (`.github/workflows/release.yml`)

**Triggers:**

- Git tags matching `v*` pattern
- Manual dispatch with tag input

**Process:**

1. Create GitHub release
2. Build release packages for all platforms
3. Upload platform-specific installers
4. Publish release

**Artifacts:**

- **Windows**: `.exe` NSIS installer
- **macOS**: `.dmg` disk image
- **Linux**: `.AppImage` portable application

### 3. Code Quality Workflow (`.github/workflows/code-quality.yml`)

**Components:**

#### Static Analysis

- **clang-tidy**: Modern C++ best practices
- **cppcheck**: Additional static analysis
- Results uploaded as artifacts

#### Format Check

- **clang-format**: Code formatting validation
- Fails on formatting violations

#### Documentation

- **Doxygen**: API documentation generation
- **Sphinx**: User documentation (if configured)
- Automatic deployment to GitHub Pages

#### Security Scan

- **CodeQL**: Security vulnerability detection
- **Scorecard**: Supply chain security assessment
- SARIF results integration

#### Coverage

- **lcov**: Code coverage measurement
- **Codecov**: Coverage reporting and tracking
- Excludes system libraries and test code

### 4. Nightly Builds (`.github/workflows/nightly.yml`)

**Schedule:** Daily at 2 AM UTC

**Extended Testing:**

- All platform combinations
- Memory testing with Valgrind (Linux)
- Performance benchmarks
- Extended timeout for thorough testing
- Sanitizer builds (Debug configurations)

**Failure Handling:**

- Automatic issue creation on failure
- Performance regression detection
- Artifact retention for debugging

### 5. Template Validation (`.github/workflows/template-validation.yml`)

**Purpose:** Ensures template functionality works correctly

**Tests:**

- Template configuration validation
- Customization script testing
- Generated project compilation
- Documentation link checking
- Dependency validation

**Matrix Testing:**

- Multiple OS combinations
- Different feature configurations (minimal vs full)
- Template generation and build verification

## Configuration Files

### Dependabot (`.github/dependabot.yml`)

Automated dependency updates for:

- **GitHub Actions**: Weekly updates
- **vcpkg packages**: Monthly updates  
- **CMake dependencies**: Monthly updates

### Issue Templates

#### Bug Report (`.github/ISSUE_TEMPLATE/bug_report.yml`)

Structured bug reporting with:

- Environment details (OS, Qt version, etc.)
- Reproduction steps
- Expected vs actual behavior
- Log output collection

#### Feature Request (`.github/ISSUE_TEMPLATE/feature_request.yml`)

Feature suggestion template with:

- Problem description
- Proposed solution
- Use case details
- Implementation ideas
- Contribution willingness

### Pull Request Template (`.github/pull_request_template.md`)

Comprehensive PR template covering:

- Change description and type
- Testing requirements
- Documentation updates
- Breaking change assessment
- Reviewer guidelines

## Automation Features

### Auto-merge (`.github/workflows/auto-merge.yml`)

Automatically merges safe dependabot PRs:

- Patch updates
- CI/build updates
- Requires passing status checks
- Optional approval for minor updates

### Stale Issue Management (`.github/workflows/stale.yml`)

Automatically manages inactive issues/PRs:

- Issues: 60 days stale, 7 days to close
- PRs: 30 days stale, 7 days to close
- Exemptions for important labels
- Automatic label management

## Environment Variables

### Required Secrets

- `GITHUB_TOKEN`: Automatic GitHub token (provided)

### Optional Secrets

- `CODECOV_TOKEN`: For enhanced Codecov integration
- `SONAR_TOKEN`: If SonarCloud integration is added

### Environment Variables

- `QT_VERSION`: Qt version to use (default: 6.7.0)
- `CMAKE_VERSION`: CMake version requirement (default: 3.28.0)
- `VCPKG_BINARY_SOURCES`: vcpkg caching configuration

## Platform-Specific Considerations

### Windows

- Uses MSVC 2022 compiler
- Requires `ilammy/msvc-dev-cmd` action
- NSIS installer creation
- windeployqt for Qt deployment

### Linux

- Uses GCC compiler
- Requires X11 libraries for GUI testing
- Xvfb for headless testing
- AppImage creation with linuxdeploy

### macOS

- Uses Clang compiler
- Homebrew for system dependencies
- DMG creation with create-dmg
- macdeployqt for Qt deployment

## Caching Strategy

### vcpkg Caching

- Uses GitHub Actions cache
- Shared across workflow runs
- Significantly reduces build times

### Qt Caching

- Qt installation cached by version and platform
- Reduces setup time for subsequent runs

### Build Caching

- CMake build cache when possible
- Compiler cache for faster rebuilds

## Monitoring and Notifications

### Status Badges

Add these badges to README.md:

```markdown
[![CI](https://github.com/your-org/qt-simple-template/workflows/CI/badge.svg)](https://github.com/your-org/qt-simple-template/actions/workflows/ci.yml)
[![Code Quality](https://github.com/your-org/qt-simple-template/workflows/Code%20Quality/badge.svg)](https://github.com/your-org/qt-simple-template/actions/workflows/code-quality.yml)
[![codecov](https://codecov.io/gh/your-org/qt-simple-template/branch/main/graph/badge.svg)](https://codecov.io/gh/your-org/qt-simple-template)
```

### Failure Notifications

- Nightly build failures create GitHub issues
- Email notifications for maintainers
- Slack/Discord integration (if configured)

## Best Practices

### Workflow Design

1. **Fail Fast**: Quick feedback on common issues
2. **Matrix Testing**: Comprehensive platform coverage
3. **Artifact Collection**: Debug information preservation
4. **Caching**: Minimize redundant work
5. **Security**: Minimal required permissions

### Testing Strategy

1. **Unit Tests**: Fast, isolated component testing
2. **Integration Tests**: Component interaction validation
3. **GUI Testing**: Headless UI testing with Xvfb
4. **Performance Tests**: Benchmark regression detection
5. **Memory Testing**: Leak detection with Valgrind

### Release Management

1. **Semantic Versioning**: Clear version progression
2. **Automated Packaging**: Consistent release artifacts
3. **Multi-platform**: Simultaneous platform releases
4. **Documentation**: Automatic docs deployment

## Troubleshooting

### Common Issues

#### Build Failures

- Check vcpkg cache corruption
- Verify Qt installation
- Review platform-specific dependencies

#### Test Failures

- GUI tests require proper display setup
- Check for race conditions in parallel tests
- Verify test environment isolation

#### Packaging Issues

- Ensure deployment tools are available
- Check file permissions and paths
- Verify code signing configuration

### Debugging Workflows

1. Enable debug logging in actions
2. Use `workflow_dispatch` for manual testing
3. Check artifact uploads for build outputs
4. Review action logs for detailed error messages

## Future Enhancements

### Planned Improvements

1. **Container Support**: Docker-based builds
2. **Multi-architecture**: ARM64 support
3. **Performance Monitoring**: Automated benchmarking
4. **Security Scanning**: Enhanced vulnerability detection
5. **Deployment**: Automated distribution to package managers
