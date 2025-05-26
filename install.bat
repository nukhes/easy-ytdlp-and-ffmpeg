@echo off
SETLOCAL

REM Caminho de destino para as ferramentas
SET TOOLS_DIR=C:\VideoTools

REM Links de download
SET YT_DLP_URL=https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe
SET FFMPEG_URL=https://github.com/GyanD/codexffmpeg/releases/download/7.1/ffmpeg-7.1-essentials_build.zip

REM Integração com o Explorer
if exist "%~dp0src\yt-dlp.reg" regedit /s "%~dp0src\yt-dlp.reg"
if exist "%~dp0src\ffmpeg.reg" regedit /s "%~dp0src\ffmpeg.reg"

REM Criar a pasta de destino
if not exist "%TOOLS_DIR%" (
    mkdir "%TOOLS_DIR%"
)

REM Baixar yt-dlp
echo Downloading yt-dlp...
powershell -Command "Invoke-WebRequest -Uri '%YT_DLP_URL%' -OutFile '%TOOLS_DIR%\\yt-dlp.exe'"

REM Baixar ffmpeg
echo Downloading ffmpeg...
powershell -Command "Invoke-WebRequest -Uri '%FFMPEG_URL%' -OutFile '%TOOLS_DIR%\\ffmpeg.zip'"

REM Extrair ffmpeg
echo Extracting ffmpeg...
powershell -Command "Expand-Archive -Path '%TOOLS_DIR%\\ffmpeg.zip' -DestinationPath '%TOOLS_DIR%' -Force"

REM Mover executáveis do ffmpeg
for /d %%D in ("%TOOLS_DIR%\ffmpeg-*") do (
    MOVE "%%D\bin\ffmpeg.exe" "%TOOLS_DIR%\ffmpeg.exe"
    MOVE "%%D\bin\ffplay.exe" "%TOOLS_DIR%\ffplay.exe"
    MOVE "%%D\bin\ffprobe.exe" "%TOOLS_DIR%\ffprobe.exe"
    rmdir /s /q "%%D"
)

REM Remover arquivos temporários
DEL "%TOOLS_DIR%\ffmpeg.zip"

REM Adicionar ao PATH
SET PATH=%PATH%;%TOOLS_DIR%
SETX PATH "%PATH%"

:: Import the .reg file to install
set "SCRIPT_DIR=%~dp0"
set "REG_FILE=%SCRIPT_DIR%\src\install.reg"
reg import "%REG_FILE%"

echo Installation Complete!
echo The binaries are in "%TOOLS_DIR%", and they can be accessed from any command prompt.
pause
ENDLOCAL
