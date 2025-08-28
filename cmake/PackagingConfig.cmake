# Packaging configuration for qt-simple-template

# Custom packaging targets for different platforms

# Windows packaging with NSIS
if(WIN32)
    if(PLATFORM_MSYS2)
        # MSYS2-specific NSIS packaging
        find_program(NSIS_EXECUTABLE makensis
            HINTS "$ENV{MSYSTEM_PREFIX}/bin"
            PATHS
            "$ENV{ProgramFiles}/NSIS"
            "$ENV{ProgramFiles\(x86\)}/NSIS"
            DOC "NSIS executable"
        )

        if(NSIS_EXECUTABLE)
            message(STATUS "Found NSIS for MSYS2: ${NSIS_EXECUTABLE}")

            # MSYS2 NSIS packaging target
            add_custom_target(package_nsis_msys2
                COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG>
                COMMAND ${NSIS_EXECUTABLE} ${CMAKE_SOURCE_DIR}/distrib/pack.nsi
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                COMMENT "Creating NSIS installer with MSYS2"
            )

            # Create MSYS2-specific portable package
            add_custom_target(package_msys2_portable
                COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/package/msys2-portable
                COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG> --target install
                COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_INSTALL_PREFIX} ${CMAKE_BINARY_DIR}/package/msys2-portable
                COMMAND ${CMAKE_COMMAND} -E tar czf ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}-msys2-portable.tar.gz --format=gnutar -C ${CMAKE_BINARY_DIR}/package msys2-portable
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                COMMENT "Creating MSYS2 portable package"
            )
        else()
            message(STATUS "NSIS not found in MSYS2 environment")
        endif()

    else()
        # Native Windows NSIS packaging
        find_program(NSIS_EXECUTABLE makensis
            PATHS
            "$ENV{ProgramFiles}/NSIS"
            "$ENV{ProgramFiles\(x86\)}/NSIS"
            DOC "NSIS executable"
        )

        if(NSIS_EXECUTABLE)
            message(STATUS "Found NSIS: ${NSIS_EXECUTABLE}")

            # Custom NSIS packaging target
            add_custom_target(package_nsis
                COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG>
                COMMAND ${NSIS_EXECUTABLE} ${CMAKE_SOURCE_DIR}/distrib/pack.nsi
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                COMMENT "Creating NSIS installer"
            )
        endif()
    endif()

    # Windows MSI installer with WiX Toolset
    find_program(CANDLE_EXECUTABLE candle
        PATHS
        "$ENV{ProgramFiles}/WiX Toolset v3.11/bin"
        "$ENV{ProgramFiles\(x86\)}/WiX Toolset v3.11/bin"
        "$ENV{WIX}/bin"
        DOC "WiX candle.exe executable"
    )

    find_program(LIGHT_EXECUTABLE light
        PATHS
        "$ENV{ProgramFiles}/WiX Toolset v3.11/bin"
        "$ENV{ProgramFiles\(x86\)}/WiX Toolset v3.11/bin"
        "$ENV{WIX}/bin"
        DOC "WiX light.exe executable"
    )

    if(CANDLE_EXECUTABLE AND LIGHT_EXECUTABLE)
        message(STATUS "Found WiX Toolset: ${CANDLE_EXECUTABLE}, ${LIGHT_EXECUTABLE}")

        # Generate WiX source file
        configure_file(
            ${CMAKE_SOURCE_DIR}/packaging/wix/Product.wxs.in
            ${CMAKE_BINARY_DIR}/wix/Product.wxs
            @ONLY
        )

        # MSI packaging target
        add_custom_target(package_msi
            COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG>
            COMMAND ${CANDLE_EXECUTABLE} -out ${CMAKE_BINARY_DIR}/wix/ ${CMAKE_BINARY_DIR}/wix/Product.wxs
            COMMAND ${LIGHT_EXECUTABLE} -out ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}.msi ${CMAKE_BINARY_DIR}/wix/Product.wixobj
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
            COMMENT "Creating MSI installer"
        )
    endif()

    # Chocolatey package support
    add_custom_target(package_chocolatey
        COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG>
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/chocolatey
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/packaging/chocolatey ${CMAKE_BINARY_DIR}/chocolatey
        COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}.msi ${CMAKE_BINARY_DIR}/chocolatey/tools/
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/chocolatey
        COMMENT "Creating Chocolatey package"
    )

    # WinGet manifest generation
    add_custom_target(package_winget
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/winget
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/packaging/winget ${CMAKE_BINARY_DIR}/winget
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Generating WinGet manifest"
    )

    # Portable ZIP package
    add_custom_target(package_portable_zip
        COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG>
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/portable
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_INSTALL_PREFIX} ${CMAKE_BINARY_DIR}/portable/${PROJECT_NAME}
        COMMAND ${CMAKE_COMMAND} -E tar czf ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}-portable.zip --format=zip ${CMAKE_BINARY_DIR}/portable/${PROJECT_NAME}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Creating portable ZIP package"
    )
