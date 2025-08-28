cmake_minimum_required(VERSION 3.28)

# Project configuration
project(qt_simple_template
    LANGUAGES CXX
    VERSION 0.1.0.0
    DESCRIPTION "A modern Qt6 application template with CMake, vcpkg, and CI/CD"
    HOMEPAGE_URL "https://github.com/your-org/qt-simple-template"
)

# Include custom CMake modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Include helper functions
include(QtHelpers)

# Include package manager priority system
include(PackageManagerPriority)

# Set C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Enable compile commands export for clangd and other tools
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Set default build type
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

# Project options
option(BUILD_TESTING "Build tests" ON)
option(BUILD_DOCS "Build documentation" ON)
option(ENABLE_STATIC_ANALYSIS "Enable static analysis" OFF)
option(ENABLE_SANITIZERS "Enable sanitizers in debug builds" OFF)
option(ENABLE_COVERAGE "Enable code coverage" OFF)
option(USE_CONAN "Use Conan package manager" OFF)
option(USE_MSYS2 "Use MSYS2 package manager" OFF)
option(USE_VCPKG "Use vcpkg package manager" OFF)
option(FORCE_PACKAGE_MANAGER "Force specific package manager (MSYS2, VCPKG, CONAN, SYSTEM)" "")

# Initialize package manager priority system
initialize_package_manager_priority()

# Platform-specific settings
include(PlatformSettings)

# Compiler settings
include(CompilerSettings)

# Qt configuration
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

# Find Qt6 components based on selected package manager
if(USE_CONAN)
    # Conan Qt6 configuration
    find_package(Qt6 REQUIRED COMPONENTS
        Core
        Gui
        Widgets
        Svg
        LinguistTools
    )
elseif(USE_MSYS2)
    # MSYS2 Qt6 configuration - use CONFIG mode for better detection
    find_package(Qt6 REQUIRED COMPONENTS
        Core
        Gui
        Widgets
        Svg
        LinguistTools
        CONFIG
    )
else()
    # vcpkg or system Qt6 configuration
    find_package(Qt6 REQUIRED COMPONENTS
        Core
        Gui
        Widgets
        Svg
        LinguistTools
        CONFIG
    )
endif()

# Qt standard project setup
qt_standard_project_setup(I18N_TRANSLATED_LANGUAGES zh)

# Add subdirectories
add_subdirectory(controls)
add_subdirectory(app)

# Add testing support
if(BUILD_TESTING)
    enable_testing()
    add_subdirectory(tests)
endif()

# Add documentation
if(BUILD_DOCS)
    add_subdirectory(docs)
endif()

# Installation configuration
include(InstallConfig)

# Packaging configuration
include(PackagingConfig)

# Print configuration summary
include(ConfigSummary)
