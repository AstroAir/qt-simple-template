# Qt helper functions for qt-simple-template

# Function to add a Qt application with common settings
function(add_qt_application target_name)
    set(options CONSOLE)
    set(oneValueArgs VERSION DESCRIPTION ICON)
    set(multiValueArgs SOURCES HEADERS UI_FILES QRC_FILES TRANSLATIONS)
    
    cmake_parse_arguments(QT_APP "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    # Create executable
    if(WIN32 AND NOT QT_APP_CONSOLE)
        add_executable(${target_name} WIN32 ${QT_APP_SOURCES} ${QT_APP_HEADERS})
    elseif(APPLE)
        add_executable(${target_name} MACOSX_BUNDLE ${QT_APP_SOURCES} ${QT_APP_HEADERS})
    else()
        add_executable(${target_name} ${QT_APP_SOURCES} ${QT_APP_HEADERS})
    endif()
    
    # Add UI files
    if(QT_APP_UI_FILES)
        qt_add_resources(${target_name} ${QT_APP_UI_FILES})
    endif()
    
    # Add resource files
    if(QT_APP_QRC_FILES)
        qt_add_resources(${target_name} ${QT_APP_QRC_FILES})
    endif()
    
    # Add translations
    if(QT_APP_TRANSLATIONS)
        qt_add_translations(${target_name} ${QT_APP_TRANSLATIONS})
    endif()
    
    # Set properties
    if(QT_APP_VERSION)
        set_target_properties(${target_name} PROPERTIES VERSION ${QT_APP_VERSION})
    endif()
    
    if(QT_APP_DESCRIPTION)
        set_target_properties(${target_name} PROPERTIES DESCRIPTION ${QT_APP_DESCRIPTION})
    endif()
    
    # Platform-specific properties
    if(WIN32)
        if(QT_APP_ICON)
            set_target_properties(${target_name} PROPERTIES WIN32_EXECUTABLE_ICON ${QT_APP_ICON})
        endif()
    elseif(APPLE)
        if(QT_APP_ICON)
            set_target_properties(${target_name} PROPERTIES MACOSX_BUNDLE_ICON_FILE ${QT_APP_ICON})
        endif()
        
        set_target_properties(${target_name} PROPERTIES
            MACOSX_BUNDLE_BUNDLE_NAME ${target_name}
            MACOSX_BUNDLE_GUI_IDENTIFIER "com.yourcompany.${target_name}"
        )
    endif()
endfunction()

# Function to add a Qt library with common settings
function(add_qt_library target_name)
    set(options STATIC SHARED)
    set(oneValueArgs VERSION DESCRIPTION)
    set(multiValueArgs SOURCES HEADERS PUBLIC_HEADERS)
    
    cmake_parse_arguments(QT_LIB "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    # Determine library type
    if(QT_LIB_STATIC)
        set(LIB_TYPE STATIC)
    elseif(QT_LIB_SHARED)
        set(LIB_TYPE SHARED)
    else()
        set(LIB_TYPE "")
    endif()
    
    # Create library
    add_library(${target_name} ${LIB_TYPE} ${QT_LIB_SOURCES} ${QT_LIB_HEADERS})
    
    # Set public headers
    if(QT_LIB_PUBLIC_HEADERS)
        set_target_properties(${target_name} PROPERTIES
            PUBLIC_HEADER "${QT_LIB_PUBLIC_HEADERS}"
        )
    endif()
    
    # Set properties
    if(QT_LIB_VERSION)
        set_target_properties(${target_name} PROPERTIES VERSION ${QT_LIB_VERSION})
    endif()
    
    if(QT_LIB_DESCRIPTION)
        set_target_properties(${target_name} PROPERTIES DESCRIPTION ${QT_LIB_DESCRIPTION})
    endif()
    
    # Export symbols for shared libraries
    if(QT_LIB_SHARED OR (NOT QT_LIB_STATIC AND BUILD_SHARED_LIBS))
        target_compile_definitions(${target_name} PRIVATE ${target_name}_EXPORTS)
        
        # Generate export header
        include(GenerateExportHeader)
        generate_export_header(${target_name}
            EXPORT_FILE_NAME ${CMAKE_CURRENT_BINARY_DIR}/${target_name}_export.h
        )
        
        target_include_directories(${target_name} PUBLIC ${CMAKE_CURRENT_BINARY_DIR})
    endif()
endfunction()

# Function to deploy Qt application
function(deploy_qt_application target_name)
    set(options FORCE)
    set(oneValueArgs DESTINATION)
    set(multiValueArgs ADDITIONAL_FILES)
    
    cmake_parse_arguments(DEPLOY "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    if(NOT DEPLOY_DESTINATION)
        set(DEPLOY_DESTINATION $<TARGET_FILE_DIR:${target_name}>)
    endif()
    
    if(WIN32)
        # Windows deployment with windeployqt
        find_program(WINDEPLOYQT_EXECUTABLE windeployqt HINTS ${Qt6_DIR}/../../../bin)
        
        if(WINDEPLOYQT_EXECUTABLE)
            add_custom_command(TARGET ${target_name} POST_BUILD
                COMMAND ${WINDEPLOYQT_EXECUTABLE} $<TARGET_FILE:${target_name}>
                COMMENT "Deploying Qt libraries for ${target_name}"
            )
        endif()
        
    elseif(APPLE)
        # macOS deployment with macdeployqt
        find_program(MACDEPLOYQT_EXECUTABLE macdeployqt HINTS ${Qt6_DIR}/../../../bin)
        
        if(MACDEPLOYQT_EXECUTABLE)
            add_custom_command(TARGET ${target_name} POST_BUILD
                COMMAND ${MACDEPLOYQT_EXECUTABLE} $<TARGET_BUNDLE_DIR:${target_name}>
                COMMENT "Deploying Qt libraries for ${target_name}"
            )
        endif()
        
    elseif(UNIX)
        # Linux deployment - copy Qt libraries manually or use linuxdeployqt
        # This is more complex and typically handled during packaging
        message(STATUS "Linux Qt deployment should be handled during packaging")
    endif()
    
    # Copy additional files
    if(DEPLOY_ADDITIONAL_FILES)
        foreach(file ${DEPLOY_ADDITIONAL_FILES})
            add_custom_command(TARGET ${target_name} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different ${file} ${DEPLOY_DESTINATION}
                COMMENT "Copying ${file} to ${DEPLOY_DESTINATION}"
            )
        endforeach()
    endif()
endfunction()

# Function to add Qt test
function(add_qt_test test_name)
    set(options GUI)
    set(oneValueArgs TIMEOUT)
    set(multiValueArgs SOURCES LIBRARIES)
    
    cmake_parse_arguments(QT_TEST "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    # Create test executable
    add_executable(${test_name} ${QT_TEST_SOURCES})
    
    # Link Qt Test
    target_link_libraries(${test_name} PRIVATE Qt::Test)
    
    # Link additional libraries
    if(QT_TEST_LIBRARIES)
        target_link_libraries(${test_name} PRIVATE ${QT_TEST_LIBRARIES})
    endif()
    
    # Add to CTest
    add_test(NAME ${test_name} COMMAND ${test_name})
    
    # Set test properties
    set(test_properties "")
    
    if(QT_TEST_TIMEOUT)
        list(APPEND test_properties TIMEOUT ${QT_TEST_TIMEOUT})
    else()
        list(APPEND test_properties TIMEOUT 30)
    endif()
    
    if(NOT QT_TEST_GUI)
        list(APPEND test_properties ENVIRONMENT "QT_QPA_PLATFORM=offscreen")
    endif()
    
    if(test_properties)
        set_tests_properties(${test_name} PROPERTIES ${test_properties})
    endif()
endfunction()

# Function to find Qt tools
function(find_qt_tools)
    # Find common Qt tools
    find_program(QT_QMAKE_EXECUTABLE qmake HINTS ${Qt6_DIR}/../../../bin)
    find_program(QT_MOC_EXECUTABLE moc HINTS ${Qt6_DIR}/../../../bin)
    find_program(QT_UIC_EXECUTABLE uic HINTS ${Qt6_DIR}/../../../bin)
    find_program(QT_RCC_EXECUTABLE rcc HINTS ${Qt6_DIR}/../../../bin)
    find_program(QT_LRELEASE_EXECUTABLE lrelease HINTS ${Qt6_DIR}/../../../bin)
    find_program(QT_LUPDATE_EXECUTABLE lupdate HINTS ${Qt6_DIR}/../../../bin)
    
    # Deployment tools
    if(WIN32)
        find_program(QT_WINDEPLOYQT_EXECUTABLE windeployqt HINTS ${Qt6_DIR}/../../../bin)
    elseif(APPLE)
        find_program(QT_MACDEPLOYQT_EXECUTABLE macdeployqt HINTS ${Qt6_DIR}/../../../bin)
    endif()
    
    # Qt Installer Framework
    find_program(QT_BINARYCREATOR_EXECUTABLE binarycreator HINTS ${Qt6_DIR}/../../../bin)
    find_program(QT_INSTALLERBASE_EXECUTABLE installerbase HINTS ${Qt6_DIR}/../../../bin)
    
    # Report findings
    if(QT_QMAKE_EXECUTABLE)
        message(STATUS "Found qmake: ${QT_QMAKE_EXECUTABLE}")
    endif()
    
    if(QT_WINDEPLOYQT_EXECUTABLE)
        message(STATUS "Found windeployqt: ${QT_WINDEPLOYQT_EXECUTABLE}")
    endif()
    
    if(QT_MACDEPLOYQT_EXECUTABLE)
        message(STATUS "Found macdeployqt: ${QT_MACDEPLOYQT_EXECUTABLE}")
    endif()
    
    if(QT_BINARYCREATOR_EXECUTABLE)
        message(STATUS "Found binarycreator: ${QT_BINARYCREATOR_EXECUTABLE}")
    endif()
endfunction()

# Call find_qt_tools automatically
find_qt_tools()