endif()

# macOS packaging with DMG
if(APPLE)
    # Find macdeployqt
    find_program(MACDEPLOYQT_EXECUTABLE macdeployqt
        HINTS ${Qt6_DIR}/../../../bin
        DOC "macdeployqt executable"
    )
    
    if(MACDEPLOYQT_EXECUTABLE)
        message(STATUS "Found macdeployqt: ${MACDEPLOYQT_EXECUTABLE}")
        
        # Custom DMG packaging target
        add_custom_target(package_dmg
            COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG>
            COMMAND ${MACDEPLOYQT_EXECUTABLE} ${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}.app -dmg
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
            COMMENT "Creating DMG package"
        )
    endif()
    
    # Alternative: create-dmg tool
    find_program(CREATE_DMG_EXECUTABLE create-dmg
        DOC "create-dmg executable"
    )
    
    if(CREATE_DMG_EXECUTABLE)
        message(STATUS "Found create-dmg: ${CREATE_DMG_EXECUTABLE}")
        
        add_custom_target(package_dmg_advanced
            COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG>
            COMMAND ${CREATE_DMG_EXECUTABLE}
                --volname "${PROJECT_NAME}"
                --volicon "${CMAKE_SOURCE_DIR}/assets/images/icon.icns"
                --window-pos 200 120
                --window-size 600 300
                --icon-size 100
                --icon "${PROJECT_NAME}.app" 175 120
                --hide-extension "${PROJECT_NAME}.app"
                --app-drop-link 425 120
                "${PROJECT_NAME}-${PROJECT_VERSION}.dmg"
                "${CMAKE_INSTALL_PREFIX}/"
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
            COMMENT "Creating advanced DMG package"
        )
    endif()

    # PKG installer support
    find_program(PRODUCTBUILD_EXECUTABLE productbuild
        DOC "productbuild executable"
    )

    find_program(PKGBUILD_EXECUTABLE pkgbuild
        DOC "pkgbuild executable"
    )

    if(PRODUCTBUILD_EXECUTABLE AND PKGBUILD_EXECUTABLE)
        message(STATUS "Found productbuild: ${PRODUCTBUILD_EXECUTABLE}")
        message(STATUS "Found pkgbuild: ${PKGBUILD_EXECUTABLE}")

        # PKG packaging target
        add_custom_target(package_pkg
            COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG>
            COMMAND ${PKGBUILD_EXECUTABLE}
                --root ${CMAKE_INSTALL_PREFIX}
                --identifier com.example.${PROJECT_NAME}
                --version ${PROJECT_VERSION}
                --install-location /Applications
                ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-component.pkg
            COMMAND ${PRODUCTBUILD_EXECUTABLE}
                --distribution ${CMAKE_SOURCE_DIR}/packaging/macos/distribution.xml
                --package-path ${CMAKE_BINARY_DIR}
                --resources ${CMAKE_SOURCE_DIR}/packaging/macos/resources
                ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}.pkg
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
            COMMENT "Creating PKG installer"
        )
    endif()

    # Homebrew formula generation
    add_custom_target(package_homebrew
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/homebrew
        COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/packaging/homebrew/qt-simple-template.rb.in ${CMAKE_BINARY_DIR}/homebrew/
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Generating Homebrew formula"
    )

    # MacPorts portfile generation
    add_custom_target(package_macports
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/macports
        COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/packaging/macports/Portfile.in ${CMAKE_BINARY_DIR}/macports/
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Generating MacPorts portfile"
    )

    # Code signing and notarization support
    if(DEFINED ENV{APPLE_DEVELOPER_ID})
        set(APPLE_CODESIGN_IDENTITY "$ENV{APPLE_DEVELOPER_ID}" CACHE STRING "Apple Developer ID for code signing")

        add_custom_target(package_signed_dmg
            COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG>
            COMMAND codesign --force --verify --verbose --sign "${APPLE_CODESIGN_IDENTITY}" ${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}.app
            COMMAND ${MACDEPLOYQT_EXECUTABLE} ${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}.app -dmg -codesign="${APPLE_CODESIGN_IDENTITY}"
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
            COMMENT "Creating signed DMG package"
        )

        if(DEFINED ENV{APPLE_NOTARIZATION_USERNAME})
            add_custom_target(package_notarized_dmg
                COMMAND ${CMAKE_COMMAND} --build . --target package_signed_dmg
                COMMAND xcrun notarytool submit ${PROJECT_NAME}.dmg --apple-id $ENV{APPLE_NOTARIZATION_USERNAME} --password $ENV{APPLE_NOTARIZATION_PASSWORD} --team-id $ENV{APPLE_TEAM_ID} --wait
                COMMAND xcrun stapler staple ${PROJECT_NAME}.dmg
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                COMMENT "Creating notarized DMG package"
            )
        endif()
    endif()
