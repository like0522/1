@echo off
echo [Server] Checking Python...

python --version >nul 2>&1
if %errorlevel% equ 0 goto start_server

echo.
echo ========================================================
echo [Notice] Python is not installed or not in PATH.
echo [Notice] Starting automatic installation of Python 3.12...
echo ========================================================
echo.

echo [1/3] Downloading Python installer...
curl -L -o python_installer.exe "https://www.python.org/ftp/python/3.12.3/python-3.12.3-amd64.exe"

if not exist python_installer.exe (
    echo [ERROR] Failed to download Python installer.
    echo Please install Python manually from https://www.python.org/downloads/
    pause
    exit /b
)

echo [2/3] Installing Python... (This may take 1-2 minutes)
start /wait python_installer.exe /quiet InstallAllUsers=0 PrependPath=1 Include_test=0

echo [3/3] Cleaning up...
del python_installer.exe

echo.
echo ========================================================
echo [SUCCESS] Python installation is complete!
echo [ACTION REQUIRED] Please CLOSE this black window and run the bat file AGAIN.
echo ========================================================
pause
exit /b

:start_server
echo [Server] Starting server...
start "Local Dashboard Server" cmd /k "python -m http.server 8000 || echo [ERROR] Failed to start server. Port 8000 might be in use. && pause"

echo [Server] Opening browser in 2 seconds...
timeout /t 2 > nul
start http://localhost:8000/index.html
exit
