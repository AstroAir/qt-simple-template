#!/bin/bash
# MSYS2 build script for qt-simple-template
# This script sets up and builds the project using MSYS2 on Windows

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

# Default values
BUILD_TYPE="Debug"
BUILD_DIR=""
PRESET=""
INSTALL_DEPS=false
CONFIGURE_ONLY=false
RUN_TESTS=false
CLEAN=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --build-type)
            BUILD_TYPE="$2"
            shift 2
            ;;
        --build-dir)
            BUILD_DIR="$2"
            shift 2
            ;;
        --preset)
            PRESET="$2"
            shift 2
            ;;
        --install-deps)
            INSTALL_DEPS=true
            shift
            ;;
        --configure-only)
            CONFIGURE_ONLY=true
            shift
            ;;
        --test)
            RUN_TESTS=true
            shift
            ;;
        --clean)
            CLEAN=true
            shift
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --build-type TYPE    Build type (Debug|Release) [default: Debug]"
            echo "  --build-dir DIR      Build directory [default: build/MSYS2-TYPE]"
            echo "  --preset PRESET      CMake preset to use"
            echo "  --install-deps       Install MSYS2 dependencies"
            echo "  --configure-only     Only configure, do not build"
            echo "  --test               Run tests after building"
            echo "  --clean              Clean build directory before building"
            echo "  --help               Show this help message"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Check if we're running in MSYS2
check_msys2() {
    if [[ -z "$MSYSTEM" ]]; then
        print_error "This script must be run in MSYS2 environment"
        print_info "Please start MSYS2 and run this script from there"
        exit 1
    fi
    print_info "Running in MSYS2 environment: $MSYSTEM"
}