endif()

# Linux packaging with multiple formats
if(UNIX AND NOT APPLE)
    # Detect Linux distribution for appropriate packaging
    if(EXISTS "/etc/os-release")
        file(READ "/etc/os-release" OS_RELEASE_CONTENT)
        if(OS_RELEASE_CONTENT MATCHES "ID=ubuntu" OR OS_RELEASE_CONTENT MATCHES "ID=debian")
            set(LINUX_DISTRO "debian" CACHE STRING "Linux distribution type")
        elseif(OS_RELEASE_CONTENT MATCHES "ID=fedora" OR OS_RELEASE_CONTENT MATCHES "ID=rhel" OR OS_RELEASE_CONTENT MATCHES "ID=centos")
            set(LINUX_DISTRO "redhat" CACHE STRING "Linux distribution type")
        elseif(OS_RELEASE_CONTENT MATCHES "ID=arch")
            set(LINUX_DISTRO "arch" CACHE STRING "Linux distribution type")
        elseif(OS_RELEASE_CONTENT MATCHES "ID=opensuse")
            set(LINUX_DISTRO "suse" CACHE STRING "Linux distribution type")
        else()
            set(LINUX_DISTRO "generic" CACHE STRING "Linux distribution type")
        endif()
    else()
        set(LINUX_DISTRO "generic" CACHE STRING "Linux distribution type")
    endif()

    message(STATUS "Detected Linux distribution type: ${LINUX_DISTRO}")

    # CPack configuration for DEB packages
    if(LINUX_DISTRO STREQUAL "debian")
        set(CPACK_GENERATOR "DEB")
        set(CPACK_DEBIAN_PACKAGE_MAINTAINER "qt-simple-template developers")
        set(CPACK_DEBIAN_PACKAGE_DESCRIPTION "A simple Qt6 application template")
        set(CPACK_DEBIAN_PACKAGE_SECTION "x11")
        set(CPACK_DEBIAN_PACKAGE_PRIORITY "optional")
        set(CPACK_DEBIAN_PACKAGE_DEPENDS "libqt6core6, libqt6gui6, libqt6widgets6, libqt6svg6")
        set(CPACK_DEBIAN_PACKAGE_RECOMMENDS "qt6-qpa-plugins")
        set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${CMAKE_SOURCE_DIR}/packaging/debian/postinst;${CMAKE_SOURCE_DIR}/packaging/debian/prerm")

        # DEB-specific packaging target
        add_custom_target(package_deb
            COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG>
            COMMAND ${CMAKE_CPACK_COMMAND} -G DEB
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
            COMMENT "Creating DEB package"
        )
    endif()

    # CPack configuration for RPM packages
    if(LINUX_DISTRO STREQUAL "redhat" OR LINUX_DISTRO STREQUAL "suse")
        set(CPACK_GENERATOR "RPM")
        set(CPACK_RPM_PACKAGE_SUMMARY "A simple Qt6 application template")
        set(CPACK_RPM_PACKAGE_DESCRIPTION "A comprehensive Qt6 application template with modern build system")
        set(CPACK_RPM_PACKAGE_GROUP "Applications/Productivity")
        set(CPACK_RPM_PACKAGE_LICENSE "MIT")
        set(CPACK_RPM_PACKAGE_REQUIRES "qt6-qtbase, qt6-qtsvg")
        set(CPACK_RPM_POST_INSTALL_SCRIPT_FILE "${CMAKE_SOURCE_DIR}/packaging/rpm/postinst.sh")
        set(CPACK_RPM_PRE_UNINSTALL_SCRIPT_FILE "${CMAKE_SOURCE_DIR}/packaging/rpm/preun.sh")

        # RPM-specific packaging target
        add_custom_target(package_rpm
            COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG>
            COMMAND ${CMAKE_CPACK_COMMAND} -G RPM
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
            COMMENT "Creating RPM package"
        )
    endif()

    # Find linuxdeploy for AppImage
    find_program(LINUXDEPLOY_EXECUTABLE linuxdeploy
        DOC "linuxdeploy executable"
    )

    # Find linuxdeploy-plugin-qt
    find_program(LINUXDEPLOY_PLUGIN_QT_EXECUTABLE linuxdeploy-plugin-qt
        DOC "linuxdeploy-plugin-qt executable"
    )
    
    if(LINUXDEPLOY_EXECUTABLE AND LINUXDEPLOY_PLUGIN_QT_EXECUTABLE)
        message(STATUS "Found linuxdeploy: ${LINUXDEPLOY_EXECUTABLE}")
        message(STATUS "Found linuxdeploy-plugin-qt: ${LINUXDEPLOY_PLUGIN_QT_EXECUTABLE}")
        
        # Create AppImage packaging target
        add_custom_target(package_appimage
            COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG> DESTDIR=AppDir
            COMMAND ${LINUXDEPLOY_EXECUTABLE}
                --appdir AppDir
                --plugin qt
                --output appimage
                --desktop-file AppDir/usr/share/applications/${PROJECT_NAME}.desktop
                --icon-file AppDir/usr/share/icons/hicolor/64x64/apps/${PROJECT_NAME}.png
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
            COMMENT "Creating AppImage package"
        )
    endif()
    
    # Alternative: appimagetool
    find_program(APPIMAGETOOL_EXECUTABLE appimagetool
        DOC "appimagetool executable"
    )
    
    if(APPIMAGETOOL_EXECUTABLE)
        message(STATUS "Found appimagetool: ${APPIMAGETOOL_EXECUTABLE}")
        
        add_custom_target(package_appimage_manual
            COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG> DESTDIR=AppDir
            COMMAND ${APPIMAGETOOL_EXECUTABLE} AppDir ${PROJECT_NAME}-${PROJECT_VERSION}-x86_64.AppImage
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
            COMMENT "Creating AppImage package (manual)"
        )
    endif()

    # Snap packaging support
    find_program(SNAPCRAFT_EXECUTABLE snapcraft
        DOC "snapcraft executable"
    )

    if(SNAPCRAFT_EXECUTABLE)
        message(STATUS "Found snapcraft: ${SNAPCRAFT_EXECUTABLE}")

        # Generate snapcraft.yaml
        configure_file(
            ${CMAKE_SOURCE_DIR}/packaging/snap/snapcraft.yaml.in
            ${CMAKE_BINARY_DIR}/snap/snapcraft.yaml
            @ONLY
        )

        # Snap packaging target
        add_custom_target(package_snap
            COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG>
            COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_INSTALL_PREFIX} ${CMAKE_BINARY_DIR}/snap/install
            COMMAND ${SNAPCRAFT_EXECUTABLE} --destructive-mode
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/snap
            COMMENT "Creating Snap package"
        )
    endif()

    # Flatpak packaging support
    find_program(FLATPAK_BUILDER_EXECUTABLE flatpak-builder
        DOC "flatpak-builder executable"
    )

    if(FLATPAK_BUILDER_EXECUTABLE)
        message(STATUS "Found flatpak-builder: ${FLATPAK_BUILDER_EXECUTABLE}")

        # Generate Flatpak manifest
        configure_file(
            ${CMAKE_SOURCE_DIR}/packaging/flatpak/com.example.QtSimpleTemplate.json.in
            ${CMAKE_BINARY_DIR}/flatpak/com.example.QtSimpleTemplate.json
            @ONLY
        )

        # Flatpak packaging target
        add_custom_target(package_flatpak
            COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG>
            COMMAND ${FLATPAK_BUILDER_EXECUTABLE}
                --force-clean
                --repo=${CMAKE_BINARY_DIR}/flatpak-repo
                ${CMAKE_BINARY_DIR}/flatpak-build
                ${CMAKE_BINARY_DIR}/flatpak/com.example.QtSimpleTemplate.json
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
            COMMENT "Creating Flatpak package"
        )
    endif()

    # Arch Linux PKGBUILD support
    if(LINUX_DISTRO STREQUAL "arch")
        find_program(MAKEPKG_EXECUTABLE makepkg
            DOC "makepkg executable"
        )

        if(MAKEPKG_EXECUTABLE)
            message(STATUS "Found makepkg: ${MAKEPKG_EXECUTABLE}")

            # Generate PKGBUILD
            configure_file(
                ${CMAKE_SOURCE_DIR}/packaging/arch/PKGBUILD.in
                ${CMAKE_BINARY_DIR}/arch/PKGBUILD
                @ONLY
            )

            # Arch package target
            add_custom_target(package_arch
                COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG>
                COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_INSTALL_PREFIX} ${CMAKE_BINARY_DIR}/arch/pkg
                COMMAND ${MAKEPKG_EXECUTABLE} -f
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/arch
                COMMENT "Creating Arch Linux package"
            )
        endif()
    endif()
