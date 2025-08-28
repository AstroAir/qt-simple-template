# Package Manager Priority System for qt-simple-template
# This module implements priority-based package manager selection: MSYS2 → vcpkg → Conan

# Include MSYS2 detection module
include(MSYS2Detection)

# Initialize package manager priority variables
set(PACKAGE_MANAGER_SELECTED "" CACHE STRING "Selected package manager")
set(PACKAGE_MANAGER_PRIORITY_ORDER "MSYS2;VCPKG;CONAN" CACHE STRING "Package manager priority order")
set(USE_MSYS2 FALSE CACHE BOOL "Use MSYS2 package manager")
set(USE_VCPKG FALSE CACHE BOOL "Use vcpkg package manager")
set(USE_CONAN FALSE CACHE BOOL "Use Conan package manager")

# Function to detect vcpkg availability
function(detect_vcpkg_availability RESULT_VAR)
    set(VCPKG_AVAILABLE FALSE)
    
    # Check for vcpkg toolchain file
    if(DEFINED VCPKG_TOOLCHAIN OR DEFINED CMAKE_TOOLCHAIN_FILE)
        if(CMAKE_TOOLCHAIN_FILE MATCHES "vcpkg")
            set(VCPKG_AVAILABLE TRUE)
            message(STATUS "vcpkg toolchain detected: ${CMAKE_TOOLCHAIN_FILE}")
        endif()
    endif()
    
    # Check for VCPKG_ROOT environment variable
    if(NOT VCPKG_AVAILABLE AND DEFINED ENV{VCPKG_ROOT})
        if(EXISTS "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake")
            set(VCPKG_AVAILABLE TRUE)
            message(STATUS "vcpkg installation found: $ENV{VCPKG_ROOT}")
        endif()
    endif()
    
    # Check for vcpkg.json in project root
    if(NOT VCPKG_AVAILABLE AND EXISTS "${CMAKE_SOURCE_DIR}/vcpkg.json")
        set(VCPKG_AVAILABLE TRUE)
        message(STATUS "vcpkg manifest found: ${CMAKE_SOURCE_DIR}/vcpkg.json")
    endif()
    
    set(${RESULT_VAR} ${VCPKG_AVAILABLE} PARENT_SCOPE)
    
    if(VCPKG_AVAILABLE)
        message(STATUS "vcpkg package manager is available")
    else()
        message(STATUS "vcpkg package manager is not available")
    endif()
endfunction()

# Function to detect Conan availability
function(detect_conan_availability RESULT_VAR)
    set(CONAN_AVAILABLE FALSE)
    
    # Check for Conan toolchain file
    if(EXISTS "${CMAKE_BINARY_DIR}/conan_toolchain.cmake")
        set(CONAN_AVAILABLE TRUE)
        message(STATUS "Conan toolchain detected: ${CMAKE_BINARY_DIR}/conan_toolchain.cmake")
    endif()
    
    # Check for conanfile in project root
    if(NOT CONAN_AVAILABLE)
        if(EXISTS "${CMAKE_SOURCE_DIR}/conanfile.py" OR EXISTS "${CMAKE_SOURCE_DIR}/conanfile.txt")
            set(CONAN_AVAILABLE TRUE)
            message(STATUS "Conan manifest found in project root")
        endif()
    endif()
    
    # Check for Conan executable
    if(NOT CONAN_AVAILABLE)
        find_program(CONAN_EXECUTABLE conan DOC "Conan package manager")
        if(CONAN_EXECUTABLE)
            set(CONAN_AVAILABLE TRUE)
            message(STATUS "Conan executable found: ${CONAN_EXECUTABLE}")
        endif()
    endif()
    
    set(${RESULT_VAR} ${CONAN_AVAILABLE} PARENT_SCOPE)
    
    if(CONAN_AVAILABLE)
        message(STATUS "Conan package manager is available")
    else()
        message(STATUS "Conan package manager is not available")
    endif()
endfunction()

