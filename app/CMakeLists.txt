project(app LANGUAGES CXX VERSION 0.1.0.0 DESCRIPTION "My sample app")

configure_file(config.h.in ${CMAKE_CURRENT_BINARY_DIR}/config.h)

if (WIN32)
    add_executable(app app.rc)
else ()
    add_executable(app)
endif()

# 若无下面这个设置，则 exe 文件会生成到 build/Debug 中，而 qm 文件会生成到 build/Debug/app 目录下
set_target_properties(
    app
    PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

file(GLOB UIs ${CMAKE_SOURCE_DIR}/app/*.ui)
qt_add_translations(
    app
    SOURCES ${UIs}
    TS_FILE_DIR ${CMAKE_SOURCE_DIR}/app/i18n
    TS_FILE_BASE app
)

qt_add_resources(RESs app.qrc)

# Collect all source files
file(GLOB_RECURSE APP_SOURCES
    "src/*.cpp"
    "include/*.h"
)

target_sources(
    app
    PRIVATE
    # Legacy files (keeping for compatibility)
    Widget.cpp
    Widget.h

    # Main application
    main.cpp

    # MVC Architecture sources
    ${APP_SOURCES}

    # Resources
    ${RESs}
)

target_include_directories(
    app
    PRIVATE
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)
target_link_libraries(
    app
    PRIVATE
    Qt::Core Qt::Gui Qt::Widgets Qt::Svg
    controls
)

# Platform-specific deployment configuration
if(PLATFORM_MSYS2)
    # MSYS2 deployment using windeployqt from MSYS2 environment
    if(WINDEPLOYQT_EXECUTABLE)
        add_custom_command(
            TARGET app
            POST_BUILD
            COMMAND ${WINDEPLOYQT_EXECUTABLE}
            ARGS $<TARGET_FILE:app> --verbose 2
            COMMENT "Deploying Qt libraries with MSYS2 windeployqt"
        )
    else()
        message(WARNING "windeployqt not found in MSYS2 environment, manual deployment may be required")
    endif()
elseif(WIN32)
    # Native Windows deployment
    add_custom_command(
        TARGET app
        POST_BUILD
        COMMAND Qt6::windeployqt
        ARGS $<TARGET_FILE:app>
        COMMENT "Deploying Qt libraries with windeployqt"
    )
endif()

add_dependencies(app COPYING_ASSETS)
add_custom_target(COPYING_ASSETS DEPENDS ${CMAKE_BINARY_DIR}/COPYING_ASSETS_DUMMY)
add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/COPYING_ASSETS_DUMMY
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/assets/styles $<TARGET_FILE_DIR:app>/styles
)
