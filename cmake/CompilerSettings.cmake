# Compiler-specific settings for qt-simple-template

# Detect compiler
if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(COMPILER_MSVC TRUE)
    set(COMPILER_NAME "MSVC")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(COMPILER_GCC TRUE)
    set(COMPILER_NAME "GCC")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    set(COMPILER_CLANG TRUE)
    set(COMPILER_NAME "Clang")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
    set(COMPILER_APPLE_CLANG TRUE)
    set(COMPILER_NAME "Apple Clang")
else()
    set(COMPILER_NAME "Unknown")
endif()

message(STATUS "Using compiler: ${COMPILER_NAME} ${CMAKE_CXX_COMPILER_VERSION}")

# Common compiler flags
set(COMMON_COMPILE_FLAGS "")
set(COMMON_LINK_FLAGS "")

# Debug flags
set(DEBUG_COMPILE_FLAGS "")
set(DEBUG_LINK_FLAGS "")

# Release flags
set(RELEASE_COMPILE_FLAGS "")
set(RELEASE_LINK_FLAGS "")

# MSVC-specific settings
if(COMPILER_MSVC)
    # Warning level and specific warnings
    list(APPEND COMMON_COMPILE_FLAGS
        /W4                     # High warning level
        /w14242                 # 'identifier': conversion from 'type1' to 'type1', possible loss of data
        /w14254                 # 'operator': conversion from 'type1:field_bits' to 'type1:field_bits'
        /w14263                 # 'function': member function does not override any base class virtual member function
        /w14265                 # 'classname': class has virtual functions, but destructor is not virtual
        /w14287                 # 'operator': unsigned/negative constant mismatch
        /we4289                 # nonstandard extension used: 'variable': loop control variable declared in the for-loop is used outside the for-loop scope
        /w14296                 # 'operator': expression is always 'boolean_value'
        /w14311                 # 'variable': pointer truncation from 'type1' to 'type2'
        /w14545                 # expression before comma evaluates to a function which is missing an argument list
        /w14546                 # function call before comma missing argument list
        /w14547                 # 'operator': operator before comma has no effect; expected operator with side-effect
        /w14549                 # 'operator': operator before comma has no effect; did you intend 'operator'?
        /w14555                 # expression has no effect; expected expression with side-effect
        /w14619                 # pragma warning: there is no warning number 'number'
        /w14640                 # Enable warning on thread un-safe static member initialization
        /w14826                 # Conversion from 'type1' to 'type_2' is sign-extended
        /w14905                 # wide string literal cast to 'LPSTR'
        /w14906                 # string literal cast to 'LPWSTR'
        /w14928                 # illegal copy-initialization; more than one user-defined conversion has been implicitly applied
        /permissive-            # standards conformance mode for MSVC compiler
    )
    
    # Debug flags
    list(APPEND DEBUG_COMPILE_FLAGS /Od /Zi /RTC1)
    list(APPEND DEBUG_LINK_FLAGS /DEBUG)
    
    # Release flags
    list(APPEND RELEASE_COMPILE_FLAGS /O2 /Ob2 /DNDEBUG)
    
    # Enable parallel compilation
    list(APPEND COMMON_COMPILE_FLAGS /MP)
    
    # UTF-8 source and execution character sets
    list(APPEND COMMON_COMPILE_FLAGS /utf-8)
endif()

# GCC-specific settings
if(COMPILER_GCC)
    # Warning flags
    list(APPEND COMMON_COMPILE_FLAGS
        -Wall
        -Wextra
        -Wshadow
        -Wnon-virtual-dtor
        -Wold-style-cast
        -Wcast-align
        -Wunused
        -Woverloaded-virtual
        -Wpedantic
        -Wconversion
        -Wsign-conversion
        -Wmisleading-indentation
        -Wduplicated-cond
        -Wduplicated-branches
        -Wlogical-op
        -Wnull-dereference
        -Wuseless-cast
        -Wdouble-promotion
        -Wformat=2
    )
    
    # Debug flags
    list(APPEND DEBUG_COMPILE_FLAGS -Og -g3 -ggdb)
    
    # Release flags
    list(APPEND RELEASE_COMPILE_FLAGS -O3 -DNDEBUG)
    
    # Link time optimization for release builds
    if(CMAKE_BUILD_TYPE STREQUAL "Release")
        list(APPEND RELEASE_COMPILE_FLAGS -flto)
        list(APPEND RELEASE_LINK_FLAGS -flto)
    endif()
endif()