# Function to setup vcpkg environment
function(setup_vcpkg_environment)
    message(STATUS "Setting up vcpkg environment...")
    
    # Set vcpkg toolchain if not already set
    if(NOT CMAKE_TOOLCHAIN_FILE AND DEFINED ENV{VCPKG_ROOT})
        set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake" 
            CACHE FILEPATH "vcpkg toolchain file" FORCE)
        message(STATUS "Set vcpkg toolchain: ${CMAKE_TOOLCHAIN_FILE}")
    endif()
    
    # Set vcpkg specific variables
    set(VCPKG_TARGET_TRIPLET "" CACHE STRING "vcpkg target triplet")
    if(WIN32)
        if(CMAKE_SIZEOF_VOID_P EQUAL 8)
            set(VCPKG_TARGET_TRIPLET "x64-windows" CACHE STRING "vcpkg target triplet" FORCE)
        else()
            set(VCPKG_TARGET_TRIPLET "x86-windows" CACHE STRING "vcpkg target triplet" FORCE)
        endif()
    elseif(APPLE)
        set(VCPKG_TARGET_TRIPLET "x64-osx" CACHE STRING "vcpkg target triplet" FORCE)
    else()
        set(VCPKG_TARGET_TRIPLET "x64-linux" CACHE STRING "vcpkg target triplet" FORCE)
    endif()
    
    message(STATUS "vcpkg environment configured")
endfunction()

# Function to setup Conan environment
function(setup_conan_environment)
    message(STATUS "Setting up Conan environment...")
    
    # Include Conan toolchain if available
    if(EXISTS "${CMAKE_BINARY_DIR}/conan_toolchain.cmake")
        include("${CMAKE_BINARY_DIR}/conan_toolchain.cmake")
        message(STATUS "Included Conan toolchain: ${CMAKE_BINARY_DIR}/conan_toolchain.cmake")
    endif()
    
    # Set Conan specific variables
    set(USE_CONAN ON CACHE BOOL "Use Conan package manager" FORCE)
    
    message(STATUS "Conan environment configured")
endfunction()

