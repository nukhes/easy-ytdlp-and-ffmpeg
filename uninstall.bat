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

echo complete.
echo yt-dlp and ffmpeg have been removed from your computer
ENDLOCAL