# Check if required packages are installed
check_required_packages() {
    print_info "Checking required packages..."

    local missing_packages=()
    local required_base_packages=(
        "base-devel"
        "git"
        "cmake"
        "ninja"
        "pkg-config"
    )

    # Check base packages
    for package in "${required_base_packages[@]}"; do
        if ! pacman -Q "$package" >/dev/null 2>&1; then
            missing_packages+=("$package")
        fi
    done

    # Check Qt6 packages based on MSYS2 environment
    local qt6_packages=()
    case "$MSYSTEM" in
        MINGW64)
            qt6_packages=(
                "mingw-w64-x86_64-toolchain"
                "mingw-w64-x86_64-qt6-base"
                "mingw-w64-x86_64-qt6-svg"
                "mingw-w64-x86_64-qt6-tools"
            )
            ;;
        MINGW32)
            qt6_packages=(
                "mingw-w64-i686-toolchain"
                "mingw-w64-i686-qt6-base"
                "mingw-w64-i686-qt6-svg"
                "mingw-w64-i686-qt6-tools"
            )
            ;;
        UCRT64)
            qt6_packages=(
                "mingw-w64-ucrt-x86_64-toolchain"
                "mingw-w64-ucrt-x86_64-qt6-base"
                "mingw-w64-ucrt-x86_64-qt6-svg"
                "mingw-w64-ucrt-x86_64-qt6-tools"
            )
            ;;
        CLANG64)
            qt6_packages=(
                "mingw-w64-clang-x86_64-toolchain"
                "mingw-w64-clang-x86_64-qt6-base"
                "mingw-w64-clang-x86_64-qt6-svg"
                "mingw-w64-clang-x86_64-qt6-tools"
            )
            ;;
        CLANG32)
            qt6_packages=(
                "mingw-w64-clang-i686-toolchain"
                "mingw-w64-clang-i686-qt6-base"
                "mingw-w64-clang-i686-qt6-svg"
                "mingw-w64-clang-i686-qt6-tools"
            )
            ;;
        CLANGARM64)
            qt6_packages=(
                "mingw-w64-clang-aarch64-toolchain"
                "mingw-w64-clang-aarch64-qt6-base"
                "mingw-w64-clang-aarch64-qt6-svg"
                "mingw-w64-clang-aarch64-qt6-tools"
            )
            ;;
        *)
            print_error "Unsupported MSYS2 environment: $MSYSTEM"
            exit 1
            ;;
    esac

    # Check Qt6 packages
    for package in "${qt6_packages[@]}"; do
        if ! pacman -Q "$package" >/dev/null 2>&1; then
            missing_packages+=("$package")
        fi
    done

    if [ ${#missing_packages[@]} -eq 0 ]; then
        print_success "All required packages are installed"
        return 0
    else
        print_warning "Missing packages: ${missing_packages[*]}"
        return 1
    fi
}

# Install MSYS2 dependencies
install_dependencies() {
    print_info "Installing MSYS2 dependencies..."

    # Update package database
    pacman -Sy --noconfirm

    # Install base development tools
    pacman -S --needed --noconfirm \
        base-devel \
        git \
        cmake \
        ninja \
        pkg-config

    # Install Qt6 packages based on MSYS2 environment
    case "$MSYSTEM" in
        MINGW64)
            print_info "Installing Qt6 for MinGW64..."
            pacman -S --needed --noconfirm \
                mingw-w64-x86_64-toolchain \
                mingw-w64-x86_64-qt6-base \
                mingw-w64-x86_64-qt6-svg \
                mingw-w64-x86_64-qt6-tools
            ;;
        MINGW32)
            print_info "Installing Qt6 for MinGW32..."
            pacman -S --needed --noconfirm \
                mingw-w64-i686-toolchain \
                mingw-w64-i686-qt6-base \
                mingw-w64-i686-qt6-svg \
                mingw-w64-i686-qt6-tools
            ;;
        UCRT64)
            print_info "Installing Qt6 for UCRT64..."
            pacman -S --needed --noconfirm \
                mingw-w64-ucrt-x86_64-toolchain \
                mingw-w64-ucrt-x86_64-qt6-base \
                mingw-w64-ucrt-x86_64-qt6-svg \
                mingw-w64-ucrt-x86_64-qt6-tools
            ;;
        CLANG64)
            print_info "Installing Qt6 for Clang64..."
            pacman -S --needed --noconfirm \
                mingw-w64-clang-x86_64-toolchain \
                mingw-w64-clang-x86_64-qt6-base \
                mingw-w64-clang-x86_64-qt6-svg \
                mingw-w64-clang-x86_64-qt6-tools
            ;;
        CLANG32)
            print_info "Installing Qt6 for Clang32..."
            pacman -S --needed --noconfirm \
                mingw-w64-clang-i686-toolchain \
                mingw-w64-clang-i686-qt6-base \
                mingw-w64-clang-i686-qt6-svg \
                mingw-w64-clang-i686-qt6-tools
            ;;
        CLANGARM64)
            print_info "Installing Qt6 for ClangARM64..."
            pacman -S --needed --noconfirm \
                mingw-w64-clang-aarch64-toolchain \
                mingw-w64-clang-aarch64-qt6-base \
                mingw-w64-clang-aarch64-qt6-svg \
                mingw-w64-clang-aarch64-qt6-tools
            ;;
        *)
            print_error "Unsupported MSYS2 environment: $MSYSTEM"
            exit 1
            ;;
    esac

    print_success "Dependencies installed successfully"
}

# Check for fallback package managers
check_fallback_options() {
    print_info "Checking fallback package manager options..."

    local fallback_available=false

    # Check for vcpkg
    if [[ -n "$VCPKG_ROOT" ]] && [[ -f "$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake" ]]; then
        print_info "vcpkg is available as fallback: $VCPKG_ROOT"
        fallback_available=true
    fi

    # Check for Conan
    if command -v conan >/dev/null 2>&1; then
        print_info "Conan is available as fallback"
        fallback_available=true
    fi

    # Check for vcpkg.json
    if [[ -f "vcpkg.json" ]]; then
        print_info "vcpkg manifest found: vcpkg.json"
        fallback_available=true
    fi

    # Check for conanfile
    if [[ -f "conanfile.py" ]] || [[ -f "conanfile.txt" ]]; then
        print_info "Conan manifest found"
        fallback_available=true
    fi

    if [[ "$fallback_available" == true ]]; then
        print_info "Fallback package managers are available"
        return 0
    else
        print_warning "No fallback package managers detected"
        return 1
    fi
}