# Function to select package manager based on priority
function(select_package_manager_by_priority)
    message(STATUS "Selecting package manager by priority...")

    # Check if a specific package manager is forced
    if(FORCE_PACKAGE_MANAGER)
        message(STATUS "Forced package manager: ${FORCE_PACKAGE_MANAGER}")

        if(FORCE_PACKAGE_MANAGER STREQUAL "MSYS2")
            initialize_msys2_detection()
            if(MSYS2_QT6_AVAILABLE)
                set(PACKAGE_MANAGER_SELECTED "MSYS2" CACHE STRING "Selected package manager" FORCE)
                set(USE_MSYS2 TRUE CACHE BOOL "Use MSYS2 package manager" FORCE)
                set(USE_VCPKG FALSE CACHE BOOL "Use vcpkg package manager" FORCE)
                set(USE_CONAN FALSE CACHE BOOL "Use Conan package manager" FORCE)
                message(STATUS "Forced selection: MSYS2 (system packages)")
            else()
                message(FATAL_ERROR "MSYS2 was forced but Qt6 packages are not available")
            endif()

        elseif(FORCE_PACKAGE_MANAGER STREQUAL "VCPKG")
            detect_vcpkg_availability(VCPKG_AVAILABLE)
            if(VCPKG_AVAILABLE)
                set(PACKAGE_MANAGER_SELECTED "VCPKG" CACHE STRING "Selected package manager" FORCE)
                set(USE_MSYS2 FALSE CACHE BOOL "Use MSYS2 package manager" FORCE)
                set(USE_VCPKG TRUE CACHE BOOL "Use vcpkg package manager" FORCE)
                set(USE_CONAN FALSE CACHE BOOL "Use Conan package manager" FORCE)
                setup_vcpkg_environment()
                message(STATUS "Forced selection: vcpkg")
            else()
                message(FATAL_ERROR "vcpkg was forced but is not available")
            endif()

        elseif(FORCE_PACKAGE_MANAGER STREQUAL "CONAN")
            detect_conan_availability(CONAN_AVAILABLE)
            if(CONAN_AVAILABLE)
                set(PACKAGE_MANAGER_SELECTED "CONAN" CACHE STRING "Selected package manager" FORCE)
                set(USE_MSYS2 FALSE CACHE BOOL "Use MSYS2 package manager" FORCE)
                set(USE_VCPKG FALSE CACHE BOOL "Use vcpkg package manager" FORCE)
                set(USE_CONAN TRUE CACHE BOOL "Use Conan package manager" FORCE)
                setup_conan_environment()
                message(STATUS "Forced selection: Conan")
            else()
                message(FATAL_ERROR "Conan was forced but is not available")
            endif()

        elseif(FORCE_PACKAGE_MANAGER STREQUAL "SYSTEM")
            set(PACKAGE_MANAGER_SELECTED "SYSTEM" CACHE STRING "Selected package manager" FORCE)
            set(USE_MSYS2 FALSE CACHE BOOL "Use MSYS2 package manager" FORCE)
            set(USE_VCPKG FALSE CACHE BOOL "Use vcpkg package manager" FORCE)
            set(USE_CONAN FALSE CACHE BOOL "Use Conan package manager" FORCE)
            message(STATUS "Forced selection: system packages")
        else()
            message(FATAL_ERROR "Invalid FORCE_PACKAGE_MANAGER value: ${FORCE_PACKAGE_MANAGER}. Valid values: MSYS2, VCPKG, CONAN, SYSTEM")
        endif()

    else()
        # Use priority-based selection
        message(STATUS "Priority order: ${PACKAGE_MANAGER_PRIORITY_ORDER}")

        # Initialize MSYS2 detection
        initialize_msys2_detection()

        # Detect availability of each package manager
        set(MSYS2_AVAILABLE ${MSYS2_QT6_AVAILABLE})
        detect_vcpkg_availability(VCPKG_AVAILABLE)
        detect_conan_availability(CONAN_AVAILABLE)

        # Select package manager based on priority and availability
        set(PACKAGE_MANAGER_FOUND FALSE)

        foreach(MANAGER ${PACKAGE_MANAGER_PRIORITY_ORDER})
            if(NOT PACKAGE_MANAGER_FOUND)
                if(MANAGER STREQUAL "MSYS2" AND MSYS2_AVAILABLE)
                    set(PACKAGE_MANAGER_SELECTED "MSYS2" CACHE STRING "Selected package manager" FORCE)
                    set(USE_MSYS2 TRUE CACHE BOOL "Use MSYS2 package manager" FORCE)
                    set(USE_VCPKG FALSE CACHE BOOL "Use vcpkg package manager" FORCE)
                    set(USE_CONAN FALSE CACHE BOOL "Use Conan package manager" FORCE)
                    set(PACKAGE_MANAGER_FOUND TRUE)
                    message(STATUS "Selected package manager: MSYS2 (system packages)")

                elseif(MANAGER STREQUAL "VCPKG" AND VCPKG_AVAILABLE)
                    set(PACKAGE_MANAGER_SELECTED "VCPKG" CACHE STRING "Selected package manager" FORCE)
                    set(USE_MSYS2 FALSE CACHE BOOL "Use MSYS2 package manager" FORCE)
                    set(USE_VCPKG TRUE CACHE BOOL "Use vcpkg package manager" FORCE)
                    set(USE_CONAN FALSE CACHE BOOL "Use Conan package manager" FORCE)
                    setup_vcpkg_environment()
                    set(PACKAGE_MANAGER_FOUND TRUE)
                    message(STATUS "Selected package manager: vcpkg")

                elseif(MANAGER STREQUAL "CONAN" AND CONAN_AVAILABLE)
                    set(PACKAGE_MANAGER_SELECTED "CONAN" CACHE STRING "Selected package manager" FORCE)
                    set(USE_MSYS2 FALSE CACHE BOOL "Use MSYS2 package manager" FORCE)
                    set(USE_VCPKG FALSE CACHE BOOL "Use vcpkg package manager" FORCE)
                    set(USE_CONAN TRUE CACHE BOOL "Use Conan package manager" FORCE)
                    setup_conan_environment()
                    set(PACKAGE_MANAGER_FOUND TRUE)
                    message(STATUS "Selected package manager: Conan")
                endif()
            endif()
        endforeach()

        # Fallback to system packages if no package manager is found
        if(NOT PACKAGE_MANAGER_FOUND)
            set(PACKAGE_MANAGER_SELECTED "SYSTEM" CACHE STRING "Selected package manager" FORCE)
            set(USE_MSYS2 FALSE CACHE BOOL "Use MSYS2 package manager" FORCE)
            set(USE_VCPKG FALSE CACHE BOOL "Use vcpkg package manager" FORCE)
            set(USE_CONAN FALSE CACHE BOOL "Use Conan package manager" FORCE)
            message(STATUS "No package manager found, using system packages")
        endif()
    endif()

    # Export variables for use in other CMake files
    set(PACKAGE_MANAGER_SELECTED ${PACKAGE_MANAGER_SELECTED} PARENT_SCOPE)
    set(USE_MSYS2 ${USE_MSYS2} PARENT_SCOPE)
    set(USE_VCPKG ${USE_VCPKG} PARENT_SCOPE)
    set(USE_CONAN ${USE_CONAN} PARENT_SCOPE)
