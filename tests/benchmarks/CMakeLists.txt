# Benchmark Tests CMakeLists.txt
cmake_minimum_required(VERSION 3.28)

# Benchmark for widget performance
add_qt_test(benchmark_widget_performance
    benchmark_widget_performance.cpp
)

# Benchmark for theme switching
add_qt_test(benchmark_theme_switching
    benchmark_theme_switching.cpp
)

# Benchmark for resource loading
add_qt_test(benchmark_resource_loading
    benchmark_resource_loading.cpp
)
