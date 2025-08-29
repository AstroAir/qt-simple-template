# Hello World Example CMakeLists.txt

cmake_minimum_required(VERSION 3.20)

# Project configuration
project(hello_world_example
    LANGUAGES CXX
    VERSION 1.0.0
    DESCRIPTION "Hello World Qt Example"
)

# Find Qt6 components
find_package(Qt6 REQUIRED COMPONENTS
    Core
    Widgets
)

# Create executable
add_executable(hello_world_example
    main.cpp
)

# Set C++ standard
set_target_properties(hello_world_example PROPERTIES
    CXX_STANDARD 20
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
)

# Link Qt libraries
target_link_libraries(hello_world_example
    Qt6::Core
    Qt6::Widgets
)

# Enable Qt MOC (Meta-Object Compiler)
set_target_properties(hello_world_example PROPERTIES
    AUTOMOC ON
)

# Set output directory
set_target_properties(hello_world_example PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/examples/basic-usage/hello-world"
)

# Platform-specific settings
if(WIN32)
    # Windows-specific settings
    set_target_properties(hello_world_example PROPERTIES
        WIN32_EXECUTABLE TRUE
    )
    
    # Copy Qt DLLs on Windows (if using shared libraries)
    if(Qt6_FOUND AND TARGET Qt6::qmake)
        get_target_property(QT_QMAKE_EXECUTABLE Qt6::qmake IMPORTED_LOCATION)
        get_filename_component(QT_WINDEPLOYQT_EXECUTABLE ${QT_QMAKE_EXECUTABLE} PATH)
        set(QT_WINDEPLOYQT_EXECUTABLE "${QT_WINDEPLOYQT_EXECUTABLE}/windeployqt.exe")
        
        if(EXISTS ${QT_WINDEPLOYQT_EXECUTABLE})
            add_custom_command(TARGET hello_world_example POST_BUILD
                COMMAND ${QT_WINDEPLOYQT_EXECUTABLE} $<TARGET_FILE:hello_world_example>
                COMMENT "Deploying Qt libraries"
            )
        endif()
    endif()
endif()

# Add to examples target (if it exists)
if(TARGET examples)
    add_dependencies(examples hello_world_example)
endif()

# Installation
install(TARGETS hello_world_example
    RUNTIME DESTINATION examples/basic-usage/hello-world
)

# Add example to CTest
enable_testing()
add_test(
    NAME hello_world_example_runs
    COMMAND hello_world_example --help
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/examples/basic-usage/hello-world
)

# Set test properties
set_tests_properties(hello_world_example_runs PROPERTIES
    TIMEOUT 10
    LABELS "examples;basic-usage"
)