endfunction()

# Function to configure Qt6 based on selected package manager
function(configure_qt6_for_package_manager)
    message(STATUS "Configuring Qt6 for package manager: ${PACKAGE_MANAGER_SELECTED}")
    
    if(USE_MSYS2)
        # MSYS2 Qt6 configuration is handled in MSYS2Detection.cmake
        message(STATUS "Using MSYS2 Qt6 packages")
        
    elseif(USE_VCPKG)
        # vcpkg Qt6 configuration
        message(STATUS "Using vcpkg Qt6 packages")
        
    elseif(USE_CONAN)
        # Conan Qt6 configuration
        message(STATUS "Using Conan Qt6 packages")
        
    else()
        # System Qt6 configuration
        message(STATUS "Using system Qt6 packages")
    endif()
endfunction()

# Function to handle fallback when primary package manager fails
function(handle_package_manager_fallback FAILED_MANAGER)
    message(WARNING "${FAILED_MANAGER} package manager failed or packages are missing")
    message(STATUS "Attempting fallback to next available package manager...")

    # Create a fallback priority list excluding the failed manager
    set(FALLBACK_PRIORITY "")
    foreach(MANAGER ${PACKAGE_MANAGER_PRIORITY_ORDER})
        if(NOT MANAGER STREQUAL FAILED_MANAGER)
            list(APPEND FALLBACK_PRIORITY ${MANAGER})
        endif()
    endforeach()

    message(STATUS "Fallback priority order: ${FALLBACK_PRIORITY}")

    # Try each fallback option
    set(FALLBACK_FOUND FALSE)
    foreach(MANAGER ${FALLBACK_PRIORITY})
        if(NOT FALLBACK_FOUND)
            if(MANAGER STREQUAL "MSYS2")
                initialize_msys2_detection()
                if(MSYS2_QT6_AVAILABLE)
                    set(PACKAGE_MANAGER_SELECTED "MSYS2" CACHE STRING "Selected package manager" FORCE)
                    set(USE_MSYS2 TRUE CACHE BOOL "Use MSYS2 package manager" FORCE)
                    set(USE_VCPKG FALSE CACHE BOOL "Use vcpkg package manager" FORCE)
                    set(USE_CONAN FALSE CACHE BOOL "Use Conan package manager" FORCE)
                    set(FALLBACK_FOUND TRUE)
                    message(STATUS "Fallback successful: MSYS2")
                endif()

            elseif(MANAGER STREQUAL "VCPKG")
                detect_vcpkg_availability(VCPKG_AVAILABLE)
                if(VCPKG_AVAILABLE)
                    set(PACKAGE_MANAGER_SELECTED "VCPKG" CACHE STRING "Selected package manager" FORCE)
                    set(USE_MSYS2 FALSE CACHE BOOL "Use MSYS2 package manager" FORCE)
                    set(USE_VCPKG TRUE CACHE BOOL "Use vcpkg package manager" FORCE)
                    set(USE_CONAN FALSE CACHE BOOL "Use Conan package manager" FORCE)
                    setup_vcpkg_environment()
                    set(FALLBACK_FOUND TRUE)
                    message(STATUS "Fallback successful: vcpkg")
                endif()

            elseif(MANAGER STREQUAL "CONAN")
                detect_conan_availability(CONAN_AVAILABLE)
                if(CONAN_AVAILABLE)
                    set(PACKAGE_MANAGER_SELECTED "CONAN" CACHE STRING "Selected package manager" FORCE)
                    set(USE_MSYS2 FALSE CACHE BOOL "Use MSYS2 package manager" FORCE)
                    set(USE_VCPKG FALSE CACHE BOOL "Use vcpkg package manager" FORCE)
                    set(USE_CONAN TRUE CACHE BOOL "Use Conan package manager" FORCE)
                    setup_conan_environment()
                    set(FALLBACK_FOUND TRUE)
                    message(STATUS "Fallback successful: Conan")
                endif()
            endif()
        endif()
    endforeach()

    # Final fallback to system packages
    if(NOT FALLBACK_FOUND)
        set(PACKAGE_MANAGER_SELECTED "SYSTEM" CACHE STRING "Selected package manager" FORCE)
        set(USE_MSYS2 FALSE CACHE BOOL "Use MSYS2 package manager" FORCE)
        set(USE_VCPKG FALSE CACHE BOOL "Use vcpkg package manager" FORCE)
        set(USE_CONAN FALSE CACHE BOOL "Use Conan package manager" FORCE)
        message(STATUS "Final fallback: system packages")
    endif()

    # Export variables for use in other CMake files
    set(PACKAGE_MANAGER_SELECTED ${PACKAGE_MANAGER_SELECTED} PARENT_SCOPE)
    set(USE_MSYS2 ${USE_MSYS2} PARENT_SCOPE)
    set(USE_VCPKG ${USE_VCPKG} PARENT_SCOPE)
    set(USE_CONAN ${USE_CONAN} PARENT_SCOPE)