endif()

# Cross-platform Qt Installer Framework
find_program(BINARYCREATOR_EXECUTABLE binarycreator
    HINTS ${Qt6_DIR}/../../../bin
    DOC "Qt Installer Framework binarycreator"
)

if(BINARYCREATOR_EXECUTABLE)
    message(STATUS "Found binarycreator: ${BINARYCREATOR_EXECUTABLE}")
    
    # Qt Installer Framework packaging
    add_custom_target(package_qtifw
        COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG>
        COMMAND ${BINARYCREATOR_EXECUTABLE}
            --offline-only
            -c ${CMAKE_SOURCE_DIR}/distrib/qtifw/config/config.xml
            -p ${CMAKE_SOURCE_DIR}/distrib/qtifw/packages
            ${PROJECT_NAME}-${PROJECT_VERSION}-installer
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Creating Qt Installer Framework package"
    )
endif()

# Portable ZIP package (cross-platform)
add_custom_target(package_portable
    COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG>
    COMMAND ${CMAKE_COMMAND} -E tar czf ${PROJECT_NAME}-${PROJECT_VERSION}-portable.zip --format=zip ${CMAKE_INSTALL_PREFIX}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Creating portable ZIP package"
)

# Source package
add_custom_target(package_src
    COMMAND ${CMAKE_COMMAND} -E tar czf ${PROJECT_NAME}-${PROJECT_VERSION}-source.tar.gz
        --exclude=.git
        --exclude=build
        --exclude=.vs
        --exclude=.vscode
        --exclude="*.user"
        ${CMAKE_SOURCE_DIR}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Creating source package"
)

