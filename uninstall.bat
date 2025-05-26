@echo off
SETLOCAL
SET TOOLS_DIR=C:\video-tools

:: Import the .reg file to uninstall
set "SCRIPT_DIR=%~dp0"
set "REG_FILE=%SCRIPT_DIR%\src\uninstall.reg"
reg import "%REG_FILE%"

IF NOT EXIST "%TOOLS_DIR%" (
	echo yt-dlp and ffmpeg are not installed.
	pause
	ENDLOCAL
)

rmdir /s /q "%TOOLS_DIR%"

echo complete.
echo yt-dlp and ffmpeg have been removed from your computer
ENDLOCAL