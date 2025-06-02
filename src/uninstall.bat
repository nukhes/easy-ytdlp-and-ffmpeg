@echo off
SETLOCAL
SET TOOLS_DIR=C:\video-tools

IF NOT EXIST "%TOOLS_DIR%" (
	echo yt-dlp and ffmpeg are not installed.
	pause
	ENDLOCAL
)

rmdir /s /q "%TOOLS_DIR%"

reg delete "HKCR\Directory\Background\shell\YT-DLP" /f >nul 2>&1
reg delete "HKCR\*\shell\ffmpeg" /f >nul 2>&1

echo complete.
echo yt-dlp and ffmpeg have been removed from your computer
ENDLOCAL