endfunction()

# Function to validate selected package manager
function(validate_package_manager_selection)
    message(STATUS "Validating package manager selection: ${PACKAGE_MANAGER_SELECTED}")

    if(USE_MSYS2)
        # Validate MSYS2 setup
        if(NOT MSYS2_DETECTED)
            message(FATAL_ERROR "MSYS2 selected but environment not detected")
        endif()
        if(NOT MSYS2_QT6_AVAILABLE)
            message(WARNING "MSYS2 selected but Qt6 packages are not available")
            suggest_msys2_package_installation()
            handle_package_manager_fallback("MSYS2")
        endif()

    elseif(USE_VCPKG)
        # Validate vcpkg setup
        detect_vcpkg_availability(VCPKG_AVAILABLE)
        if(NOT VCPKG_AVAILABLE)
            message(WARNING "vcpkg selected but not properly configured")
            handle_package_manager_fallback("VCPKG")
        endif()

    elseif(USE_CONAN)
        # Validate Conan setup
        detect_conan_availability(CONAN_AVAILABLE)
        if(NOT CONAN_AVAILABLE)
            message(WARNING "Conan selected but not properly configured")
            handle_package_manager_fallback("CONAN")
        endif()
    endif()

    message(STATUS "Package manager validation completed")
endfunction()

# Function to print package manager selection summary
function(print_package_manager_summary)
    message(STATUS "")
    message(STATUS "=== Package Manager Selection Summary ===")
    message(STATUS "Selected: ${PACKAGE_MANAGER_SELECTED}")

    if(MSYS2_DETECTED)
        message(STATUS "MSYS2 Environment: ${MSYS2_ENVIRONMENT}")
        message(STATUS "MSYS2 Qt6 Available: ${MSYS2_QT6_AVAILABLE}")
        if(NOT MSYS2_QT6_AVAILABLE AND DEFINED MSYS2_MISSING_PACKAGES)
            message(STATUS "MSYS2 Missing Packages: ${MSYS2_MISSING_PACKAGES}")
        endif()
    else()
        message(STATUS "MSYS2 Available: FALSE")
    endif()

    detect_vcpkg_availability(VCPKG_CHECK)
    message(STATUS "vcpkg Available: ${VCPKG_CHECK}")
    message(STATUS "vcpkg Selected: ${USE_VCPKG}")

    detect_conan_availability(CONAN_CHECK)
    message(STATUS "Conan Available: ${CONAN_CHECK}")
    message(STATUS "Conan Selected: ${USE_CONAN}")

    if(FORCE_PACKAGE_MANAGER)
        message(STATUS "Forced Selection: ${FORCE_PACKAGE_MANAGER}")
    endif()

    message(STATUS "========================================")
    message(STATUS "")
endfunction()

# Main function to initialize package manager priority system
function(initialize_package_manager_priority)
    message(STATUS "Initializing package manager priority system...")

    # Select package manager based on priority
    select_package_manager_by_priority()

    # Validate the selection and handle fallbacks if needed
    validate_package_manager_selection()

    # Configure Qt6 for selected package manager
    configure_qt6_for_package_manager()

    # Print summary
    print_package_manager_summary()

    message(STATUS "Package manager priority system initialized")
endfunction()
