# Integration Tests CMakeLists.txt
cmake_minimum_required(VERSION 3.28)

# Integration test for complete application workflow
add_qt_test(test_app_integration
    test_app_integration.cpp
)

# Integration test for build system
add_qt_test(test_build_integration
    test_build_integration.cpp
)

# Integration test for resource loading
add_qt_test(test_resource_integration
    test_resource_integration.cpp
)
