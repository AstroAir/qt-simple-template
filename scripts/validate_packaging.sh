#!/bin/bash
# Packaging Validation Script for qt-simple-template
# This script validates available packaging tools and formats

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_test() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

# Test results tracking
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_TOTAL=0

# Function to run a test
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    print_test "Testing: $test_name"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    if eval "$test_command"; then
        print_success "AVAILABLE: $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        print_warning "NOT AVAILABLE: $test_name"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Platform detection
detect_platform() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        PLATFORM="linux"
        if command -v lsb_release >/dev/null 2>&1; then
            DISTRO=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
        elif [[ -f /etc/os-release ]]; then
            DISTRO=$(grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
        else
            DISTRO="unknown"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        PLATFORM="macos"
        DISTRO="macos"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        PLATFORM="windows"
        DISTRO="windows"
    else
        PLATFORM="unknown"
        DISTRO="unknown"
    fi
    
    print_info "Platform: $PLATFORM"
    print_info "Distribution: $DISTRO"
}

# Test Linux packaging tools
test_linux_packaging() {
    print_info "Testing Linux packaging tools..."
    
    # DEB packaging
    run_test "DEB packaging (dpkg-deb)" "command -v dpkg-deb >/dev/null 2>&1"
    
    # RPM packaging
    run_test "RPM packaging (rpmbuild)" "command -v rpmbuild >/dev/null 2>&1"
    
    # AppImage tools
    run_test "AppImage (linuxdeploy)" "command -v linuxdeploy >/dev/null 2>&1"
    run_test "AppImage Qt plugin" "command -v linuxdeploy-plugin-qt >/dev/null 2>&1"
    run_test "AppImage (appimagetool)" "command -v appimagetool >/dev/null 2>&1"
    
    # Snap packaging
    run_test "Snap packaging (snapcraft)" "command -v snapcraft >/dev/null 2>&1"
    
    # Flatpak packaging
    run_test "Flatpak packaging (flatpak-builder)" "command -v flatpak-builder >/dev/null 2>&1"
    
    # Arch packaging
    if [[ "$DISTRO" == "arch" ]] || [[ "$DISTRO" == "manjaro" ]]; then
        run_test "Arch packaging (makepkg)" "command -v makepkg >/dev/null 2>&1"
    fi
}

# Test Windows packaging tools
test_windows_packaging() {
    print_info "Testing Windows packaging tools..."
    
    # NSIS
    run_test "NSIS installer (makensis)" "command -v makensis >/dev/null 2>&1"
    
    # WiX Toolset
    run_test "WiX candle" "command -v candle >/dev/null 2>&1"
    run_test "WiX light" "command -v light >/dev/null 2>&1"
    
    # Chocolatey
    run_test "Chocolatey (choco)" "command -v choco >/dev/null 2>&1"
    
    # WinGet (check if winget is available)
    run_test "WinGet (winget)" "command -v winget >/dev/null 2>&1"
}

# Test macOS packaging tools
test_macos_packaging() {
    print_info "Testing macOS packaging tools..."
    
    # macdeployqt
    run_test "macdeployqt" "command -v macdeployqt >/dev/null 2>&1"
    
    # create-dmg
    run_test "create-dmg" "command -v create-dmg >/dev/null 2>&1"
    
    # PKG tools
    run_test "pkgbuild" "command -v pkgbuild >/dev/null 2>&1"
    run_test "productbuild" "command -v productbuild >/dev/null 2>&1"
    
    # Code signing
    run_test "codesign" "command -v codesign >/dev/null 2>&1"
    run_test "xcrun notarytool" "xcrun notarytool --help >/dev/null 2>&1"
    
    # Package managers
    run_test "Homebrew (brew)" "command -v brew >/dev/null 2>&1"
    run_test "MacPorts (port)" "command -v port >/dev/null 2>&1"
}

# Test cross-platform tools
test_cross_platform_tools() {
    print_info "Testing cross-platform packaging tools..."
    
    # Docker
    run_test "Docker" "command -v docker >/dev/null 2>&1"
    if command -v docker >/dev/null 2>&1; then
        run_test "Docker buildx" "docker buildx version >/dev/null 2>&1"
    fi
    
    # Conda
    run_test "Conda build" "command -v conda-build >/dev/null 2>&1"
    
    # Qt Installer Framework
    run_test "Qt IFW (binarycreator)" "command -v binarycreator >/dev/null 2>&1"
    
    # CPack
    run_test "CPack" "command -v cpack >/dev/null 2>&1"
}

