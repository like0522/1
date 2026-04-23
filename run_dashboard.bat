@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title [PRO-V4.5] Dashboard Server Manager

echo ========================================================
echo   PRO-V4.5 PRODUCTION ANALYSIS SYSTEM
echo ========================================================
echo.

:: 1. Check Python
echo [1/3] Checking Python environment...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ALERT] Python NOT found. Starting auto-installer...
    curl -L -o py_setup.exe "https://www.python.org/ftp/python/3.12.3/python-3.12.3-amd64.exe"
    if not exist py_setup.exe (
        echo [ERROR] Download failed. Check your internet.
        pause
        exit /b
    )
    start /wait py_setup.exe /quiet InstallAllUsers=0 PrependPath=1
    del py_setup.exe
    echo [DONE] Python installed. Please RESTART this file.
    pause
    exit /b
)

:: 2. Check Port
echo [2/3] Checking available port...
set PORT=8000
:check_port
netstat -ano | findstr /R /C:":%PORT% " >nul
if %errorlevel% equ 0 (
    echo [INFO] Port %PORT% is busy, trying next...
    set /a PORT=%PORT% + 1
    goto check_port
)

:: 3. Run Server
echo [3/3] Starting server on port %PORT%...
echo --------------------------------------------------------
echo [STATUS] Server is RUNNING.
echo [INFO] DO NOT close this window during use.
echo --------------------------------------------------------

:: Launch server and browser
start /b cmd /c "python -m http.server %PORT% >nul 2>&1"
timeout /t 2 >nul
start http://localhost:%PORT%/index.html

:: Keep-alive
:loop
timeout /t 10 >nul
goto loop
