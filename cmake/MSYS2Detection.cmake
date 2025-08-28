# MSYS2 Detection and Package Management for qt-simple-template
# This module provides functions to detect MSYS2 environment and check package availability

# Initialize MSYS2 detection variables
set(MSYS2_DETECTED FALSE CACHE BOOL "Whether MSYS2 environment was detected")
set(MSYS2_ENVIRONMENT "" CACHE STRING "MSYS2 environment type (MINGW64, UCRT64, CLANG64, etc.)")
set(MSYS2_PACKAGES_AVAILABLE FALSE CACHE BOOL "Whether required MSYS2 packages are available")
set(MSYS2_QT6_AVAILABLE FALSE CACHE BOOL "Whether Qt6 packages are available in MSYS2")

# Function to detect MSYS2 environment
function(detect_msys2_environment)
    # Check if we're in an MSYS2 environment
    if(DEFINED ENV{MSYSTEM})
        set(MSYS2_DETECTED TRUE CACHE BOOL "Whether MSYS2 environment was detected" FORCE)
        set(MSYS2_ENVIRONMENT "$ENV{MSYSTEM}" CACHE STRING "MSYS2 environment type" FORCE)
        
        message(STATUS "MSYS2 environment detected: ${MSYS2_ENVIRONMENT}")
        
        # Additional validation - check for MSYS2 specific paths
        if(EXISTS "$ENV{MSYSTEM_PREFIX}")
            message(STATUS "MSYS2 prefix found: $ENV{MSYSTEM_PREFIX}")
        endif()
        
        # Set platform-specific variables
        if(MSYS2_ENVIRONMENT STREQUAL "MINGW64")
            set(MSYS2_PACKAGE_PREFIX "mingw-w64-x86_64" CACHE STRING "MSYS2 package prefix" FORCE)
            set(MSYS2_ARCH "x86_64" CACHE STRING "MSYS2 architecture" FORCE)
        elseif(MSYS2_ENVIRONMENT STREQUAL "MINGW32")
            set(MSYS2_PACKAGE_PREFIX "mingw-w64-i686" CACHE STRING "MSYS2 package prefix" FORCE)
            set(MSYS2_ARCH "i686" CACHE STRING "MSYS2 architecture" FORCE)
        elseif(MSYS2_ENVIRONMENT STREQUAL "UCRT64")
            set(MSYS2_PACKAGE_PREFIX "mingw-w64-ucrt-x86_64" CACHE STRING "MSYS2 package prefix" FORCE)
            set(MSYS2_ARCH "x86_64" CACHE STRING "MSYS2 architecture" FORCE)
        elseif(MSYS2_ENVIRONMENT STREQUAL "CLANG64")
            set(MSYS2_PACKAGE_PREFIX "mingw-w64-clang-x86_64" CACHE STRING "MSYS2 package prefix" FORCE)
            set(MSYS2_ARCH "x86_64" CACHE STRING "MSYS2 architecture" FORCE)
        elseif(MSYS2_ENVIRONMENT STREQUAL "CLANG32")
            set(MSYS2_PACKAGE_PREFIX "mingw-w64-clang-i686" CACHE STRING "MSYS2 package prefix" FORCE)
            set(MSYS2_ARCH "i686" CACHE STRING "MSYS2 architecture" FORCE)
        elseif(MSYS2_ENVIRONMENT STREQUAL "CLANGARM64")
            set(MSYS2_PACKAGE_PREFIX "mingw-w64-clang-aarch64" CACHE STRING "MSYS2 package prefix" FORCE)
            set(MSYS2_ARCH "aarch64" CACHE STRING "MSYS2 architecture" FORCE)
        else()
            message(WARNING "Unknown MSYS2 environment: ${MSYS2_ENVIRONMENT}")
            set(MSYS2_PACKAGE_PREFIX "" CACHE STRING "MSYS2 package prefix" FORCE)
            set(MSYS2_ARCH "" CACHE STRING "MSYS2 architecture" FORCE)
        endif()
        
    else()
        set(MSYS2_DETECTED FALSE CACHE BOOL "Whether MSYS2 environment was detected" FORCE)
        set(MSYS2_ENVIRONMENT "" CACHE STRING "MSYS2 environment type" FORCE)
        message(STATUS "MSYS2 environment not detected")
    endif()
