cmake_minimum_required(VERSION 3.16)

# Project configuration
project(qt_simple_template
    LANGUAGES CXX
    VERSION 0.1.0.0
    DESCRIPTION "A simple Qt6 application"
)

# Set C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Set default build type
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build" FORCE)
endif()

# Qt configuration
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

# Find Qt6 components without using the problematic EntryPoint mechanism
# Use NO_DEFAULT_PATH to avoid system-wide Qt6 conflicts
find_package(Qt6 REQUIRED COMPONENTS Core Widgets Gui Svg CONFIG
    PATHS "D:/msys64/mingw64/lib/cmake/Qt6"
    NO_DEFAULT_PATH
)

# Verify Qt6 was found
if(Qt6_FOUND)
    message(STATUS "Qt6 found successfully: ${Qt6_VERSION}")
else()
    message(FATAL_ERROR "Qt6 not found")
endif()

# Add subdirectories
add_subdirectory(controls)
add_subdirectory(app)

# Print simple summary
message(STATUS "")
message(STATUS "=== Simple Qt6 Build Configuration ===")
message(STATUS "Project: ${PROJECT_NAME}")
message(STATUS "Version: ${PROJECT_VERSION}")
message(STATUS "Qt6 Version: ${Qt6_VERSION}")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "=====================================")
message(STATUS "")
