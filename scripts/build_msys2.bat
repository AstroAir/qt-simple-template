@echo off
REM MSYS2 build script for Windows
REM This script launches the MSYS2 build process from Windows Command Prompt

setlocal enabledelayedexpansion

REM Default values
set "BUILD_TYPE=Debug"
set "MSYS2_PATH=C:\msys64"
set "MSYS2_ENV=MINGW64"
set "SCRIPT_ARGS="

REM Parse command line arguments
:parse_args
if "%~1"=="" goto :args_done
if "%~1"=="--build-type" (
    set "BUILD_TYPE=%~2"
    shift
    shift
    goto :parse_args
)
if "%~1"=="--msys2-path" (
    set "MSYS2_PATH=%~2"
    shift
    shift
    goto :parse_args
)
if "%~1"=="--msys2-env" (
    set "MSYS2_ENV=%~2"
    shift
    shift
    goto :parse_args
)
if "%~1"=="--help" (
    echo Usage: %0 [OPTIONS]
    echo Options:
    echo   --build-type TYPE     Build type (Debug^|Release) [default: Debug]
    echo   --msys2-path PATH     Path to MSYS2 installation [default: C:\msys64]
    echo   --msys2-env ENV       MSYS2 environment (MINGW64^|MINGW32^|UCRT64^|CLANG64) [default: MINGW64]
    echo   --help                Show this help message
    echo.
    echo Additional arguments are passed to the MSYS2 build script.
    exit /b 0
)
REM Collect remaining arguments
set "SCRIPT_ARGS=!SCRIPT_ARGS! %~1"
shift
goto :parse_args

:args_done

echo Qt Simple Template - MSYS2 Build Script
echo ==========================================

REM Check if MSYS2 is installed
if not exist "%MSYS2_PATH%\msys2_shell.cmd" (
    echo Error: MSYS2 not found at %MSYS2_PATH%
    echo.
    echo Please install MSYS2 from https://www.msys2.org/
    echo Or specify the correct path with --msys2-path
    exit /b 1
)

echo Found MSYS2 at: %MSYS2_PATH%
echo Using environment: %MSYS2_ENV%
echo Build type: %BUILD_TYPE%

REM Get the directory of this script
set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%.."

REM Convert Windows path to MSYS2 path
set "MSYS2_PROJECT_ROOT=%PROJECT_ROOT:\=/%"
set "MSYS2_PROJECT_ROOT=%MSYS2_PROJECT_ROOT:C:=/c%"

REM Prepare the command to run in MSYS2
set "MSYS2_COMMAND=cd '%MSYS2_PROJECT_ROOT%' && ./scripts/build_msys2.sh --build-type %BUILD_TYPE% %SCRIPT_ARGS%"

echo.
echo Starting MSYS2 build process...
echo Command: %MSYS2_COMMAND%
echo.

REM Launch MSYS2 with the build script
"%MSYS2_PATH%\msys2_shell.cmd" -%MSYS2_ENV% -c "%MSYS2_COMMAND%"

REM Check the exit code
if %errorlevel% equ 0 (
    echo.
    echo Build completed successfully!
) else (
    echo.
    echo Build failed with error code: %errorlevel%
    exit /b %errorlevel%
)

endlocal
