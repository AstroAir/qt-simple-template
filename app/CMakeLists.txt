include(CopyAssets)

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

target_sources(
    app
    PRIVATE
    Widget.cpp
    main.cpp
    ${RESs}
)
target_include_directories(
    app
    PRIVATE
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
)
target_link_libraries(
    app
    PRIVATE
    Qt::Core Qt::Gui Qt::Widgets Qt::Svg
    controls
)

if(WIN32)
    find_package(windeployqt REQUIRED)
    install(
        CODE "execute_process(COMMAND ${windeployqt_EXECUTABLE} --qmldir ${CMAKE_SOURCE_DIR} $<TARGET_FILE:app>)"
    )
endif()

copy_assets()

install(
    TARGETS app
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