endfunction()

# Function to check if a specific MSYS2 package is installed
function(check_msys2_package PACKAGE_NAME RESULT_VAR)
    if(NOT MSYS2_DETECTED)
        set(${RESULT_VAR} FALSE PARENT_SCOPE)
        return()
    endif()
    
    # Try to find pacman
    find_program(PACMAN_EXECUTABLE pacman
        HINTS "$ENV{MSYSTEM_PREFIX}/bin" "/usr/bin"
        DOC "MSYS2 pacman package manager"
    )
    
    if(PACMAN_EXECUTABLE)
        # Check if package is installed
        execute_process(
            COMMAND ${PACMAN_EXECUTABLE} -Q ${PACKAGE_NAME}
            RESULT_VARIABLE PACMAN_RESULT
            OUTPUT_QUIET
            ERROR_QUIET
        )
        
        if(PACMAN_RESULT EQUAL 0)
            set(${RESULT_VAR} TRUE PARENT_SCOPE)
            message(STATUS "MSYS2 package found: ${PACKAGE_NAME}")
        else()
            set(${RESULT_VAR} FALSE PARENT_SCOPE)
            message(STATUS "MSYS2 package not found: ${PACKAGE_NAME}")
        endif()
    else()
        message(WARNING "pacman not found, cannot check MSYS2 packages")
        set(${RESULT_VAR} FALSE PARENT_SCOPE)
    endif()
endfunction()

# Function to check specific Qt6 component availability in MSYS2
function(check_msys2_qt6_component COMPONENT RESULT_VAR)
    if(NOT MSYS2_DETECTED)
        set(${RESULT_VAR} FALSE PARENT_SCOPE)
        return()
    endif()

    # Map Qt6 components to MSYS2 package names
    set(COMPONENT_PACKAGE "")
    if(COMPONENT STREQUAL "Core" OR COMPONENT STREQUAL "Gui" OR COMPONENT STREQUAL "Widgets")
        set(COMPONENT_PACKAGE "${MSYS2_PACKAGE_PREFIX}-qt6-base")
    elseif(COMPONENT STREQUAL "Svg")
        set(COMPONENT_PACKAGE "${MSYS2_PACKAGE_PREFIX}-qt6-svg")
    elseif(COMPONENT STREQUAL "LinguistTools")
        set(COMPONENT_PACKAGE "${MSYS2_PACKAGE_PREFIX}-qt6-tools")
    elseif(COMPONENT STREQUAL "Test")
        set(COMPONENT_PACKAGE "${MSYS2_PACKAGE_PREFIX}-qt6-base")  # Test is included in base
    elseif(COMPONENT STREQUAL "Network")
        set(COMPONENT_PACKAGE "${MSYS2_PACKAGE_PREFIX}-qt6-base")  # Network is included in base
    elseif(COMPONENT STREQUAL "Concurrent")
        set(COMPONENT_PACKAGE "${MSYS2_PACKAGE_PREFIX}-qt6-base")  # Concurrent is included in base
    elseif(COMPONENT STREQUAL "Sql")
        set(COMPONENT_PACKAGE "${MSYS2_PACKAGE_PREFIX}-qt6-base")  # Sql is included in base
    elseif(COMPONENT STREQUAL "OpenGL")
        set(COMPONENT_PACKAGE "${MSYS2_PACKAGE_PREFIX}-qt6-base")  # OpenGL is included in base
    elseif(COMPONENT STREQUAL "PrintSupport")
        set(COMPONENT_PACKAGE "${MSYS2_PACKAGE_PREFIX}-qt6-base")  # PrintSupport is included in base
    else()
        # For other components, try to map them to package names
        string(TOLOWER ${COMPONENT} COMPONENT_LOWER)
        set(COMPONENT_PACKAGE "${MSYS2_PACKAGE_PREFIX}-qt6-${COMPONENT_LOWER}")
    endif()

    if(COMPONENT_PACKAGE)
        check_msys2_package(${COMPONENT_PACKAGE} PACKAGE_AVAILABLE)
        set(${RESULT_VAR} ${PACKAGE_AVAILABLE} PARENT_SCOPE)
    else()
        set(${RESULT_VAR} FALSE PARENT_SCOPE)
    endif()