# Clang-specific settings
if(COMPILER_CLANG OR COMPILER_APPLE_CLANG)
    # Warning flags
    list(APPEND COMMON_COMPILE_FLAGS
        -Wall
        -Wextra
        -Wshadow
        -Wnon-virtual-dtor
        -Wold-style-cast
        -Wcast-align
        -Wunused
        -Woverloaded-virtual
        -Wpedantic
        -Wconversion
        -Wsign-conversion
        -Wmisleading-indentation
        -Wnull-dereference
        -Wdouble-promotion
        -Wformat=2
    )
    
    # Debug flags
    list(APPEND DEBUG_COMPILE_FLAGS -Og -g -glldb)
    
    # Release flags
    list(APPEND RELEASE_COMPILE_FLAGS -O3 -DNDEBUG)
    
    # Link time optimization for release builds
    if(CMAKE_BUILD_TYPE STREQUAL "Release")
        list(APPEND RELEASE_COMPILE_FLAGS -flto)
        list(APPEND RELEASE_LINK_FLAGS -flto)
    endif()
endif()

# Sanitizer support
if(ENABLE_SANITIZERS AND CMAKE_BUILD_TYPE STREQUAL "Debug")
    if(COMPILER_GCC OR COMPILER_CLANG OR COMPILER_APPLE_CLANG)
        message(STATUS "Enabling sanitizers")
        list(APPEND DEBUG_COMPILE_FLAGS
            -fsanitize=address
            -fsanitize=undefined
            -fno-sanitize-recover=all
            -fsanitize-address-use-after-scope
        )
        list(APPEND DEBUG_LINK_FLAGS
            -fsanitize=address
            -fsanitize=undefined
        )
    endif()
endif()

# Code coverage support
if(ENABLE_COVERAGE AND CMAKE_BUILD_TYPE STREQUAL "Debug")
    if(COMPILER_GCC OR COMPILER_CLANG)
        message(STATUS "Enabling code coverage")
        list(APPEND DEBUG_COMPILE_FLAGS --coverage -fprofile-arcs -ftest-coverage)
        list(APPEND DEBUG_LINK_FLAGS --coverage)
    endif()
endif()

# Apply compiler flags
if(COMMON_COMPILE_FLAGS)
    add_compile_options(${COMMON_COMPILE_FLAGS})
endif()

if(COMMON_LINK_FLAGS)
    add_link_options(${COMMON_LINK_FLAGS})
endif()

# Apply debug flags
if(DEBUG_COMPILE_FLAGS)
    foreach(flag ${DEBUG_COMPILE_FLAGS})
        add_compile_options($<$<CONFIG:Debug>:${flag}>)
    endforeach()
endif()

if(DEBUG_LINK_FLAGS)
    foreach(flag ${DEBUG_LINK_FLAGS})
        add_link_options($<$<CONFIG:Debug>:${flag}>)
    endforeach()
endif()

# Apply release flags
if(RELEASE_COMPILE_FLAGS)
    foreach(flag ${RELEASE_COMPILE_FLAGS})
        add_compile_options($<$<CONFIG:Release>:${flag}>)
        add_compile_options($<$<CONFIG:RelWithDebInfo>:${flag}>)
        add_compile_options($<$<CONFIG:MinSizeRel>:${flag}>)
    endforeach()
endif()

if(RELEASE_LINK_FLAGS)
    foreach(flag ${RELEASE_LINK_FLAGS})
        add_link_options($<$<CONFIG:Release>:${flag}>)
        add_link_options($<$<CONFIG:RelWithDebInfo>:${flag}>)
        add_link_options($<$<CONFIG:MinSizeRel>:${flag}>)
    endforeach()
endif()

# Static analysis
if(ENABLE_STATIC_ANALYSIS)
    # clang-tidy
    find_program(CLANG_TIDY_EXE NAMES "clang-tidy")
    if(CLANG_TIDY_EXE)
        message(STATUS "Found clang-tidy: ${CLANG_TIDY_EXE}")
        set(CMAKE_CXX_CLANG_TIDY "${CLANG_TIDY_EXE};-checks=-*,readability-*,performance-*,modernize-*,bugprone-*")
    endif()
    
    # cppcheck
    find_program(CPPCHECK_EXE NAMES "cppcheck")
    if(CPPCHECK_EXE)
        message(STATUS "Found cppcheck: ${CPPCHECK_EXE}")
        set(CMAKE_CXX_CPPCHECK "${CPPCHECK_EXE};--enable=warning,performance,portability;--inline-suppr;--suppressions-list=${CMAKE_SOURCE_DIR}/.cppcheck-suppressions")
    endif()
endif()

# Export compiler variables
set(COMPILER_NAME ${COMPILER_NAME} CACHE STRING "Compiler name" FORCE)
set(COMPILER_MSVC ${COMPILER_MSVC} CACHE BOOL "MSVC compiler" FORCE)
set(COMPILER_GCC ${COMPILER_GCC} CACHE BOOL "GCC compiler" FORCE)
set(COMPILER_CLANG ${COMPILER_CLANG} CACHE BOOL "Clang compiler" FORCE)
set(COMPILER_APPLE_CLANG ${COMPILER_APPLE_CLANG} CACHE BOOL "Apple Clang compiler" FORCE)
