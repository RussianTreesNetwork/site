@echo off
setlocal

set SERVER=26.76.84.234
set SHARE=Sync
set USERNAME=TAOS
set PASSWORD=9286

:: --- Очищаем старые подключения ---
net use * /delete /y >nul 2>&1

:: --- Подключаем сетевой диск Z: с аутентификацией ---
net use Z: \\%SERVER%\%SHARE% /user:%USERNAME% %PASSWORD% >nul 2>&1
if errorlevel 1 (
    echo Error: cannot connect to server.
    echo - Are you in Radmin VPN?
    echo - Is SMB enabled on server?
    echo - Check username/password: %USERNAME% / %PASSWORD%
    pause
    exit /b 1
)

:: --- Копируем RTN_Update.bat ---
set REMOTE_FILE=Z:\RTN_Update.bat
set LOCAL_FILE=RTN_Update.bat

if not exist "%REMOTE_FILE%" (
    echo Error: RTN_Update.bat not found on server.
    pause
    net use Z: /delete >nul 2>&1
    exit /b 1
)

copy "%REMOTE_FILE%" "%LOCAL_FILE%" >nul

if errorlevel 1 (
    echo Error: failed to download RTN_Update.bat
    pause
    net use Z: /delete >nul 2>&1
    exit /b 1
)

:: --- Отключаем диск ---
net use Z: /delete >nul 2>&1

:: --- Запускаем скрипт ---
echo Running RTN_Update.bat...
call "%LOCAL_FILE%"

pause