# Test CMake packaging targets
test_cmake_targets() {
    print_info "Testing CMake packaging targets..."
    
    if [[ ! -f "CMakeLists.txt" ]]; then
        print_error "Not in a CMake project directory"
        return 1
    fi
    
    # Configure if needed
    if [[ ! -d "build" ]]; then
        print_info "Configuring CMake project..."
        cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release >/dev/null 2>&1
    fi
    
    # Test if packaging targets are available
    local targets=(
        "package_all"
        "package_platform"
        "package_portable"
        "package_source"
    )
    
    for target in "${targets[@]}"; do
        if cmake --build build --target help 2>/dev/null | grep -q "$target"; then
            run_test "CMake target: $target" "true"
        else
            run_test "CMake target: $target" "false"
        fi
    done
    
    # Platform-specific targets
    case "$PLATFORM" in
        "linux")
            local linux_targets=("package_deb" "package_rpm" "package_appimage" "package_snap" "package_flatpak")
            for target in "${linux_targets[@]}"; do
                if cmake --build build --target help 2>/dev/null | grep -q "$target"; then
                    run_test "CMake target: $target" "true"
                else
                    run_test "CMake target: $target" "false"
                fi
            done
            ;;
        "windows")
            local windows_targets=("package_nsis" "package_msi" "package_chocolatey" "package_winget")
            for target in "${windows_targets[@]}"; do
                if cmake --build build --target help 2>/dev/null | grep -q "$target"; then
                    run_test "CMake target: $target" "true"
                else
                    run_test "CMake target: $target" "false"
                fi
            done
            ;;
        "macos")
            local macos_targets=("package_dmg" "package_pkg" "package_homebrew" "package_macports")
            for target in "${macos_targets[@]}"; do
                if cmake --build build --target help 2>/dev/null | grep -q "$target"; then
                    run_test "CMake target: $target" "true"
                else
                    run_test "CMake target: $target" "false"
                fi
            done
            ;;
    esac
}

# Generate packaging report
generate_report() {
    print_info ""
    print_info "Packaging Validation Report"
    print_info "=========================="
    print_info "Platform: $PLATFORM ($DISTRO)"
    print_info "Total tests: $TESTS_TOTAL"
    print_success "Available tools: $TESTS_PASSED"
    print_warning "Missing tools: $TESTS_FAILED"
    
    local coverage=$((TESTS_PASSED * 100 / TESTS_TOTAL))
    print_info "Coverage: ${coverage}%"
    
    if [[ $coverage -ge 80 ]]; then
        print_success "Excellent packaging tool coverage!"
    elif [[ $coverage -ge 60 ]]; then
        print_info "Good packaging tool coverage"
    elif [[ $coverage -ge 40 ]]; then
        print_warning "Moderate packaging tool coverage"
    else
        print_error "Low packaging tool coverage - consider installing more tools"
    fi
    
    print_info ""
    print_info "Recommendations:"
    
    case "$PLATFORM" in
        "linux")
            if ! command -v linuxdeploy >/dev/null 2>&1; then
                print_info "- Install linuxdeploy for AppImage packaging"
            fi
            if ! command -v snapcraft >/dev/null 2>&1; then
                print_info "- Install snapcraft for Snap packaging"
            fi
            if ! command -v flatpak-builder >/dev/null 2>&1; then
                print_info "- Install flatpak-builder for Flatpak packaging"
            fi
            ;;
        "windows")
            if ! command -v makensis >/dev/null 2>&1; then
                print_info "- Install NSIS for Windows installers"
            fi
            if ! command -v candle >/dev/null 2>&1; then
                print_info "- Install WiX Toolset for MSI installers"
            fi
            ;;
        "macos")
            if ! command -v create-dmg >/dev/null 2>&1; then
                print_info "- Install create-dmg for enhanced DMG creation"
            fi
            if ! command -v brew >/dev/null 2>&1; then
                print_info "- Install Homebrew for package management"
            fi
            ;;
    esac
    
    if ! command -v docker >/dev/null 2>&1; then
        print_info "- Install Docker for container packaging"
    fi
}

# Main function
main() {
    print_info "Starting packaging validation for qt-simple-template"
    print_info "====================================================="
    
    # Detect platform
    detect_platform
    
    # Test platform-specific tools
    case "$PLATFORM" in
        "linux")
            test_linux_packaging
            ;;
        "windows")
            test_windows_packaging
            ;;
        "macos")
            test_macos_packaging
            ;;
    esac
    
    # Test cross-platform tools
    test_cross_platform_tools
    
    # Test CMake targets
    test_cmake_targets
    
    # Generate report
    generate_report
    
    # Exit with appropriate code
    if [[ $TESTS_FAILED -eq 0 ]]; then
        exit 0
    else
        exit 1
    fi
}

# Run main function
main "$@"
