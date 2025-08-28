# Unit Tests CMakeLists.txt
cmake_minimum_required(VERSION 3.28)

# Test for controls library
add_qt_test(test_slider
    test_slider.cpp
)

# Test for main widget
add_qt_test(test_widget
    test_widget.cpp
)

# Test for application configuration
add_qt_test(test_config
    test_config.cpp
)

# Test for theme management
add_qt_test(test_theme
    test_theme.cpp
)

# Test for internationalization
add_qt_test(test_i18n
    test_i18n.cpp
)