endfunction()

# Function to check Qt6 availability in MSYS2
function(check_msys2_qt6_availability)
    if(NOT MSYS2_DETECTED)
        set(MSYS2_QT6_AVAILABLE FALSE CACHE BOOL "Whether Qt6 packages are available in MSYS2" FORCE)
        return()
    endif()

    # List of required Qt6 packages
    set(QT6_PACKAGES
        "${MSYS2_PACKAGE_PREFIX}-qt6-base"
        "${MSYS2_PACKAGE_PREFIX}-qt6-svg"
        "${MSYS2_PACKAGE_PREFIX}-qt6-tools"
    )

    set(ALL_PACKAGES_AVAILABLE TRUE)
    set(MISSING_PACKAGES "")

    foreach(PACKAGE ${QT6_PACKAGES})
        check_msys2_package(${PACKAGE} PACKAGE_AVAILABLE)
        if(NOT PACKAGE_AVAILABLE)
            set(ALL_PACKAGES_AVAILABLE FALSE)
            list(APPEND MISSING_PACKAGES ${PACKAGE})
            message(STATUS "Missing Qt6 package: ${PACKAGE}")
        endif()
    endforeach()

    set(MSYS2_QT6_AVAILABLE ${ALL_PACKAGES_AVAILABLE} CACHE BOOL "Whether Qt6 packages are available in MSYS2" FORCE)
    set(MSYS2_MISSING_PACKAGES "${MISSING_PACKAGES}" CACHE STRING "List of missing MSYS2 packages" FORCE)

    if(MSYS2_QT6_AVAILABLE)
        message(STATUS "All required Qt6 packages are available in MSYS2")
    else()
        message(STATUS "Some Qt6 packages are missing in MSYS2: ${MISSING_PACKAGES}")
        message(STATUS "Install missing packages with: pacman -S ${MISSING_PACKAGES}")
    endif()
endfunction()

# Function to check if MSYS2 packages can be installed
function(check_msys2_package_installable PACKAGE_NAME RESULT_VAR)
    if(NOT MSYS2_DETECTED)
        set(${RESULT_VAR} FALSE PARENT_SCOPE)
        return()
    endif()

    # Try to find pacman
    find_program(PACMAN_EXECUTABLE pacman
        HINTS "$ENV{MSYSTEM_PREFIX}/bin" "/usr/bin"
        DOC "MSYS2 pacman package manager"
    )

    if(PACMAN_EXECUTABLE)
        # Check if package is available in repositories
        execute_process(
            COMMAND ${PACMAN_EXECUTABLE} -Si ${PACKAGE_NAME}
            RESULT_VARIABLE PACMAN_RESULT
            OUTPUT_QUIET
            ERROR_QUIET
        )

        if(PACMAN_RESULT EQUAL 0)
            set(${RESULT_VAR} TRUE PARENT_SCOPE)
            message(STATUS "MSYS2 package is installable: ${PACKAGE_NAME}")
        else()
            set(${RESULT_VAR} FALSE PARENT_SCOPE)
            message(STATUS "MSYS2 package is not available in repositories: ${PACKAGE_NAME}")
        endif()
    else()
        message(WARNING "pacman not found, cannot check MSYS2 package availability")
        set(${RESULT_VAR} FALSE PARENT_SCOPE)
    endif()
endfunction()

