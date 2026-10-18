@echo off
setlocal enabledelayedexpansion

for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /i "IPv4"') do (
    set "ip=%%A"
    :: Strip the leading space
    set "ip=!ip:~1!"
    goto :found
)

if "%1"=="/server" goto :LaunchServer

:MainProcess
cls
echo ====================================================
echo             HTTPSERVER CONTROL PANEL
echo ====================================================
echo.
echo [Status] Servidor powered off
echo.
echo Pressione [S] to start server or [E] to EXIT.
echo.

choice /c se /n /m "Choose a option: "
if errorlevel 2 exit
if errorlevel 1 goto :StartServer

:StartServer
cls
echo ====================================================
echo             HTTPSERVER CONTROL PANEL
echo ====================================================
echo.
echo [Status] Starting server...

copy "%~f0" "server.cmd" >nul

start "Server" "server.cmd" /server

echo [Status] Server is running, WIFIServer is http://%ip%:8000/
echo.
echo ----------------------------------------------------
echo 	Press [P] on this window to STOP the server.
echo ----------------------------------------------------
echo.

choice /c p /n /m "Aguardando comando: "
if errorlevel 1 goto :StopServer

:StopServer
echo.
echo [Status] Stopping the server...

taskkill /fi "WINDOWTITLE eq Server*" /t /f >nul 2>&1

if exist "server.cmd" del "server.cmd"

echo [Status] Server stopped as SUCCESS.
timeout /t 2 >nul
goto :MainProcess


:LaunchServer
echo ====================================================
echo             PYTHON HTTPSERVER CONSOLE
echo ====================================================
echo.
python -m http.server 8000 --bind 0.0.0.0
exit