# All packages target
add_custom_target(package_all
    COMMENT "Creating all available packages"
)

# Add platform-specific packages to package_all
if(WIN32)
    if(PLATFORM_MSYS2 AND NSIS_EXECUTABLE)
        add_dependencies(package_all package_nsis_msys2 package_msys2_portable)
    elseif(NSIS_EXECUTABLE)
        add_dependencies(package_all package_nsis)
    endif()

    if(CANDLE_EXECUTABLE AND LIGHT_EXECUTABLE)
        add_dependencies(package_all package_msi)
    endif()

    add_dependencies(package_all package_chocolatey package_winget package_portable_zip)
endif()

if(APPLE)
    if(MACDEPLOYQT_EXECUTABLE)
        add_dependencies(package_all package_dmg)
    endif()

    if(PRODUCTBUILD_EXECUTABLE AND PKGBUILD_EXECUTABLE)
        add_dependencies(package_all package_pkg)
    endif()

    add_dependencies(package_all package_homebrew package_macports)
endif()

if(UNIX AND NOT APPLE)
    if(LINUX_DISTRO STREQUAL "debian")
        add_dependencies(package_all package_deb)
    elseif(LINUX_DISTRO STREQUAL "redhat" OR LINUX_DISTRO STREQUAL "suse")
        add_dependencies(package_all package_rpm)
    elseif(LINUX_DISTRO STREQUAL "arch")
        add_dependencies(package_all package_arch)
    endif()

    if(LINUXDEPLOY_EXECUTABLE AND LINUXDEPLOY_PLUGIN_QT_EXECUTABLE)
        add_dependencies(package_all package_appimage)
    endif()

    if(SNAPCRAFT_EXECUTABLE)
        add_dependencies(package_all package_snap)
    endif()

    if(FLATPAK_BUILDER_EXECUTABLE)
        add_dependencies(package_all package_flatpak)
    endif()