# Function to suggest MSYS2 package installation
function(suggest_msys2_package_installation)
    if(NOT MSYS2_DETECTED OR MSYS2_QT6_AVAILABLE)
        return()
    endif()

    message(STATUS "")
    message(STATUS "=== MSYS2 Package Installation Suggestion ===")
    message(STATUS "To install missing Qt6 packages, run:")
    message(STATUS "  pacman -S ${MSYS2_MISSING_PACKAGES}")
    message(STATUS "")
    message(STATUS "Or use the build script with --install-deps:")
    message(STATUS "  ./scripts/build_msys2.sh --install-deps")
    message(STATUS "==============================================")
    message(STATUS "")
endfunction()

# Function to get MSYS2 Qt6 installation path
function(get_msys2_qt6_path RESULT_VAR)
    if(NOT MSYS2_DETECTED OR NOT MSYS2_QT6_AVAILABLE)
        set(${RESULT_VAR} "" PARENT_SCOPE)
        return()
    endif()
    
    # Try to find Qt6 installation path
    set(QT6_POSSIBLE_PATHS
        "$ENV{MSYSTEM_PREFIX}/lib/cmake/Qt6"
        "$ENV{MSYSTEM_PREFIX}/share/qt6"
        "$ENV{MSYSTEM_PREFIX}/qt6"
    )
    
    foreach(PATH ${QT6_POSSIBLE_PATHS})
        if(EXISTS "${PATH}")
            set(${RESULT_VAR} "${PATH}" PARENT_SCOPE)
            message(STATUS "Found MSYS2 Qt6 path: ${PATH}")
            return()
        endif()
    endforeach()
    
    # Fallback to MSYSTEM_PREFIX
    set(${RESULT_VAR} "$ENV{MSYSTEM_PREFIX}" PARENT_SCOPE)
    message(STATUS "Using MSYS2 prefix as Qt6 path: $ENV{MSYSTEM_PREFIX}")
endfunction()

# Function to detect and configure MSYS2 compiler
function(configure_msys2_compiler)
    if(NOT MSYS2_DETECTED)
        return()
    endif()

    message(STATUS "Configuring MSYS2 compiler for environment: ${MSYS2_ENVIRONMENT}")

    # Set compiler-specific variables based on MSYS2 environment
    if(MSYS2_ENVIRONMENT STREQUAL "MINGW64" OR MSYS2_ENVIRONMENT STREQUAL "MINGW32")
        set(MSYS2_COMPILER_TYPE "GCC" CACHE STRING "MSYS2 compiler type" FORCE)
        set(MSYS2_TOOLCHAIN "MinGW" CACHE STRING "MSYS2 toolchain" FORCE)

        # Set MinGW-specific compiler flags
        if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
            # Enable modern C++ features
            add_compile_options(-std=c++20)
            # Optimize for size and speed
            add_compile_options($<$<CONFIG:Release>:-O2>)
            add_compile_options($<$<CONFIG:Debug>:-Og>)
            # Enable debugging information
            add_compile_options($<$<CONFIG:Debug>:-g>)
        endif()

    elseif(MSYS2_ENVIRONMENT STREQUAL "UCRT64")
        set(MSYS2_COMPILER_TYPE "GCC" CACHE STRING "MSYS2 compiler type" FORCE)
        set(MSYS2_TOOLCHAIN "UCRT" CACHE STRING "MSYS2 toolchain" FORCE)

        # UCRT-specific settings
        add_definitions(-D_UCRT)
        if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
            add_compile_options(-std=c++20)
            add_compile_options($<$<CONFIG:Release>:-O2>)
            add_compile_options($<$<CONFIG:Debug>:-Og>)
            add_compile_options($<$<CONFIG:Debug>:-g>)
        endif()

    elseif(MSYS2_ENVIRONMENT STREQUAL "CLANG64" OR MSYS2_ENVIRONMENT STREQUAL "CLANG32" OR MSYS2_ENVIRONMENT STREQUAL "CLANGARM64")
        set(MSYS2_COMPILER_TYPE "Clang" CACHE STRING "MSYS2 compiler type" FORCE)
        set(MSYS2_TOOLCHAIN "Clang" CACHE STRING "MSYS2 toolchain" FORCE)

        # Clang-specific settings
        if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
            add_compile_options(-std=c++20)
            add_compile_options($<$<CONFIG:Release>:-O2>)
            add_compile_options($<$<CONFIG:Debug>:-Og>)
            add_compile_options($<$<CONFIG:Debug>:-g>)
            # Enable Clang-specific optimizations
            add_compile_options(-fcolor-diagnostics)
        endif()

    else()
        set(MSYS2_COMPILER_TYPE "Unknown" CACHE STRING "MSYS2 compiler type" FORCE)
        set(MSYS2_TOOLCHAIN "Unknown" CACHE STRING "MSYS2 toolchain" FORCE)
        message(WARNING "Unknown MSYS2 environment: ${MSYS2_ENVIRONMENT}")
    endif()

    # Set common MSYS2 compiler flags
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        # Enable additional warnings
        add_compile_options(-Wall -Wextra -Wpedantic)
        # Enable exception handling
        add_compile_options(-fexceptions)
        # Enable RTTI
        add_compile_options(-frtti)
    endif()

    message(STATUS "MSYS2 compiler configured: ${MSYS2_COMPILER_TYPE} (${MSYS2_TOOLCHAIN})")
