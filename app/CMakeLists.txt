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

# Handle translations manually since qt_add_translations is not available
file(GLOB UIs ${CMAKE_SOURCE_DIR}/app/*.ui)
file(GLOB TS_FILES ${CMAKE_SOURCE_DIR}/app/i18n/*.ts)

# Process translation files if they exist
if(TS_FILES)
    find_program(LRELEASE_EXECUTABLE lrelease HINTS ${Qt6_DIR}/../../../bin)
    if(LRELEASE_EXECUTABLE)
        foreach(TS_FILE ${TS_FILES})
            get_filename_component(QM_FILE ${TS_FILE} NAME_WE)
            set(QM_FILE "${CMAKE_CURRENT_BINARY_DIR}/${QM_FILE}.qm")
            add_custom_command(
                OUTPUT ${QM_FILE}
                COMMAND ${LRELEASE_EXECUTABLE} ${TS_FILE} -qm ${QM_FILE}
                DEPENDS ${TS_FILE}
                COMMENT "Generating ${QM_FILE}"
            )
            list(APPEND QM_FILES ${QM_FILE})
        endforeach()
    endif()
endif()

# Handle resources manually since qt_add_resources is not available
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/app.qrc)
    find_program(RCC_EXECUTABLE rcc HINTS ${Qt6_DIR}/../../../bin)
    if(RCC_EXECUTABLE)
        set(QRC_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/qrc_app.cpp)
        add_custom_command(
            OUTPUT ${QRC_OUTPUT}
            COMMAND ${RCC_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/app.qrc -o ${QRC_OUTPUT}
            DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/app.qrc
            COMMENT "Generating resource file"
        )
        set(RESs ${QRC_OUTPUT})
    endif()
endif()

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

# Fix cyclic dependency by using POST_BUILD command instead of custom target
add_custom_command(
    TARGET app POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/assets/styles ${CMAKE_CURRENT_BINARY_DIR}/styles
    COMMENT "Copying asset files after build"
)
