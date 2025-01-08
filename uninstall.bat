@echo off
SETLOCAL
SET TOOLS_DIR=C:\video-tools
IF NOT EXIST "%TOOLS_DIR%" (
	echo yt-dlp and ffmpeg are not installed.
	pause
	ENDLOCAL
)

rmdir /s /q "%TOOLS_DIR%"
regedit /s "%~dp0\src\uninstall.reg"

REM Get the current PATH
set "OLD_PATH=%PATH%"

REM Define the TOOLS_DIR you want to remove
set "TOOLS_DIR=C:\path\to\tools"

REM Remove the TOOLS_DIR from the PATH
set "NEW_PATH="
for %%i in ("%OLD_PATH:;=" "%") do (
    if /I not "%%~i"=="%TOOLS_DIR%" (
        set "NEW_PATH=!NEW_PATH!%%~i;"
    )
)

REM Remove the trailing semicolon
set "NEW_PATH=!NEW_PATH:~0,-1!"

REM Update the PATH
SETX PATH "!NEW_PATH!"

ENDLOCAL