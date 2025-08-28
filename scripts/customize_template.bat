@echo off
REM Template customization script for Windows
REM Wrapper for the Python customization script

setlocal enabledelayedexpansion

REM Check if Python is available
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Python is not installed or not in PATH
    echo Please install Python 3.6 or later
    exit /b 1
)

REM Get script directory
set "SCRIPT_DIR=%~dp0"
set "PYTHON_SCRIPT=%SCRIPT_DIR%customize_template.py"

REM Check if Python script exists
if not exist "%PYTHON_SCRIPT%" (
    echo Error: customize_template.py not found in %SCRIPT_DIR%
    exit /b 1
)

REM Run Python script with all arguments
python "%PYTHON_SCRIPT%" %*

REM Exit with the same code as Python script
exit /b %errorlevel%
