#!/usr/bin/env python3
"""
Conan build script for qt-simple-template
Automates the Conan build process with proper dependency management
"""

import argparse
import os
import subprocess
import sys
from pathlib import Path


def run_command(cmd, cwd=None, check=True):
    """Run a command and handle errors"""
    print(f"Running: {' '.join(cmd)}")
    try:
        result = subprocess.run(cmd, cwd=cwd, check=check,
                                capture_output=True, text=True)
        if result.stdout:
            print(result.stdout)
        return result
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {e}")
        if e.stderr:
            print(f"Error output: {e.stderr}")
        if check:
            sys.exit(1)
        return e


def check_conan_installed():
    """Check if Conan is installed"""
    try:
        result = subprocess.run(['conan', '--version'],
                                capture_output=True, text=True)
        print(f"Conan version: {result.stdout.strip()}")
        return True
    except FileNotFoundError:
        print("Error: Conan is not installed or not in PATH")
        print("Install Conan with: pip install conan")
        return False


def setup_conan_profile():
    """Set up Conan profile if it doesn't exist"""
    try:
        # Check if default profile exists
        result = subprocess.run(['conan', 'profile', 'show', 'default'],
                                capture_output=True, text=True)
        if result.returncode != 0:
            print("Creating default Conan profile...")
            run_command(['conan', 'profile', 'detect', '--force'])
        else:
            print("Using existing Conan profile")
    except Exception as e:
        print(f"Error setting up Conan profile: {e}")
        return False
    return True


def install_dependencies(build_type, build_dir):
    """Install Conan dependencies"""
    print(f"Installing Conan dependencies for {build_type}...")

    # Create build directory
    build_path = Path(build_dir)
    build_path.mkdir(parents=True, exist_ok=True)

    # Install dependencies
    conan_cmd = [
        'conan', 'install', '.',
        '--output-folder', str(build_path),
        '--build', 'missing',
        '--settings', f'build_type={build_type}'
    ]

    run_command(conan_cmd)


def configure_cmake(preset_name, build_dir):
    """Configure CMake with Conan"""
    print(f"Configuring CMake with preset: {preset_name}")

    # Check if we have the extended presets file
    if Path('CMakePresets-extended.json').exists():
        preset_file = 'CMakePresets-extended.json'
        cmake_cmd = ['cmake', '--preset',
                     preset_name, '--preset-file', preset_file]
    else:
        # Fallback to manual configuration
        cmake_cmd = [
            'cmake', '-S', '.', '-B', build_dir,
            '-G', 'Ninja',
            f'-DCMAKE_TOOLCHAIN_FILE={build_dir}/conan_toolchain.cmake',
            '-DUSE_CONAN=ON'
        ]

    run_command(cmake_cmd)


def build_project(preset_name, build_dir):
    """Build the project"""
    print(f"Building project with preset: {preset_name}")

    if Path('CMakePresets-extended.json').exists():
        cmake_cmd = ['cmake', '--build', '--preset', preset_name,
                     '--preset-file', 'CMakePresets-extended.json']
    else:
        cmake_cmd = ['cmake', '--build', build_dir]

    run_command(cmake_cmd)


def run_tests(build_dir):
    """Run tests"""
    print("Running tests...")
    test_cmd = ['ctest', '--test-dir', build_dir, '--output-on-failure']
    run_command(test_cmd, check=False)  # Don't fail if tests fail


def main():
    parser = argparse.ArgumentParser(
        description="Build qt-simple-template with Conan")
    parser.add_argument('--build-type', choices=['Debug', 'Release'], default='Debug',
                        help='Build type (default: Debug)')
    parser.add_argument('--preset', help='CMake preset to use')
    parser.add_argument('--build-dir', help='Build directory')
    parser.add_argument('--install-only', action='store_true',
                        help='Only install dependencies, do not build')
    parser.add_argument('--configure-only', action='store_true',
                        help='Only install and configure, do not build')
    parser.add_argument('--test', action='store_true',
                        help='Run tests after building')
    parser.add_argument('--clean', action='store_true',
                        help='Clean build directory before building')

    args = parser.parse_args()

    # Check prerequisites
    if not check_conan_installed():
        sys.exit(1)

    if not setup_conan_profile():
        sys.exit(1)

    # Determine build directory and preset
    if args.build_dir:
        build_dir = args.build_dir
    else:
        build_dir = f"build/Conan-{args.build_type}"

    if args.preset:
        preset_name = args.preset
    else:
        preset_name = f"Conan-{args.build_type}-Unix"
        if sys.platform == "win32":
            preset_name = f"Conan-{args.build_type}-Windows"

    # Clean if requested
    if args.clean:
        import shutil
        if Path(build_dir).exists():
            print(f"Cleaning build directory: {build_dir}")
            shutil.rmtree(build_dir)

    try:
        # Install dependencies
        install_dependencies(args.build_type, build_dir)

        if args.install_only:
            print("Dependencies installed successfully!")
            return

        # Configure CMake
        configure_cmake(preset_name, build_dir)

        if args.configure_only:
            print("Project configured successfully!")
            return

        # Build project
        build_project(preset_name, build_dir)

        # Run tests if requested
        if args.test:
            run_tests(build_dir)

        print("Build completed successfully!")

    except Exception as e:
        print(f"Build failed: {e}")
        sys.exit(1)


if __name__ == '__main__':
    main()
