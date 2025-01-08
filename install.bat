@echo off
SETLOCAL

REM Explorer Integration
regedit /s "%~dp0\src\yt-dlp.reg"
regedit /s "%~dp0\src\ffmpeg.reg"

REM Define the download URLs
SET YT_DLP_URL=https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe
SET FFMPEG_URL=https://github.com/GyanD/codexffmpeg/releases/download/7.1/ffmpeg-7.1-essentials_build.zip

REM Create the folder
SET TOOLS_DIR=C:\video-tools
IF NOT EXIST "%TOOLS_DIR%" (
    mkdir "%TOOLS_DIR%"
)

REM Download YT-DLP
echo Downloading yt-dlp...
powershell -Command "Invoke-WebRequest -Uri %YT_DLP_URL% -OutFile '%TOOLS_DIR%\yt-dlp.exe'"

REM Download FFMPEG
echo Downloading ffmpeg...
powershell -Command "Invoke-WebRequest -Uri %FFMPEG_URL% -OutFile '%TOOLS_DIR%\ffmpeg.zip'"

REM Extract FFMPEG
echo Extracting ffmpeg...
powershell -Command "Expand-Archive -Path '%TOOLS_DIR%\ffmpeg.zip' -DestinationPath '%TOOLS_DIR%' -Force"

REM Move o executável do FFMPEG para a pasta principal
SET FFMPEG_BIN_DIR=%TOOLS_DIR%\ffmpeg-*-essentials_build.zip\bin
MOVE "%FFMPEG_BIN_DIR%\ffmpeg.exe" "%TOOLS_DIR%\ffmpeg.exe"
MOVE "%FFMPEG_BIN_DIR%\ffplay.exe" "%TOOLS_DIR%\ffplay.exe"
MOVE "%FFMPEG_BIN_DIR%\ffprobe.exe" "%TOOLS_DIR%\ffprobe.exe"

REM Remove a pasta extra e o arquivo .7z
rmdir /s /q "%TOOLS_DIR%\ffmpeg-*-essentials_build"
DEL "%TOOLS_DIR%\ffmpeg.zip"

REM Add to PATH
SETX PATH "%PATH%;%TOOLS_DIR%"

echo Installation Complete, the binaries are in "C:\video-tools", they can be accessed from any command prompt or via the convenient shortcuts in Windows Explorer, an uninstall script is located in the same directory.

ENDLOCAL
pause
