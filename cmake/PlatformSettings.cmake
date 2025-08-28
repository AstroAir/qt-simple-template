# Platform-specific settings for qt-simple-template

# Include MSYS2 detection for enhanced platform detection
include(MSYS2Detection)

# Detect platform with MSYS2 awareness
if(WIN32)
    set(PLATFORM_NAME "Windows")
    set(PLATFORM_WINDOWS TRUE)

    # Check if we're in MSYS2 environment
    if(DEFINED ENV{MSYSTEM})
        set(PLATFORM_MSYS2 TRUE)
        set(PLATFORM_NAME "Windows-MSYS2")
        message(STATUS "MSYS2 environment detected: $ENV{MSYSTEM}")
    else()
        set(PLATFORM_MSYS2 FALSE)
    endif()

elseif(APPLE)
    set(PLATFORM_NAME "macOS")
    set(PLATFORM_MACOS TRUE)
    set(PLATFORM_MSYS2 FALSE)
elseif(UNIX)
    set(PLATFORM_NAME "Linux")
    set(PLATFORM_LINUX TRUE)
    set(PLATFORM_MSYS2 FALSE)
else()
    set(PLATFORM_NAME "Unknown")
    set(PLATFORM_MSYS2 FALSE)
endif()

message(STATUS "Building for platform: ${PLATFORM_NAME}")
if(PLATFORM_MSYS2)
    message(STATUS "MSYS2 environment: $ENV{MSYSTEM}")
endif()

# Windows-specific settings
if(PLATFORM_WINDOWS)
    # Set Windows version requirements
    set(CMAKE_SYSTEM_VERSION "10.0")

    # Enable Unicode
    add_definitions(-DUNICODE -D_UNICODE)

    # MSYS2-specific settings
    if(PLATFORM_MSYS2)
        # MSYS2 uses MinGW toolchain, not MSVC
        if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
            message(STATUS "Using MinGW compiler in MSYS2")
            # Enable additional warnings for GCC
            add_compile_options(-Wall -Wextra)
            # Set proper exception handling
            add_compile_options(-fexceptions)
        elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
            message(STATUS "Using Clang compiler in MSYS2")
            # Enable additional warnings for Clang
            add_compile_options(-Wall -Wextra)
        endif()

        # MSYS2-specific compile definitions
        add_definitions(-DMSYS2_BUILD)

        # Set proper library search paths for MSYS2
        if(DEFINED ENV{MSYSTEM_PREFIX})
            link_directories("$ENV{MSYSTEM_PREFIX}/lib")
        endif()

    else()
        # Native Windows (MSVC) settings
        if(MSVC)
            set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")
        endif()
    endif()

    # Common Windows compile definitions
    add_definitions(-DWIN32_LEAN_AND_MEAN -DNOMINMAX)

    # Set executable properties
    set(CMAKE_WIN32_EXECUTABLE TRUE)
endif()

# macOS-specific settings
if(PLATFORM_MACOS)
    # Set minimum macOS version
    set(CMAKE_OSX_DEPLOYMENT_TARGET "10.15" CACHE STRING "Minimum macOS version")
    
    # Set bundle properties
    set(CMAKE_MACOSX_BUNDLE TRUE)
    set(CMAKE_MACOSX_RPATH TRUE)
    
    # Framework search paths
    set(CMAKE_FRAMEWORK_PATH 
        /System/Library/Frameworks
        /Library/Frameworks
        ${CMAKE_FRAMEWORK_PATH}
    )
endif()

# Linux-specific settings
if(PLATFORM_LINUX)
    # Set RPATH for shared libraries
    set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
    set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
    set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
    
    # Enable position independent code
    set(CMAKE_POSITION_INDEPENDENT_CODE ON)
endif()

# Cross-platform settings
if(UNIX OR PLATFORM_MSYS2)
    # Enable colored output for Ninja
    if(CMAKE_GENERATOR STREQUAL "Ninja")
        add_compile_options(-fdiagnostics-color=always)
    endif()

    # MSYS2-specific Unix-like settings
    if(PLATFORM_MSYS2)
        # Enable POSIX-like behavior in MSYS2
        add_definitions(-D_POSIX_C_SOURCE=200809L)

        # Set proper RPATH for MSYS2 shared libraries
        set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
        set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
        if(DEFINED ENV{MSYSTEM_PREFIX})
            set(CMAKE_INSTALL_RPATH "$ENV{MSYSTEM_PREFIX}/lib")
        endif()
    endif()
endif()

# Set output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# Multi-config generators
if(CMAKE_CONFIGURATION_TYPES)
    foreach(config ${CMAKE_CONFIGURATION_TYPES})
        string(TOUPPER ${config} config_upper)
        set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${config_upper} ${CMAKE_BINARY_DIR}/bin/${config})
        set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${config_upper} ${CMAKE_BINARY_DIR}/lib/${config})
        set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${config_upper} ${CMAKE_BINARY_DIR}/lib/${config})
    endforeach()
endif()

# Platform-specific Qt deployment
if(PLATFORM_WINDOWS)
    if(PLATFORM_MSYS2)
        # MSYS2 deployment - use windeployqt from MSYS2 Qt installation
        if(DEFINED ENV{MSYSTEM_PREFIX})
            find_program(WINDEPLOYQT_EXECUTABLE windeployqt
                HINTS "$ENV{MSYSTEM_PREFIX}/bin"
                DOC "MSYS2 windeployqt executable")
        else()
            find_program(WINDEPLOYQT_EXECUTABLE windeployqt)
        endif()

        if(WINDEPLOYQT_EXECUTABLE)
            message(STATUS "Found MSYS2 windeployqt: ${WINDEPLOYQT_EXECUTABLE}")
        else()
            message(WARNING "windeployqt not found in MSYS2 environment")
        endif()
    else()
        # Native Windows deployment will be handled in app/CMakeLists.txt with windeployqt
        find_program(WINDEPLOYQT_EXECUTABLE windeployqt HINTS ${Qt6_DIR}/../../../bin)
        if(WINDEPLOYQT_EXECUTABLE)
            message(STATUS "Found windeployqt: ${WINDEPLOYQT_EXECUTABLE}")
        endif()
    endif()

elseif(PLATFORM_MACOS)
    # macOS deployment will be handled with macdeployqt
    find_program(MACDEPLOYQT_EXECUTABLE macdeployqt HINTS ${Qt6_DIR}/../../../bin)
    if(MACDEPLOYQT_EXECUTABLE)
        message(STATUS "Found macdeployqt: ${MACDEPLOYQT_EXECUTABLE}")
    endif()

elseif(PLATFORM_LINUX)
    # Linux deployment will be handled with linuxdeployqt or similar
    find_program(LINUXDEPLOYQT_EXECUTABLE linuxdeployqt)
    if(LINUXDEPLOYQT_EXECUTABLE)
        message(STATUS "Found linuxdeployqt: ${LINUXDEPLOYQT_EXECUTABLE}")
    endif()
endif()

# Export platform variables for use in other CMake files
set(PLATFORM_NAME ${PLATFORM_NAME} CACHE STRING "Platform name" FORCE)
set(PLATFORM_WINDOWS ${PLATFORM_WINDOWS} CACHE BOOL "Windows platform" FORCE)
set(PLATFORM_MACOS ${PLATFORM_MACOS} CACHE BOOL "macOS platform" FORCE)
set(PLATFORM_LINUX ${PLATFORM_LINUX} CACHE BOOL "Linux platform" FORCE)
set(PLATFORM_MSYS2 ${PLATFORM_MSYS2} CACHE BOOL "MSYS2 platform" FORCE)
