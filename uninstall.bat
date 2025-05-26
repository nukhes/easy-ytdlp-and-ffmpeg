@echo off
SETLOCAL
SET TOOLS_DIR=C:\video-tools
$regFile = Join-Path -Path $PSScriptRoot -ChildPath "src\uninstall.reg"

IF NOT EXIST "%TOOLS_DIR%" (
	echo yt-dlp and ffmpeg are not installed.
	pause
	ENDLOCAL
)

rmdir /s /q "%TOOLS_DIR%"
Start-Process reg.exe -ArgumentList "import `"$regFile`"" -Verb RunAs -Wait

echo complete.
echo yt-dlp and ffmpeg have been removed from your computer
ENDLOCAL