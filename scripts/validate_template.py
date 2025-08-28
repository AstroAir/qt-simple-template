#!/usr/bin/env python3
"""
Template validation script for qt-simple-template
Validates that the template is properly configured and all files are present
"""

import json
import os
import sys
from pathlib import Path
from typing import Dict, List, Any

class TemplateValidator:
    def __init__(self, template_config_path: str = "template.json"):
        """Initialize the template validator"""
        self.template_config_path = template_config_path
        self.config = self._load_config()
        self.errors = []
        self.warnings = []
    
    def _load_config(self) -> Dict[str, Any]:
        """Load template configuration"""
        try:
            with open(self.template_config_path, 'r', encoding='utf-8') as f:
                return json.load(f)
        except FileNotFoundError:
            self.errors.append(f"Template configuration file '{self.template_config_path}' not found")
            return {}
        except json.JSONDecodeError as e:
            self.errors.append(f"Invalid JSON in template configuration: {e}")
            return {}
    
    def validate_config_structure(self):
        """Validate the structure of the template configuration"""
        required_sections = ['template', 'variables', 'files']
        
        for section in required_sections:
            if section not in self.config:
                self.errors.append(f"Missing required section: {section}")
        
        # Validate template section
        if 'template' in self.config:
            template_info = self.config['template']
            required_fields = ['name', 'version', 'description']
            
            for field in required_fields:
                if field not in template_info:
                    self.errors.append(f"Missing required field in template section: {field}")
        
        # Validate variables section
        if 'variables' in self.config:
            for var_name, var_config in self.config['variables'].items():
                if not isinstance(var_config, dict):
                    self.errors.append(f"Variable '{var_name}' configuration must be a dictionary")
                    continue
                
                if 'type' not in var_config:
                    self.warnings.append(f"Variable '{var_name}' missing type specification")
                
                if 'description' not in var_config:
                    self.warnings.append(f"Variable '{var_name}' missing description")
    
    def validate_template_files(self):
        """Validate that template files exist and are properly configured"""
        if 'files' not in self.config:
            return
        
        files_config = self.config['files']
        
        # Validate template files
        if 'templates' in files_config:
            for template_info in files_config['templates']:
                if not isinstance(template_info, dict):
                    self.errors.append("Template file configuration must be a dictionary")
                    continue
                
                source = template_info.get('source')
                target = template_info.get('target')
                
                if not source or not target:
                    self.errors.append("Template file must specify both 'source' and 'target'")
                    continue
                
                # Check if source template file exists
                source_path = Path(source)
                target_path = Path(target)
                
                if source_path.exists():
                    # Validate template file content
                    self._validate_template_file_content(source_path, template_info.get('variables', []))
                elif target_path.exists():
                    # Target exists but no template - this is okay for in-place replacement
                    self._validate_template_file_content(target_path, template_info.get('variables', []))
                else:
                    self.errors.append(f"Neither template source '{source}' nor target '{target}' exists")
    
    def _validate_template_file_content(self, file_path: Path, expected_variables: List[str]):
        """Validate template file content for variable usage"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Find all template variables in the file
            import re
            variables_in_file = set(re.findall(r'\{\{(\w+)\}\}', content))
            
            # Check if expected variables are used
            for var in expected_variables:
                if var not in variables_in_file:
                    self.warnings.append(f"Variable '{var}' expected in '{file_path}' but not found")
            
            # Check if all variables in file are defined
            defined_variables = set(self.config.get('variables', {}).keys())
            for var in variables_in_file:
                if var not in defined_variables:
                    self.errors.append(f"Undefined variable '{var}' used in '{file_path}'")
        
        except Exception as e:
            self.errors.append(f"Error reading template file '{file_path}': {e}")
    
    def validate_project_structure(self):
        """Validate that the project has the expected structure"""
        expected_files = [
            'CMakeLists.txt',
            'vcpkg.json',
            'README.md',
            'LICENSE',
            'app/CMakeLists.txt',
            'app/main.cpp',
            'app/Widget.h',
            'app/Widget.cpp',
            'app/config.h.in',
            'controls/CMakeLists.txt',
            'controls/Slider.h',
            'controls/Slider.cpp'
        ]
        
        for file_path in expected_files:
            if not Path(file_path).exists():
                self.warnings.append(f"Expected file not found: {file_path}")
        
        expected_dirs = [
            'app',
            'controls',
            'assets',
            'tests',
            'docs',
            'scripts'
        ]
        
        for dir_path in expected_dirs:
            if not Path(dir_path).is_dir():
                self.warnings.append(f"Expected directory not found: {dir_path}")
    
    def validate_cmake_configuration(self):
        """Validate CMake configuration"""
        cmake_file = Path('CMakeLists.txt')
        if not cmake_file.exists():
            self.errors.append("CMakeLists.txt not found")
            return
        
        try:
            with open(cmake_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Check for required CMake components
            required_components = [
                'cmake_minimum_required',
                'project(',
                'find_package(Qt6',
                'add_subdirectory(app)',
                'add_subdirectory(controls)'
            ]
            
            for component in required_components:
                if component not in content:
                    self.warnings.append(f"CMakeLists.txt missing: {component}")
        
        except Exception as e:
            self.errors.append(f"Error reading CMakeLists.txt: {e}")
    
    def validate_vcpkg_configuration(self):
        """Validate vcpkg configuration"""
        vcpkg_file = Path('vcpkg.json')
        if not vcpkg_file.exists():
            self.errors.append("vcpkg.json not found")
            return
        
        try:
            with open(vcpkg_file, 'r', encoding='utf-8') as f:
                vcpkg_config = json.load(f)
            
            # Check required fields
            required_fields = ['name', 'version', 'dependencies']
            for field in required_fields:
                if field not in vcpkg_config:
                    self.errors.append(f"vcpkg.json missing required field: {field}")
            
            # Check for Qt dependencies
            dependencies = vcpkg_config.get('dependencies', [])
            qt_deps = ['qtbase', 'qtsvg']
            
            for dep in qt_deps:
                if dep not in [d if isinstance(d, str) else d.get('name') for d in dependencies]:
                    self.warnings.append(f"vcpkg.json missing Qt dependency: {dep}")
        
        except json.JSONDecodeError as e:
            self.errors.append(f"Invalid JSON in vcpkg.json: {e}")
        except Exception as e:
            self.errors.append(f"Error reading vcpkg.json: {e}")
    
    def validate_test_structure(self):
        """Validate test structure"""
        tests_dir = Path('tests')
        if not tests_dir.is_dir():
            self.warnings.append("Tests directory not found")
            return
        
        expected_test_dirs = ['unit', 'integration', 'benchmarks']
        for test_dir in expected_test_dirs:
            test_path = tests_dir / test_dir
            if not test_path.is_dir():
                self.warnings.append(f"Test directory not found: {test_path}")
        
        # Check for test CMakeLists.txt
        test_cmake = tests_dir / 'CMakeLists.txt'
        if not test_cmake.exists():
            self.errors.append("tests/CMakeLists.txt not found")
    
    def validate_documentation_structure(self):
        """Validate documentation structure"""
        docs_dir = Path('docs')
        if not docs_dir.is_dir():
            self.warnings.append("Documentation directory not found")
            return
        
        expected_doc_dirs = ['api', 'user-guide', 'developer-guide', 'template-guide']
        for doc_dir in expected_doc_dirs:
            doc_path = docs_dir / doc_dir
            if not doc_path.is_dir():
                self.warnings.append(f"Documentation directory not found: {doc_path}")
    
    def validate(self) -> bool:
        """Run all validations and return True if valid"""
        print("Validating qt-simple-template...")
        print("=" * 40)
        
        self.validate_config_structure()
        self.validate_template_files()
        self.validate_project_structure()
        self.validate_cmake_configuration()
        self.validate_vcpkg_configuration()
        self.validate_test_structure()
        self.validate_documentation_structure()
        
        # Report results
        if self.errors:
            print(f"\n❌ Validation failed with {len(self.errors)} error(s):")
            for error in self.errors:
                print(f"  • {error}")
        
        if self.warnings:
            print(f"\n⚠️  {len(self.warnings)} warning(s):")
            for warning in self.warnings:
                print(f"  • {warning}")
        
        if not self.errors and not self.warnings:
            print("\n✅ Template validation passed!")
        elif not self.errors:
            print(f"\n✅ Template validation passed with {len(self.warnings)} warning(s)")
        
        return len(self.errors) == 0

def main():
    import argparse
    
    parser = argparse.ArgumentParser(description="Validate qt-simple-template configuration")
    parser.add_argument('--config', help='Template configuration file', default='template.json')
    parser.add_argument('--strict', action='store_true', help='Treat warnings as errors')
    
    args = parser.parse_args()
    
    validator = TemplateValidator(args.config)
    is_valid = validator.validate()
    
    if args.strict and validator.warnings:
        print("\n❌ Strict mode: treating warnings as errors")
        is_valid = False
    
    sys.exit(0 if is_valid else 1)

if __name__ == '__main__':
    main()
