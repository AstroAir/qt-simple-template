# CTest configuration for qt-simple-template

# Set the project name for CTest
set(CTEST_PROJECT_NAME "qt-simple-template")

# Set the build name
set(CTEST_BUILD_NAME "${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}")

# Set timeout for tests (in seconds)
set(CTEST_TEST_TIMEOUT 300)

# Configure test output
set(CTEST_OUTPUT_ON_FAILURE TRUE)

# Configure parallel testing
set(CTEST_PARALLEL_LEVEL 4)

# Configure test discovery
set(CTEST_USE_LAUNCHERS TRUE)

# Set custom test properties
set_property(GLOBAL PROPERTY CTEST_TARGETS_ADDED 1)
