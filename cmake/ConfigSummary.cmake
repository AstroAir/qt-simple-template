# Configuration summary for qt-simple-template

# Print configuration summary
message(STATUS "")
message(STATUS "=== ${PROJECT_NAME} Configuration Summary ===")
message(STATUS "")

# Project information
message(STATUS "Project Information:")
message(STATUS "  Name:        ${PROJECT_NAME}")
message(STATUS "  Version:     ${PROJECT_VERSION}")
message(STATUS "  Description: ${PROJECT_DESCRIPTION}")
if(PROJECT_HOMEPAGE_URL)
    message(STATUS "  Homepage:    ${PROJECT_HOMEPAGE_URL}")
endif()
message(STATUS "")

# Build configuration
message(STATUS "Build Configuration:")
message(STATUS "  Build Type:     ${CMAKE_BUILD_TYPE}")
message(STATUS "  Source Dir:     ${CMAKE_SOURCE_DIR}")
message(STATUS "  Binary Dir:     ${CMAKE_BINARY_DIR}")
message(STATUS "  Install Prefix: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "")

# Platform information
message(STATUS "Platform Information:")
message(STATUS "  System:      ${CMAKE_SYSTEM_NAME} ${CMAKE_SYSTEM_VERSION}")
message(STATUS "  Processor:   ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS "  Platform:    ${PLATFORM_NAME}")
message(STATUS "")

# Compiler information
message(STATUS "Compiler Information:")
message(STATUS "  Compiler:    ${COMPILER_NAME}")
message(STATUS "  Version:     ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "  Path:        ${CMAKE_CXX_COMPILER}")
message(STATUS "  C++ Standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "")

# Qt information
message(STATUS "Qt Information:")
message(STATUS "  Qt Version:  ${Qt6_VERSION}")
message(STATUS "  Qt Dir:      ${Qt6_DIR}")
message(STATUS "  Components:  Core Gui Widgets Svg LinguistTools")
message(STATUS "")

# Package Manager Priority System
if(DEFINED PACKAGE_MANAGER_SELECTED)
    message(STATUS "Package Manager Priority System:")
    message(STATUS "  Selected:    ${PACKAGE_MANAGER_SELECTED}")
    if(DEFINED PACKAGE_MANAGER_PRIORITY_ORDER)
        message(STATUS "  Priority:    ${PACKAGE_MANAGER_PRIORITY_ORDER}")
    endif()
    if(FORCE_PACKAGE_MANAGER)
        message(STATUS "  Forced:      ${FORCE_PACKAGE_MANAGER}")
    endif()

    # MSYS2 specific information
    if(USE_MSYS2 AND DEFINED MSYS2_ENVIRONMENT)
        message(STATUS "  MSYS2 Env:   ${MSYS2_ENVIRONMENT}")
    endif()

    # vcpkg specific information
    if(USE_VCPKG AND DEFINED VCPKG_TARGET_TRIPLET)
        message(STATUS "  vcpkg Triplet: ${VCPKG_TARGET_TRIPLET}")
    endif()

    message(STATUS "")
else()
    # Legacy vcpkg information for compatibility
    if(DEFINED VCPKG_TOOLCHAIN)
        message(STATUS "vcpkg Information:")
        message(STATUS "  Toolchain:   ${VCPKG_TOOLCHAIN}")
        if(DEFINED VCPKG_TARGET_TRIPLET)
            message(STATUS "  Triplet:     ${VCPKG_TARGET_TRIPLET}")
        endif()
        message(STATUS "")
    endif()
endif()

# Build options
message(STATUS "Build Options:")
message(STATUS "  Testing:           ${BUILD_TESTING}")
message(STATUS "  Documentation:     ${BUILD_DOCS}")
message(STATUS "  Static Analysis:   ${ENABLE_STATIC_ANALYSIS}")
message(STATUS "  Sanitizers:        ${ENABLE_SANITIZERS}")
message(STATUS "  Code Coverage:     ${ENABLE_COVERAGE}")
message(STATUS "")

# Feature detection
message(STATUS "Feature Detection:")

# Qt deployment tools
if(PLATFORM_WINDOWS)
    find_program(WINDEPLOYQT_EXECUTABLE windeployqt HINTS ${Qt6_DIR}/../../../bin)
    if(WINDEPLOYQT_EXECUTABLE)
        message(STATUS "  windeployqt:       Found")
    else()
        message(STATUS "  windeployqt:       Not found")
    endif()
elseif(PLATFORM_MACOS)
    if(MACDEPLOYQT_EXECUTABLE)
        message(STATUS "  macdeployqt:       Found")
    else()
        message(STATUS "  macdeployqt:       Not found")
    endif()
elseif(PLATFORM_LINUX)
    if(LINUXDEPLOYQT_EXECUTABLE)
        message(STATUS "  linuxdeployqt:     Found")
    else()
        message(STATUS "  linuxdeployqt:     Not found")
    endif()
endif()

# Static analysis tools
if(ENABLE_STATIC_ANALYSIS)
    find_program(CLANG_TIDY_EXE NAMES "clang-tidy")
    if(CLANG_TIDY_EXE)
        message(STATUS "  clang-tidy:        Found")
    else()
        message(STATUS "  clang-tidy:        Not found")
    endif()
    
    find_program(CPPCHECK_EXE NAMES "cppcheck")
    if(CPPCHECK_EXE)
        message(STATUS "  cppcheck:          Found")
    else()
        message(STATUS "  cppcheck:          Not found")
    endif()
endif()

# Documentation tools
if(BUILD_DOCS)
    find_program(DOXYGEN_EXECUTABLE doxygen)
    if(DOXYGEN_EXECUTABLE)
        message(STATUS "  Doxygen:           Found")
    else()
        message(STATUS "  Doxygen:           Not found")
    endif()
endif()

# Packaging tools
message(STATUS "")
message(STATUS "Packaging Tools:")

if(WIN32)
    if(NSIS_EXECUTABLE)
        message(STATUS "  NSIS:              Found")
    else()
        message(STATUS "  NSIS:              Not found")
    endif()
endif()

if(APPLE)
    if(MACDEPLOYQT_EXECUTABLE)
        message(STATUS "  macdeployqt:       Found")
    else()
        message(STATUS "  macdeployqt:       Not found")
    endif()
    
    find_program(CREATE_DMG_EXECUTABLE create-dmg)
    if(CREATE_DMG_EXECUTABLE)
        message(STATUS "  create-dmg:        Found")
    else()
        message(STATUS "  create-dmg:        Not found")
    endif()
endif()

if(UNIX AND NOT APPLE)
    find_program(LINUXDEPLOY_EXECUTABLE linuxdeploy)
    if(LINUXDEPLOY_EXECUTABLE)
        message(STATUS "  linuxdeploy:       Found")
    else()
        message(STATUS "  linuxdeploy:       Not found")
    endif()
    
    find_program(APPIMAGETOOL_EXECUTABLE appimagetool)
    if(APPIMAGETOOL_EXECUTABLE)
        message(STATUS "  appimagetool:      Found")
    else()
        message(STATUS "  appimagetool:      Not found")
    endif()
endif()

if(BINARYCREATOR_EXECUTABLE)
    message(STATUS "  Qt IFW:            Found")
else()
    message(STATUS "  Qt IFW:            Not found")
endif()

# Build targets
message(STATUS "")
message(STATUS "Available Targets:")
message(STATUS "  all                - Build all targets")
message(STATUS "  app                - Build main application")
message(STATUS "  controls           - Build controls library")

if(BUILD_TESTING)
    message(STATUS "  check              - Run all tests")
    message(STATUS "  test               - Run CTest")
endif()

if(BUILD_DOCS)
    message(STATUS "  docs               - Generate documentation")
endif()

message(STATUS "  install            - Install the project")
message(STATUS "  package            - Create packages (CPack)")

# Platform-specific packaging targets
if(WIN32 AND NSIS_EXECUTABLE)
    message(STATUS "  package_nsis       - Create NSIS installer")
endif()

if(APPLE AND MACDEPLOYQT_EXECUTABLE)
    message(STATUS "  package_dmg        - Create DMG package")
endif()

if(UNIX AND NOT APPLE AND LINUXDEPLOY_EXECUTABLE)
    message(STATUS "  package_appimage   - Create AppImage")
endif()

if(BINARYCREATOR_EXECUTABLE)
    message(STATUS "  package_qtifw      - Create Qt IFW installer")
endif()

message(STATUS "  package_portable   - Create portable ZIP")
message(STATUS "  package_source     - Create source package")
message(STATUS "  package_all        - Create all packages")

message(STATUS "")
message(STATUS "=== End Configuration Summary ===")
message(STATUS "")