endif()

# Cross-platform packages
if(DOCKER_EXECUTABLE)
    add_dependencies(package_all package_docker)
endif()

if(CONDA_BUILD_EXECUTABLE)
    add_dependencies(package_all package_conda)
endif()

if(BINARYCREATOR_EXECUTABLE)
    add_dependencies(package_all package_qtifw)
endif()

add_dependencies(package_all package_portable package_src)

# Cross-platform and container packaging

# Docker image generation
find_program(DOCKER_EXECUTABLE docker
    DOC "Docker executable"
)

if(DOCKER_EXECUTABLE)
    message(STATUS "Found Docker: ${DOCKER_EXECUTABLE}")

    # Generate Dockerfile
    configure_file(
        ${CMAKE_SOURCE_DIR}/packaging/docker/Dockerfile.in
        ${CMAKE_BINARY_DIR}/docker/Dockerfile
        @ONLY
    )

    # Docker image packaging target
    add_custom_target(package_docker
        COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG>
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_INSTALL_PREFIX} ${CMAKE_BINARY_DIR}/docker/app
        COMMAND ${DOCKER_EXECUTABLE} build -t ${PROJECT_NAME}:${PROJECT_VERSION} -t ${PROJECT_NAME}:latest ${CMAKE_BINARY_DIR}/docker
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Creating Docker image"
    )

    # Multi-architecture Docker build
    add_custom_target(package_docker_multiarch
        COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG>
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_INSTALL_PREFIX} ${CMAKE_BINARY_DIR}/docker/app
        COMMAND ${DOCKER_EXECUTABLE} buildx build --platform linux/amd64,linux/arm64 -t ${PROJECT_NAME}:${PROJECT_VERSION} -t ${PROJECT_NAME}:latest ${CMAKE_BINARY_DIR}/docker --push
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Creating multi-architecture Docker image"
    )
