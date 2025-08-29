# Qt6 EntryPoint target conflict fix for MSYS2/MinGW systems
# This file provides a workaround for the duplicate EntryPointMinGW32 target issue

# Final approach: Force ignore the Qt6 EntryPoint mechanism entirely
if(WIN32 AND CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    # Set environment variable to disable Qt6 EntryPoint
    set(ENV{QT_NO_ENTRYPOINT} "1")

    # Create a dummy EntryPointMinGW32 target that does nothing
    if(NOT TARGET EntryPointMinGW32)
        add_library(EntryPointMinGW32 INTERFACE)
        # Don't set any properties - just create an empty interface library
        message(STATUS "Created dummy EntryPointMinGW32 target to prevent Qt6 conflicts")
    endif()

    message(STATUS "Applied Qt6 EntryPoint bypass workaround")
endif()
