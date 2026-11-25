@echo off
setlocal
set "SCRIPT_DIR=%~dp0"
set "BASH_EXE="

if exist "%ProgramFiles%\Git\bin\bash.exe" set "BASH_EXE=%ProgramFiles%\Git\bin\bash.exe"
if not defined BASH_EXE if exist "%ProgramFiles(x86)%\Git\bin\bash.exe" set "BASH_EXE=%ProgramFiles(x86)%\Git\bin\bash.exe"
if not defined BASH_EXE if exist "%LocalAppData%\Programs\Git\bin\bash.exe" set "BASH_EXE=%LocalAppData%\Programs\Git\bin\bash.exe"

if defined BASH_EXE (
    "%BASH_EXE%" "%SCRIPT_DIR%status.sh" %*
    exit /b %ERRORLEVEL%
)

wsl.exe -l -q >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    wsl.exe bash "status.sh" %*
    exit /b %ERRORLEVEL%
)

echo ERROR: Neither Git Bash nor an installed WSL Linux distribution was found.
exit /b 1
