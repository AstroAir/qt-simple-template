# Tests CMakeLists.txt for qt-simple-template
cmake_minimum_required(VERSION 3.28)

# Enable testing
enable_testing()

# Find Qt Test component
find_package(Qt6 REQUIRED COMPONENTS Test)

# Set common test properties
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Common test libraries
set(TEST_LIBRARIES
    Qt::Test
    Qt::Core
    Qt::Gui
    Qt::Widgets
    controls
)

# Common test include directories
set(TEST_INCLUDE_DIRS
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/app
    ${CMAKE_SOURCE_DIR}/controls
    ${CMAKE_CURRENT_SOURCE_DIR}
)

# Function to create a test executable
function(add_qt_test test_name test_sources)
    # Create test executable
    add_executable(${test_name} ${test_sources})
    
    # Set target properties
    target_link_libraries(${test_name} PRIVATE ${TEST_LIBRARIES})
    target_include_directories(${test_name} PRIVATE ${TEST_INCLUDE_DIRS})
    
    # Add to CTest
    add_test(NAME ${test_name} COMMAND ${test_name})
    
    # Set test properties
    set_tests_properties(${test_name} PROPERTIES
        TIMEOUT 30
        ENVIRONMENT "QT_QPA_PLATFORM=offscreen"
    )
    
    # Add test to custom target for running all tests
    add_dependencies(check ${test_name})
endfunction()

# Create custom target for running all tests
add_custom_target(check COMMAND ${CMAKE_CTEST_COMMAND} --verbose)

# Add unit tests
add_subdirectory(unit)

# Add integration tests
add_subdirectory(integration)

# Add benchmark tests
add_subdirectory(benchmarks)
