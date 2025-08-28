# Documentation CMakeLists.txt for qt-simple-template

# Find Doxygen
find_package(Doxygen OPTIONAL_COMPONENTS dot)

if(DOXYGEN_FOUND)
    message(STATUS "Doxygen found: ${DOXYGEN_EXECUTABLE}")
    
    # Set Doxygen configuration
    set(DOXYGEN_PROJECT_NAME "${PROJECT_NAME}")
    set(DOXYGEN_PROJECT_NUMBER "${PROJECT_VERSION}")
    set(DOXYGEN_PROJECT_BRIEF "${PROJECT_DESCRIPTION}")
    set(DOXYGEN_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/doxygen")
    
    # Input directories
    set(DOXYGEN_INPUT 
        "${CMAKE_SOURCE_DIR}/app"
        "${CMAKE_SOURCE_DIR}/controls"
    )
    
    # File patterns
    set(DOXYGEN_FILE_PATTERNS "*.cpp *.h *.hpp *.cxx *.hxx")
    
    # Exclude patterns
    set(DOXYGEN_EXCLUDE_PATTERNS 
        "*/build/*"
        "*/tests/*"
        "*/.git/*"
        "*/.*"
    )
    
    # Configuration options
    set(DOXYGEN_RECURSIVE YES)
    set(DOXYGEN_EXTRACT_ALL NO)
    set(DOXYGEN_EXTRACT_PRIVATE NO)
    set(DOXYGEN_EXTRACT_STATIC NO)
    set(DOXYGEN_GENERATE_LATEX NO)
    set(DOXYGEN_GENERATE_HTML YES)
    set(DOXYGEN_HTML_OUTPUT "html")
    set(DOXYGEN_GENERATE_TREEVIEW YES)
    set(DOXYGEN_USE_MDFILE_AS_MAINPAGE "${CMAKE_SOURCE_DIR}/README.md")
    
    # Diagrams
    if(DOXYGEN_DOT_FOUND)
        set(DOXYGEN_HAVE_DOT YES)
        set(DOXYGEN_CLASS_DIAGRAMS YES)
        set(DOXYGEN_COLLABORATION_GRAPH YES)
        set(DOXYGEN_INCLUDE_GRAPH YES)
        set(DOXYGEN_INCLUDED_BY_GRAPH YES)
        set(DOXYGEN_CALL_GRAPH NO)
        set(DOXYGEN_CALLER_GRAPH NO)
        set(DOXYGEN_GRAPHICAL_HIERARCHY YES)
        set(DOXYGEN_DIRECTORY_GRAPH YES)
    else()
        set(DOXYGEN_HAVE_DOT NO)
        message(STATUS "Graphviz dot not found - diagrams will be disabled")
    endif()
    
    # Create Doxygen target
    doxygen_add_docs(docs
        ${CMAKE_SOURCE_DIR}/app
        ${CMAKE_SOURCE_DIR}/controls
        ${CMAKE_SOURCE_DIR}/README.md
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "Generating API documentation with Doxygen"
    )
    
    # Install documentation
    install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/doxygen/html/
        DESTINATION ${CMAKE_INSTALL_DOCDIR}/api
        OPTIONAL
    )
    
else()
    message(STATUS "Doxygen not found - documentation target will not be available")
    
    # Create dummy target
    add_custom_target(docs
        COMMAND ${CMAKE_COMMAND} -E echo "Doxygen not found - cannot generate documentation"
        COMMENT "Documentation generation not available"
    )
endif()

# Additional documentation targets

# Markdown to HTML conversion (if pandoc is available)
find_program(PANDOC_EXECUTABLE pandoc)

if(PANDOC_EXECUTABLE)
    message(STATUS "Pandoc found: ${PANDOC_EXECUTABLE}")
    
    # Convert README to HTML
    add_custom_target(readme_html
        COMMAND ${PANDOC_EXECUTABLE} 
            ${CMAKE_SOURCE_DIR}/README.md 
            -o ${CMAKE_CURRENT_BINARY_DIR}/README.html
            --standalone
            --css=style.css
        DEPENDS ${CMAKE_SOURCE_DIR}/README.md
        COMMENT "Converting README.md to HTML"
    )
    
    # Convert all markdown files in docs
    file(GLOB_RECURSE MARKDOWN_FILES 
        "${CMAKE_SOURCE_DIR}/docs/*.md"
    )
    
    set(HTML_FILES "")
    foreach(MD_FILE ${MARKDOWN_FILES})
        get_filename_component(MD_NAME ${MD_FILE} NAME_WE)
        get_filename_component(MD_DIR ${MD_FILE} DIRECTORY)
        file(RELATIVE_PATH REL_DIR ${CMAKE_SOURCE_DIR}/docs ${MD_DIR})
        
        set(HTML_FILE "${CMAKE_CURRENT_BINARY_DIR}/${REL_DIR}/${MD_NAME}.html")
        list(APPEND HTML_FILES ${HTML_FILE})
        
        add_custom_command(
            OUTPUT ${HTML_FILE}
            COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/${REL_DIR}
            COMMAND ${PANDOC_EXECUTABLE}
                ${MD_FILE}
                -o ${HTML_FILE}
                --standalone
                --css=../style.css
            DEPENDS ${MD_FILE}
            COMMENT "Converting ${MD_FILE} to HTML"
        )
    endforeach()
    
    add_custom_target(docs_html
        DEPENDS ${HTML_FILES}
        COMMENT "Converting all documentation to HTML"
    )
    
    # Install HTML documentation
    install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/
        DESTINATION ${CMAKE_INSTALL_DOCDIR}
        FILES_MATCHING PATTERN "*.html"
        OPTIONAL
    )
    
else()
    message(STATUS "Pandoc not found - Markdown to HTML conversion not available")
endif()

# Documentation validation
add_custom_target(validate_docs
    COMMAND ${CMAKE_COMMAND} -E echo "Validating documentation..."
    # Add documentation validation commands here
    COMMENT "Validating documentation"
)

# Documentation packaging
add_custom_target(package_docs
    COMMAND ${CMAKE_COMMAND} -E tar czf ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}-docs.tar.gz
        ${CMAKE_CURRENT_BINARY_DIR}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "Creating documentation package"
)

# All documentation target
add_custom_target(docs_all
    COMMENT "Building all documentation"
)

add_dependencies(docs_all docs)

if(PANDOC_EXECUTABLE)
    add_dependencies(docs_all docs_html readme_html)
endif()

# Documentation server (if Python is available)
find_program(PYTHON_EXECUTABLE python3 python)

if(PYTHON_EXECUTABLE)
    add_custom_target(serve_docs
        COMMAND ${PYTHON_EXECUTABLE} -m http.server 8000
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/doxygen/html
        COMMENT "Starting documentation server on http://localhost:8000"
    )
endif()
