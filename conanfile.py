from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMakeDeps, cmake_layout
from conan.tools.files import copy
import os


class QtSimpleTemplateConan(ConanFile):
    name = "qt-simple-template"
    version = "1.0.0"
    
    # Package metadata
    description = "A modern Qt6 application template with CMake, vcpkg, and CI/CD"
    topics = ("qt6", "cmake", "template", "cross-platform")
    homepage = "https://github.com/your-org/qt-simple-template"
    url = "https://github.com/your-org/qt-simple-template"
    license = "MIT"
    
    # Binary configuration
    settings = "os", "compiler", "build_type", "arch"
    options = {
        "shared": [True, False],
        "fPIC": [True, False],
        "with_tests": [True, False],
        "with_docs": [True, False],
        "with_i18n": [True, False],
        "with_themes": [True, False]
    }
    default_options = {
        "shared": False,
        "fPIC": True,
        "with_tests": True,
        "with_docs": True,
        "with_i18n": True,
        "with_themes": True
    }
    
    # Sources are located in the same place as this recipe, copy them to the recipe
    exports_sources = "CMakeLists.txt", "app/*", "controls/*", "assets/*", "cmake/*", "tests/*", "docs/*"
    
    def config_options(self):
        if self.settings.os == "Windows":
            del self.options.fPIC
    
    def configure(self):
        if self.options.shared:
            self.options.rm_safe("fPIC")
    
    def layout(self):
        cmake_layout(self)
    
    def requirements(self):
        # Qt6 dependencies
        self.requires("qt/6.7.0")
        
        # Additional Qt modules
        # Note: Conan Qt package includes most modules, but we can be specific
        # self.requires("qt6-svg/6.7.0")  # If available as separate package
        
    def build_requirements(self):
        self.tool_requires("cmake/[>=3.28]")
        if self.options.with_tests:
            # Qt Test is included in main Qt package
            pass
        if self.options.with_docs:
            # Doxygen for documentation
            self.tool_requires("doxygen/1.9.8")
    
    def generate(self):
        # Generate CMake toolchain and dependencies
        tc = CMakeToolchain(self)
        
        # Set CMake variables based on options
        tc.variables["BUILD_TESTING"] = self.options.with_tests
        tc.variables["BUILD_DOCS"] = self.options.with_docs
        tc.variables["ENABLE_I18N"] = self.options.with_i18n
        tc.variables["ENABLE_THEMES"] = self.options.with_themes
        
        # Set package manager identifier
        tc.variables["USING_CONAN"] = True
        
        tc.generate()
        
        # Generate CMake dependencies
        deps = CMakeDeps(self)
        deps.generate()
    
    def build(self):
        from conan.tools.cmake import CMake
        cmake = CMake(self)
        cmake.configure()
        cmake.build()
        
        # Run tests if enabled
        if self.options.with_tests:
            cmake.test()
    
    def package(self):
        from conan.tools.cmake import CMake
        cmake = CMake(self)
        cmake.install()
        
        # Copy license
        copy(self, "LICENSE", src=self.source_folder, dst=os.path.join(self.package_folder, "licenses"))
    
    def package_info(self):
        # Set package information
        self.cpp_info.libs = ["controls"]
        self.cpp_info.includedirs = ["include"]
        
        # Set CMake target names
        self.cpp_info.set_property("cmake_target_name", "qt-simple-template::controls")
        
        # Set CMake variables for consumers
        self.cpp_info.set_property("cmake_find_mode", "both")
        
        # Executable information
        bin_path = os.path.join(self.package_folder, "bin")
        self.cpp_info.bindirs = ["bin"]
        
        # Environment variables
        self.env_info.PATH.append(bin_path)