endfunction()

# Function to setup MSYS2 environment variables for Qt6
function(setup_msys2_qt6_environment)
    if(NOT MSYS2_DETECTED OR NOT MSYS2_QT6_AVAILABLE)
        return()
    endif()

    # Configure compiler first
    configure_msys2_compiler()

    # Set Qt6 specific paths
    get_msys2_qt6_path(QT6_PATH)
    if(QT6_PATH)
        set(Qt6_DIR "${QT6_PATH}" CACHE PATH "Qt6 installation directory" FORCE)
        list(APPEND CMAKE_PREFIX_PATH "${QT6_PATH}")
        list(APPEND CMAKE_PREFIX_PATH "$ENV{MSYSTEM_PREFIX}")
        set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} CACHE STRING "CMake prefix path" FORCE)
    endif()

    # Set additional environment variables
    if(DEFINED ENV{MSYSTEM_PREFIX})
        list(APPEND CMAKE_PROGRAM_PATH "$ENV{MSYSTEM_PREFIX}/bin")
        list(APPEND CMAKE_LIBRARY_PATH "$ENV{MSYSTEM_PREFIX}/lib")
        list(APPEND CMAKE_INCLUDE_PATH "$ENV{MSYSTEM_PREFIX}/include")

        set(CMAKE_PROGRAM_PATH ${CMAKE_PROGRAM_PATH} CACHE STRING "CMake program path" FORCE)
        set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} CACHE STRING "CMake library path" FORCE)
        set(CMAKE_INCLUDE_PATH ${CMAKE_INCLUDE_PATH} CACHE STRING "CMake include path" FORCE)
    endif()

    # Set MSYS2-specific linker flags
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        # Enable proper linking for Windows
        add_link_options(-Wl,--enable-auto-import)
        add_link_options(-Wl,--enable-runtime-pseudo-reloc)
    endif()

    message(STATUS "MSYS2 Qt6 environment configured")
endfunction()

# Main function to initialize MSYS2 detection
function(initialize_msys2_detection)
    message(STATUS "Initializing MSYS2 detection...")
    
    # Detect MSYS2 environment
    detect_msys2_environment()
    
    # Check Qt6 availability if MSYS2 is detected
    if(MSYS2_DETECTED)
        check_msys2_qt6_availability()
        
        # Setup environment if Qt6 is available
        if(MSYS2_QT6_AVAILABLE)
            setup_msys2_qt6_environment()
        endif()
    endif()
    
    # Export variables for use in other CMake files
    set(MSYS2_DETECTED ${MSYS2_DETECTED} PARENT_SCOPE)
    set(MSYS2_ENVIRONMENT ${MSYS2_ENVIRONMENT} PARENT_SCOPE)
    set(MSYS2_QT6_AVAILABLE ${MSYS2_QT6_AVAILABLE} PARENT_SCOPE)
    
    message(STATUS "MSYS2 detection completed")
endfunction()
