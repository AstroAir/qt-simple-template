#!/usr/bin/env python3
"""
Template customization script for qt-simple-template
Allows easy customization of the template for new projects
"""

import argparse
import json
import os
import re
import shutil
import sys
from pathlib import Path
from typing import Dict, Any, List

class TemplateCustomizer:
    def __init__(self, template_config_path: str = "template.json"):
        """Initialize the template customizer"""
        self.template_config_path = template_config_path
        self.config = self._load_config()
        self.variables = {}
        
    def _load_config(self) -> Dict[str, Any]:
        """Load template configuration"""
        try:
            with open(self.template_config_path, 'r', encoding='utf-8') as f:
                return json.load(f)
        except FileNotFoundError:
            print(f"Error: Template configuration file '{self.template_config_path}' not found")
            sys.exit(1)
        except json.JSONDecodeError as e:
            print(f"Error: Invalid JSON in template configuration: {e}")
            sys.exit(1)
    
    def _validate_variable(self, name: str, value: str) -> bool:
        """Validate a variable value against its configuration"""
        var_config = self.config['variables'].get(name, {})
        
        # Check required
        if var_config.get('required', False) and not value:
            print(f"Error: Variable '{name}' is required")
            return False
        
        # Check pattern
        pattern = var_config.get('pattern')
        if pattern and value and not re.match(pattern, value):
            print(f"Error: Variable '{name}' does not match required pattern: {pattern}")
            return False
        
        # Check choices
        choices = var_config.get('choices')
        if choices and value and value not in choices:
            print(f"Error: Variable '{name}' must be one of: {', '.join(choices)}")
            return False
        
        return True
    
    def _get_variable_value(self, name: str, args: argparse.Namespace) -> str:
        """Get variable value from args or prompt user"""
        var_config = self.config['variables'][name]
        
        # Check if provided via command line
        arg_name = name.lower().replace('_', '-')
        if hasattr(args, arg_name.replace('-', '_')):
            value = getattr(args, arg_name.replace('-', '_'))
            if value is not None:
                return str(value)
        
        # Prompt user if interactive mode
        if args.interactive:
            description = var_config.get('description', name)
            default = var_config.get('default', '')
            var_type = var_config.get('type', 'string')
            
            if var_type == 'boolean':
                prompt = f"{description} (y/n) [{default}]: "
                while True:
                    response = input(prompt).strip().lower()
                    if not response:
                        return str(default).lower()
                    if response in ['y', 'yes', 'true', '1']:
                        return 'true'
                    elif response in ['n', 'no', 'false', '0']:
                        return 'false'
                    else:
                        print("Please enter y/n")
            
            elif var_type == 'choice':
                choices = var_config.get('choices', [])
                prompt = f"{description} ({'/'.join(choices)}) [{default}]: "
                while True:
                    response = input(prompt).strip()
                    if not response:
                        return default
                    if response in choices:
                        return response
                    else:
                        print(f"Please choose from: {', '.join(choices)}")
            
            else:
                prompt = f"{description} [{default}]: "
                response = input(prompt).strip()
                return response if response else default
        
        # Use default value
        return var_config.get('default', '')
    
    def collect_variables(self, args: argparse.Namespace) -> Dict[str, str]:
        """Collect all template variables"""
        variables = {}
        
        for name, config in self.config['variables'].items():
            value = self._get_variable_value(name, args)
            
            if not self._validate_variable(name, value):
                sys.exit(1)
            
            variables[name] = value
        
        return variables
    
    def _replace_in_file(self, file_path: Path, variables: Dict[str, str]):
        """Replace template variables in a file"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Replace variables in format {{VARIABLE_NAME}}
            for name, value in variables.items():
                pattern = f"{{{{{name}}}}}"
                content = content.replace(pattern, value)
            
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
                
        except Exception as e:
            print(f"Error processing file {file_path}: {e}")
    
    def _process_template_files(self, variables: Dict[str, str]):
        """Process template files with variable substitution"""
        template_files = self.config.get('files', {}).get('templates', [])
        
        for template_info in template_files:
            source = template_info.get('source')
            target = template_info.get('target')
            
            if not source or not target:
                continue
            
            source_path = Path(source)
            target_path = Path(target)
            
            # If source template exists, use it; otherwise use target directly
            if source_path.exists():
                shutil.copy2(source_path, target_path)
                self._replace_in_file(target_path, variables)
            elif target_path.exists():
                self._replace_in_file(target_path, variables)
    
    def _process_conditional_files(self, variables: Dict[str, str]):
        """Process conditional file operations"""
        conditional_ops = self.config.get('files', {}).get('conditional', [])
        
        for op in conditional_ops:
            condition = op.get('condition', '')
            action = op.get('action', '')
            paths = op.get('paths', [])
            
            # Evaluate condition
            if self._evaluate_condition(condition, variables):
                if action == 'remove':
                    for path_pattern in paths:
                        self._remove_paths(path_pattern)
                elif action == 'modify':
                    print(f"Manual action required: {op.get('description', 'Modify files')}")
    
    def _evaluate_condition(self, condition: str, variables: Dict[str, str]) -> bool:
        """Evaluate a condition string"""
        if not condition:
            return False
        
        # Simple condition evaluation (extend as needed)
        # Format: "VARIABLE == value" or "VARIABLE != value"
        parts = condition.split()
        if len(parts) == 3:
            var_name, operator, value = parts
            var_value = variables.get(var_name, '')
            
            if operator == '==':
                return var_value == value
            elif operator == '!=':
                return var_value != value
        
        return False
    
    def _remove_paths(self, path_pattern: str):
        """Remove files/directories matching pattern"""
        import glob
        
        for path in glob.glob(path_pattern):
            path_obj = Path(path)
            try:
                if path_obj.is_file():
                    path_obj.unlink()
                    print(f"Removed file: {path}")
                elif path_obj.is_dir():
                    shutil.rmtree(path_obj)
                    print(f"Removed directory: {path}")
            except Exception as e:
                print(f"Error removing {path}: {e}")
    
    def _run_post_generation_commands(self, variables: Dict[str, str]):
        """Run post-generation commands"""
        import subprocess
        import platform
        
        commands = self.config.get('post_generation', [])
        current_platform = 'windows' if platform.system() == 'Windows' else 'unix'
        
        for cmd_info in commands:
            command = cmd_info.get('command', '')
            cmd_platform = cmd_info.get('platform', 'all')
            optional = cmd_info.get('optional', True)
            description = cmd_info.get('description', command)
            
            # Skip if platform doesn't match
            if cmd_platform != 'all' and cmd_platform != current_platform:
                continue
            
            print(f"Running: {description}")
            try:
                result = subprocess.run(command, shell=True, capture_output=True, text=True)
                if result.returncode == 0:
                    print(f"✓ {description}")
                else:
                    print(f"✗ {description}: {result.stderr}")
                    if not optional:
                        sys.exit(1)
            except Exception as e:
                print(f"✗ {description}: {e}")
                if not optional:
                    sys.exit(1)
    
    def customize(self, args: argparse.Namespace):
        """Main customization process"""
        print("Qt Simple Template Customizer")
        print("=" * 40)
        
        # Collect variables
        variables = self.collect_variables(args)
        
        # Show summary
        if args.interactive:
            print("\nCustomization Summary:")
            for name, value in variables.items():
                print(f"  {name}: {value}")
            
            confirm = input("\nProceed with customization? (y/n): ").strip().lower()
            if confirm not in ['y', 'yes']:
                print("Customization cancelled")
                return
        
        # Process template files
        print("\nProcessing template files...")
        self._process_template_files(variables)
        
        # Process conditional operations
        print("Processing conditional operations...")
        self._process_conditional_files(variables)
        
        # Run post-generation commands
        if not args.skip_commands:
            print("Running post-generation commands...")
            self._run_post_generation_commands(variables)
        
        print("\n✓ Template customization completed!")
        print(f"Your project '{variables.get('APP_NAME', 'Unknown')}' is ready for development.")

def main():
    parser = argparse.ArgumentParser(description="Customize qt-simple-template for your project")
    
    # Add arguments for each template variable
    parser.add_argument('--project-name', help='Technical project name')
    parser.add_argument('--app-name', help='User-friendly application name')
    parser.add_argument('--project-description', help='Project description')
    parser.add_argument('--author-name', help='Author name')
    parser.add_argument('--author-email', help='Author email')
    parser.add_argument('--project-website', help='Project website')
    parser.add_argument('--project-version', help='Initial version')
    parser.add_argument('--copyright-year', help='Copyright year')
    parser.add_argument('--license-type', help='License type')
    parser.add_argument('--qt-version', help='Qt version requirement')
    parser.add_argument('--cmake-version', help='CMake version requirement')
    parser.add_argument('--cpp-standard', help='C++ standard')
    parser.add_argument('--package-manager', help='Package manager to use')
    parser.add_argument('--compiler-toolchain', help='Compiler toolchain preference')

    # Boolean flags
    parser.add_argument('--enable-testing', action='store_true', help='Enable testing')
    parser.add_argument('--disable-testing', action='store_true', help='Disable testing')
    parser.add_argument('--enable-docs', action='store_true', help='Enable documentation')
    parser.add_argument('--disable-docs', action='store_true', help='Disable documentation')
    parser.add_argument('--enable-i18n', action='store_true', help='Enable internationalization')
    parser.add_argument('--disable-i18n', action='store_true', help='Disable internationalization')
    parser.add_argument('--enable-themes', action='store_true', help='Enable themes')
    parser.add_argument('--disable-themes', action='store_true', help='Disable themes')
    
    # Control options
    parser.add_argument('--interactive', '-i', action='store_true', 
                       help='Interactive mode (prompt for missing values)')
    parser.add_argument('--config', help='Template configuration file')
    parser.add_argument('--skip-commands', action='store_true',
                       help='Skip post-generation commands')
    
    args = parser.parse_args()
    
    # Handle boolean flags
    if args.disable_testing:
        args.enable_testing = False
    if args.disable_docs:
        args.enable_docs = False
    if args.disable_i18n:
        args.enable_i18n = False
    if args.disable_themes:
        args.enable_themes = False
    
    # Initialize customizer
    config_file = args.config or 'template.json'
    customizer = TemplateCustomizer(config_file)
    
    # Run customization
    customizer.customize(args)

if __name__ == '__main__':
    main()
