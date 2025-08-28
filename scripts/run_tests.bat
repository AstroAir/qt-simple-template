@echo off
REM Test runner script for Windows
REM Provides convenient interface for running different types of tests

setlocal enabledelayedexpansion

set "BUILD_DIR="
set "TEST_TYPE=all"
set "VERBOSE="
set "PARALLEL=1"

REM Parse command line arguments
:parse_args
if "%~1"=="" goto :find_build_dir
if "%~1"=="--build-dir" (
    set "BUILD_DIR=%~2"
    shift
    shift
    goto :parse_args
)
if "%~1"=="--type" (
    set "TEST_TYPE=%~2"
    shift
    shift
    goto :parse_args
)
if "%~1"=="--verbose" (
    set "VERBOSE=--verbose"
    shift
    goto :parse_args
)
if "%~1"=="-v" (
    set "VERBOSE=--verbose"
    shift
    goto :parse_args
)
if "%~1"=="--parallel" (
    set "PARALLEL=%~2"
    shift
    shift
    goto :parse_args
)
if "%~1"=="-j" (
    set "PARALLEL=%~2"
    shift
    shift
    goto :parse_args
)
shift
goto :parse_args

:find_build_dir
if not "%BUILD_DIR%"=="" goto :check_build_dir

REM Find build directory
if exist "build\Debug-Windows" (
    set "BUILD_DIR=build\Debug-Windows"
    goto :check_build_dir
)
if exist "build\Release-Windows" (
    set "BUILD_DIR=build\Release-Windows"
    goto :check_build_dir
)
if exist "build\Debug" (
    set "BUILD_DIR=build\Debug"
    goto :check_build_dir
)
if exist "build\Release" (
    set "BUILD_DIR=build\Release"
    goto :check_build_dir
)
if exist "build" (
    set "BUILD_DIR=build"
    goto :check_build_dir
)

echo Error: Could not find build directory
exit /b 1

:check_build_dir
if not exist "%BUILD_DIR%" (
    echo Error: Build directory %BUILD_DIR% does not exist
    exit /b 1
)

echo Using build directory: %BUILD_DIR%

REM Prepare CTest command
set "CTEST_CMD=ctest"

if not "%VERBOSE%"=="" (
    set "CTEST_CMD=%CTEST_CMD% %VERBOSE%"
)

if not "%PARALLEL%"=="1" (
    set "CTEST_CMD=%CTEST_CMD% -j %PARALLEL%"
)

REM Add test filters based on type
if "%TEST_TYPE%"=="unit" (
    set "CTEST_CMD=%CTEST_CMD% -R test_.*"
) else if "%TEST_TYPE%"=="integration" (
    set "CTEST_CMD=%CTEST_CMD% -R .*integration.*"
) else if "%TEST_TYPE%"=="benchmark" (
    set "CTEST_CMD=%CTEST_CMD% -R benchmark_.*"
)

REM Run tests
echo Running: %CTEST_CMD%
cd /d "%BUILD_DIR%"
%CTEST_CMD%

if %ERRORLEVEL% equ 0 (
    echo All tests passed!
    exit /b 0
) else (
    echo Some tests failed!
    exit /b 1
)
