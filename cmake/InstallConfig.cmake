# Installation configuration for qt-simple-template

include(GNUInstallDirs)

# Set installation directories
if(WIN32)
    set(CMAKE_INSTALL_BINDIR ".")
    set(CMAKE_INSTALL_LIBDIR ".")
    set(CMAKE_INSTALL_DATADIR ".")
    set(CMAKE_INSTALL_DOCDIR "docs")
elseif(APPLE)
    # macOS app bundle structure
    set(CMAKE_INSTALL_BINDIR ".")
    set(CMAKE_INSTALL_LIBDIR ".")
    set(CMAKE_INSTALL_DATADIR ".")
    set(CMAKE_INSTALL_DOCDIR "docs")
else()
    # Use standard Unix directories
    # CMAKE_INSTALL_* variables are already set by GNUInstallDirs
endif()

# Install application
install(TARGETS app
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

# Install controls library
install(TARGETS controls
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# Install assets
install(DIRECTORY ${CMAKE_SOURCE_DIR}/assets/
    DESTINATION ${CMAKE_INSTALL_DATADIR}/assets
    FILES_MATCHING
    PATTERN "*.png"
    PATTERN "*.jpg"
    PATTERN "*.jpeg"
    PATTERN "*.svg"
    PATTERN "*.qss"
    PATTERN "*.css"
)

# Install translations
install(DIRECTORY ${CMAKE_BINARY_DIR}/app/
    DESTINATION ${CMAKE_INSTALL_BINDIR}
    FILES_MATCHING
    PATTERN "*.qm"
)

# Install documentation
if(BUILD_DOCS)
    install(DIRECTORY ${CMAKE_SOURCE_DIR}/docs/
        DESTINATION ${CMAKE_INSTALL_DOCDIR}
        FILES_MATCHING
        PATTERN "*.md"
        PATTERN "*.html"
        PATTERN "*.pdf"
        PATTERN "images/*"
    )
endif()

# Install license and readme
install(FILES
    ${CMAKE_SOURCE_DIR}/LICENSE
    ${CMAKE_SOURCE_DIR}/README.md
    DESTINATION ${CMAKE_INSTALL_DOCDIR}
)

# Platform-specific installation
if(WIN32)
    # Install Visual C++ Redistributable (if needed)
    # This would typically be handled by the installer
    
    # Install Qt libraries (handled by windeployqt in app/CMakeLists.txt)
    
elseif(APPLE)
    # macOS app bundle configuration
    set_target_properties(app PROPERTIES
        MACOSX_BUNDLE TRUE
        MACOSX_BUNDLE_BUNDLE_NAME "${PROJECT_NAME}"
        MACOSX_BUNDLE_BUNDLE_VERSION "${PROJECT_VERSION}"
        MACOSX_BUNDLE_SHORT_VERSION_STRING "${PROJECT_VERSION}"
        MACOSX_BUNDLE_IDENTIFIER "com.yourcompany.${PROJECT_NAME}"
        MACOSX_BUNDLE_INFO_STRING "${PROJECT_DESCRIPTION}"
        MACOSX_BUNDLE_COPYRIGHT "Copyright © 2025 Your Name"
    )
    
    # Install app bundle
    install(TARGETS app
        BUNDLE DESTINATION .
    )
    
elseif(UNIX)
    # Linux desktop integration
    
    # Install desktop file
    configure_file(
        ${CMAKE_SOURCE_DIR}/distrib/linux/${PROJECT_NAME}.desktop.in
        ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.desktop
        @ONLY
    )
    
    install(FILES ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.desktop
        DESTINATION ${CMAKE_INSTALL_DATADIR}/applications
    )
    
    # Install icon
    if(EXISTS ${CMAKE_SOURCE_DIR}/assets/images/icon.png)
        install(FILES ${CMAKE_SOURCE_DIR}/assets/images/icon.png
            DESTINATION ${CMAKE_INSTALL_DATADIR}/icons/hicolor/64x64/apps
            RENAME ${PROJECT_NAME}.png
        )
    endif()
    
    # Install man page (if exists)
    if(EXISTS ${CMAKE_SOURCE_DIR}/docs/man/${PROJECT_NAME}.1)
        install(FILES ${CMAKE_SOURCE_DIR}/docs/man/${PROJECT_NAME}.1
            DESTINATION ${CMAKE_INSTALL_MANDIR}/man1
        )
    endif()
endif()

# Create uninstall target
if(NOT TARGET uninstall)
    configure_file(
        "${CMAKE_CURRENT_LIST_DIR}/cmake_uninstall.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
        IMMEDIATE @ONLY
    )
    
    add_custom_target(uninstall
        COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake
    )
endif()

# CPack configuration for packaging
set(CPACK_PACKAGE_NAME "${PROJECT_NAME}")
set(CPACK_PACKAGE_VENDOR "Your Company")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${PROJECT_DESCRIPTION}")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_PACKAGE_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${PROJECT_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${PROJECT_VERSION_PATCH}")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "${PROJECT_NAME}")
set(CPACK_PACKAGE_CONTACT "your.email@example.com")

# Platform-specific packaging
if(WIN32)
    set(CPACK_GENERATOR "NSIS;ZIP")
    set(CPACK_NSIS_DISPLAY_NAME "${PROJECT_NAME}")
    set(CPACK_NSIS_PACKAGE_NAME "${PROJECT_NAME}")
    set(CPACK_NSIS_CONTACT "${CPACK_PACKAGE_CONTACT}")
    set(CPACK_NSIS_HELP_LINK "https://github.com/your-org/${PROJECT_NAME}")
    set(CPACK_NSIS_URL_INFO_ABOUT "https://github.com/your-org/${PROJECT_NAME}")
    set(CPACK_NSIS_MODIFY_PATH ON)
elseif(APPLE)
    set(CPACK_GENERATOR "DragNDrop;TGZ")
    set(CPACK_DMG_FORMAT "UDBZ")
    set(CPACK_DMG_VOLUME_NAME "${PROJECT_NAME}")
    set(CPACK_SYSTEM_NAME "macOS")
elseif(UNIX)
    set(CPACK_GENERATOR "DEB;RPM;TGZ")
    
    # Debian package configuration
    set(CPACK_DEBIAN_PACKAGE_MAINTAINER "${CPACK_PACKAGE_CONTACT}")
    set(CPACK_DEBIAN_PACKAGE_SECTION "utils")
    set(CPACK_DEBIAN_PACKAGE_PRIORITY "optional")
    set(CPACK_DEBIAN_PACKAGE_DEPENDS "libqt6core6, libqt6gui6, libqt6widgets6, libqt6svg6")
    
    # RPM package configuration
    set(CPACK_RPM_PACKAGE_LICENSE "MIT")
    set(CPACK_RPM_PACKAGE_GROUP "Applications/Productivity")
    set(CPACK_RPM_PACKAGE_REQUIRES "qt6-qtbase, qt6-qtsvg")
endif()

include(CPack)