# Configure CMake with package manager priority
configure_cmake() {
    print_info "Configuring CMake with package manager priority..."

    # Determine build directory
    if [[ -z "$BUILD_DIR" ]]; then
        BUILD_DIR="build/MSYS2-$BUILD_TYPE"
    fi

    # Determine preset
    if [[ -z "$PRESET" ]]; then
        PRESET="MSYS2-$BUILD_TYPE"
    fi

    # Create build directory
    mkdir -p "$BUILD_DIR"

    # Check if MSYS2 packages are available
    if check_required_packages; then
        print_info "Using MSYS2 packages (priority 1)"
        CMAKE_ARGS="-DFORCE_PACKAGE_MANAGER=MSYS2"
    else
        print_warning "MSYS2 packages not available, checking fallbacks..."

        if check_fallback_options; then
            print_info "Using automatic package manager fallback"
            CMAKE_ARGS=""  # Let CMake auto-detect
        else
            print_warning "No package managers available, using system packages"
            CMAKE_ARGS="-DFORCE_PACKAGE_MANAGER=SYSTEM"
        fi
    fi

    # Configure with preset if available
    if [[ -f "CMakePresets-extended.json" ]]; then
        print_info "Using CMake preset: $PRESET"
        if [[ -n "$CMAKE_ARGS" ]]; then
            cmake --preset "$PRESET" --preset-file CMakePresets-extended.json $CMAKE_ARGS
        else
            cmake --preset "$PRESET" --preset-file CMakePresets-extended.json
        fi
    else
        print_info "Using manual CMake configuration"
        cmake -S . -B "$BUILD_DIR" \
            -G Ninja \
            -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
            -DBUILD_TESTING=ON \
            -DBUILD_DOCS=ON \
            $CMAKE_ARGS
    fi

    print_success "CMake configuration completed"
}

# Build project
build_project() {
    print_info "Building project..."
    
    if [[ -f "CMakePresets-extended.json" ]]; then
        cmake --build --preset "$PRESET" --preset-file CMakePresets-extended.json
    else
        cmake --build "$BUILD_DIR"
    fi
    
    print_success "Build completed successfully"
}

# Run tests
run_tests() {
    print_info "Running tests..."
    
    cd "$BUILD_DIR"
    ctest --output-on-failure --parallel $(nproc)
    cd ..
    
    print_success "Tests completed"
}

# Main execution
main() {
    print_info "Starting MSYS2 build for qt-simple-template"

    # Check MSYS2 environment
    check_msys2

    # Check package availability first
    if ! check_required_packages; then
        if [[ "$INSTALL_DEPS" == true ]]; then
            print_info "Installing missing dependencies..."
            install_dependencies
        else
            print_warning "Some packages are missing. Use --install-deps to install them automatically."
            print_info "Or the build system will attempt to use fallback package managers."

            if ! check_fallback_options; then
                print_error "No fallback package managers available."
                print_info "Please install missing packages manually or use --install-deps"
                exit 1
            fi
        fi
    else
        print_success "All required MSYS2 packages are available"

        # Still install dependencies if explicitly requested
        if [[ "$INSTALL_DEPS" == true ]]; then
            print_info "Updating dependencies as requested..."
            install_dependencies
        fi
    fi

    # Clean if requested
    if [[ "$CLEAN" == true ]] && [[ -n "$BUILD_DIR" ]]; then
        print_info "Cleaning build directory: $BUILD_DIR"
        rm -rf "$BUILD_DIR"
    fi

    # Configure CMake
    configure_cmake

    # Exit if configure-only
    if [[ "$CONFIGURE_ONLY" == true ]]; then
        print_success "Configuration completed"
        exit 0
    fi

    # Build project
    build_project

    # Run tests if requested
    if [[ "$RUN_TESTS" == true ]]; then
        run_tests
    fi

    print_success "MSYS2 build completed successfully!"
    print_info "Executable location: $BUILD_DIR/app/"
}

# Run main function
main "$@"
