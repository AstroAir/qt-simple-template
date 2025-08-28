#!/bin/bash
# Package Manager Validation Script for qt-simple-template
# This script validates the package manager priority system and fallback mechanisms

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
    
    print_test "Running: $test_name"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    if eval "$test_command"; then
        print_success "PASSED: $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        print_error "FAILED: $test_name"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Test MSYS2 environment detection
test_msys2_detection() {
    if [[ -n "$MSYSTEM" ]]; then
        print_info "MSYS2 environment detected: $MSYSTEM"
        return 0
    else
        print_info "MSYS2 environment not detected"
        return 1
    fi
}

# Test MSYS2 package availability
test_msys2_packages() {
    if [[ -z "$MSYSTEM" ]]; then
        print_info "Skipping MSYS2 package test (not in MSYS2 environment)"
        return 0
    fi
    
    local packages_missing=0
    local required_packages=(
        "cmake"
        "ninja"
        "pkg-config"
    )
    
    # Check Qt6 packages based on environment
    case "$MSYSTEM" in
        MINGW64)
            required_packages+=(
                "mingw-w64-x86_64-qt6-base"
                "mingw-w64-x86_64-qt6-svg"
                "mingw-w64-x86_64-qt6-tools"
            )
            ;;
        UCRT64)
            required_packages+=(
                "mingw-w64-ucrt-x86_64-qt6-base"
                "mingw-w64-ucrt-x86_64-qt6-svg"
                "mingw-w64-ucrt-x86_64-qt6-tools"
            )
            ;;
        CLANG64)
            required_packages+=(
                "mingw-w64-clang-x86_64-qt6-base"
                "mingw-w64-clang-x86_64-qt6-svg"
                "mingw-w64-clang-x86_64-qt6-tools"
            )
            ;;
    esac
    
    for package in "${required_packages[@]}"; do
        if ! pacman -Q "$package" >/dev/null 2>&1; then
            print_warning "Missing package: $package"
            packages_missing=$((packages_missing + 1))
        fi
    done
    
    if [[ $packages_missing -eq 0 ]]; then
        print_success "All MSYS2 packages are available"
        return 0
    else
        print_warning "$packages_missing MSYS2 packages are missing"
        return 1
    fi
}

# Test vcpkg availability
test_vcpkg_availability() {
    local vcpkg_available=false
    
    # Check VCPKG_ROOT environment variable
    if [[ -n "$VCPKG_ROOT" ]] && [[ -f "$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake" ]]; then
        print_info "vcpkg found via VCPKG_ROOT: $VCPKG_ROOT"
        vcpkg_available=true
    fi
    
    # Check for vcpkg.json
    if [[ -f "vcpkg.json" ]]; then
        print_info "vcpkg manifest found: vcpkg.json"
        vcpkg_available=true
    fi
    
    if [[ "$vcpkg_available" == true ]]; then
        print_success "vcpkg is available"
        return 0
    else
        print_info "vcpkg is not available"
        return 1
    fi
}

# Test Conan availability
test_conan_availability() {
    local conan_available=false
    
    # Check for Conan executable
    if command -v conan >/dev/null 2>&1; then
        print_info "Conan executable found: $(which conan)"
        conan_available=true
    fi
    
    # Check for conanfile
    if [[ -f "conanfile.py" ]] || [[ -f "conanfile.txt" ]]; then
        print_info "Conan manifest found"
        conan_available=true
    fi
    
    # Check for Conan toolchain
    if [[ -f "build/conan_toolchain.cmake" ]]; then
        print_info "Conan toolchain found"
        conan_available=true
    fi
    
    if [[ "$conan_available" == true ]]; then
        print_success "Conan is available"
        return 0
    else
        print_info "Conan is not available"
        return 1
    fi
}

# Test CMake configuration with different package managers
test_cmake_configuration() {
    local test_build_dir="build/validation-test"
    
    # Clean test directory
    rm -rf "$test_build_dir"
    mkdir -p "$test_build_dir"
    
    print_info "Testing CMake configuration..."
    
    # Test with automatic detection
    if cmake -S . -B "$test_build_dir" -G Ninja -DCMAKE_BUILD_TYPE=Debug >/dev/null 2>&1; then
        print_success "CMake configuration successful with automatic package manager detection"
        
        # Check which package manager was selected
        if [[ -f "$test_build_dir/CMakeCache.txt" ]]; then
            local selected_manager=$(grep "PACKAGE_MANAGER_SELECTED:STRING=" "$test_build_dir/CMakeCache.txt" | cut -d'=' -f2)
            print_info "Selected package manager: $selected_manager"
        fi
        
        # Clean up
        rm -rf "$test_build_dir"
        return 0
    else
        print_error "CMake configuration failed"
        rm -rf "$test_build_dir"
        return 1
    fi
}

# Test forced package manager selection
test_forced_package_manager() {
    local test_build_dir="build/validation-forced"
    local force_manager="$1"
    
    # Clean test directory
    rm -rf "$test_build_dir"
    mkdir -p "$test_build_dir"
    
    print_info "Testing forced package manager: $force_manager"
    
    if cmake -S . -B "$test_build_dir" -G Ninja -DCMAKE_BUILD_TYPE=Debug -DFORCE_PACKAGE_MANAGER="$force_manager" >/dev/null 2>&1; then
        print_success "CMake configuration successful with forced $force_manager"
        rm -rf "$test_build_dir"
        return 0
    else
        print_warning "CMake configuration failed with forced $force_manager (may be expected if not available)"
        rm -rf "$test_build_dir"
        return 1
    fi
}

# Main validation function
main() {
    print_info "Starting package manager validation for qt-simple-template"
    print_info "============================================================"
    
    # Environment detection tests
    run_test "MSYS2 Environment Detection" "test_msys2_detection"
    run_test "MSYS2 Package Availability" "test_msys2_packages"
    run_test "vcpkg Availability" "test_vcpkg_availability"
    run_test "Conan Availability" "test_conan_availability"
    
    # CMake configuration tests
    run_test "CMake Configuration (Auto)" "test_cmake_configuration"
    
    # Test forced package managers
    run_test "Forced SYSTEM packages" "test_forced_package_manager SYSTEM"
    
    if [[ -n "$MSYSTEM" ]]; then
        run_test "Forced MSYS2 packages" "test_forced_package_manager MSYS2"
    fi
    
    if [[ -n "$VCPKG_ROOT" ]] || [[ -f "vcpkg.json" ]]; then
        run_test "Forced vcpkg packages" "test_forced_package_manager VCPKG"
    fi
    
    if command -v conan >/dev/null 2>&1 || [[ -f "conanfile.py" ]] || [[ -f "conanfile.txt" ]]; then
        run_test "Forced Conan packages" "test_forced_package_manager CONAN"
    fi
    
    # Print summary
    print_info ""
    print_info "Validation Summary"
    print_info "=================="
    print_info "Total tests: $TESTS_TOTAL"
    print_success "Passed: $TESTS_PASSED"
    print_error "Failed: $TESTS_FAILED"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        print_success "All validation tests passed!"
        exit 0
    else
        print_error "Some validation tests failed"
        exit 1
    fi
}

# Run main function
main "$@"
