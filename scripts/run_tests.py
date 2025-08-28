#!/usr/bin/env python3
"""
Test runner script for qt-simple-template
Provides convenient interface for running different types of tests
"""

import argparse
import subprocess
import sys
import os
from pathlib import Path


def run_command(cmd, cwd=None):
    """Run a command and return the result"""
    print(f"Running: {' '.join(cmd)}")
    try:
        result = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)
        if result.stdout:
            print(result.stdout)
        if result.stderr:
            print(result.stderr, file=sys.stderr)
        return result.returncode == 0
    except Exception as e:
        print(f"Error running command: {e}", file=sys.stderr)
        return False


def find_build_dir():
    """Find the build directory"""
    possible_dirs = [
        "build/Debug",
        "build/Release",
        "build/Debug-Windows",
        "build/Release-Windows",
        "build"
    ]

    for dir_path in possible_dirs:
        if os.path.exists(dir_path):
            return dir_path

    return None


def main():
    parser = argparse.ArgumentParser(
        description="Run tests for qt-simple-template")
    parser.add_argument("--type", choices=["unit", "integration", "benchmark", "all"],
                        default="all", help="Type of tests to run")
    parser.add_argument("--build-dir", help="Build directory path")
    parser.add_argument("--verbose", "-v",
                        action="store_true", help="Verbose output")
    parser.add_argument("--parallel", "-j", type=int,
                        default=1, help="Number of parallel jobs")

    args = parser.parse_args()

    # Find build directory
    build_dir = args.build_dir or find_build_dir()
    if not build_dir:
        print("Error: Could not find build directory", file=sys.stderr)
        return 1

    if not os.path.exists(build_dir):
        print(
            f"Error: Build directory {build_dir} does not exist", file=sys.stderr)
        return 1

    print(f"Using build directory: {build_dir}")

    # Prepare CTest command
    ctest_cmd = ["ctest"]

    if args.verbose:
        ctest_cmd.append("--verbose")

    if args.parallel > 1:
        ctest_cmd.extend(["-j", str(args.parallel)])

    # Add test filters based on type
    if args.type == "unit":
        ctest_cmd.extend(["-R", "test_.*"])
    elif args.type == "integration":
        ctest_cmd.extend(["-R", ".*integration.*"])
    elif args.type == "benchmark":
        ctest_cmd.extend(["-R", "benchmark_.*"])

    # Run tests
    success = run_command(ctest_cmd, cwd=build_dir)

    if success:
        print("All tests passed!")
        return 0
    else:
        print("Some tests failed!", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