endif()

# Conda package support
find_program(CONDA_BUILD_EXECUTABLE conda-build
    DOC "conda-build executable"
)

if(CONDA_BUILD_EXECUTABLE)
    message(STATUS "Found conda-build: ${CONDA_BUILD_EXECUTABLE}")

    # Generate conda recipe
    configure_file(
        ${CMAKE_SOURCE_DIR}/packaging/conda/meta.yaml.in
        ${CMAKE_BINARY_DIR}/conda/meta.yaml
        @ONLY
    )

    # Conda packaging target
    add_custom_target(package_conda
        COMMAND ${CMAKE_COMMAND} --build . --target install --config $<CONFIG>
        COMMAND ${CONDA_BUILD_EXECUTABLE} ${CMAKE_BINARY_DIR}/conda
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Creating Conda package"
    )
endif()

# Architecture detection and multi-arch support
if(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64")
    set(PACKAGE_ARCH "x86_64" CACHE STRING "Package architecture")
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64|arm64")
    set(PACKAGE_ARCH "arm64" CACHE STRING "Package architecture")
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "armv7")
    set(PACKAGE_ARCH "armv7" CACHE STRING "Package architecture")
else()
    set(PACKAGE_ARCH "${CMAKE_SYSTEM_PROCESSOR}" CACHE STRING "Package architecture")
endif()

message(STATUS "Package architecture: ${PACKAGE_ARCH}")

# Universal packaging target that creates packages for current platform
add_custom_target(package_platform
    COMMENT "Creating platform-specific packages"
)

# Add platform-specific dependencies
if(WIN32)
    if(PLATFORM_MSYS2 AND NSIS_EXECUTABLE)
        add_dependencies(package_platform package_nsis_msys2 package_msys2_portable)
    elseif(NSIS_EXECUTABLE)
        add_dependencies(package_platform package_nsis)
    endif()

    if(CANDLE_EXECUTABLE AND LIGHT_EXECUTABLE)
        add_dependencies(package_platform package_msi)
    endif()

    add_dependencies(package_platform package_portable_zip)

elseif(APPLE)
    if(MACDEPLOYQT_EXECUTABLE)
        add_dependencies(package_platform package_dmg)
    endif()

    if(PRODUCTBUILD_EXECUTABLE AND PKGBUILD_EXECUTABLE)
        add_dependencies(package_platform package_pkg)
    endif()

elseif(UNIX)
    if(LINUX_DISTRO STREQUAL "debian" AND CPACK_GENERATOR STREQUAL "DEB")
        add_dependencies(package_platform package_deb)
    elseif((LINUX_DISTRO STREQUAL "redhat" OR LINUX_DISTRO STREQUAL "suse") AND CPACK_GENERATOR STREQUAL "RPM")
        add_dependencies(package_platform package_rpm)
    elseif(LINUX_DISTRO STREQUAL "arch" AND MAKEPKG_EXECUTABLE)
        add_dependencies(package_platform package_arch)
    endif()

    if(LINUXDEPLOY_EXECUTABLE AND LINUXDEPLOY_PLUGIN_QT_EXECUTABLE)
        add_dependencies(package_platform package_appimage)
    endif()

    if(SNAPCRAFT_EXECUTABLE)
        add_dependencies(package_platform package_snap)
    endif()

    if(FLATPAK_BUILDER_EXECUTABLE)
        add_dependencies(package_platform package_flatpak)
    endif()
endif()

# Add cross-platform packages
if(DOCKER_EXECUTABLE)
    add_dependencies(package_platform package_docker)
endif()

if(CONDA_BUILD_EXECUTABLE)
    add_dependencies(package_platform package_conda)
endif()

# Package validation target
add_custom_target(validate_packages
    COMMAND ${CMAKE_COMMAND} -E echo "Validating packages..."
    # Add package validation commands here
    COMMENT "Validating created packages"
)
