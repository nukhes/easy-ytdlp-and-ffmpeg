@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM Caminho de destino para as ferramentas
SET TOOLS_DIR=C:\VideoTools

REM Links de download
SET YT_DLP_URL=https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe
SET FFMPEG_URL=https://github.com/GyanD/codexffmpeg/releases/download/7.1/ffmpeg-7.1-essentials_build.zip

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

REM Adicionar ao PATH (apenas para o usuário atual)
SET PATH=%PATH%;%TOOLS_DIR%
SETX PATH "%PATH%"

REM ------------------------------
REM Adicionar entradas no Registro
REM ------------------------------

echo Configurando menu de contexto no registro...

REM Remover entradas antigas
reg delete "HKCR\Directory\Background\shell\YT-DLP" /f >nul 2>&1
reg delete "HKCR\*\shell\ffmpeg" /f >nul 2>&1

REM yt-dlp (contexto de diretório)
reg add "HKCR\Directory\Background\shell\YT-DLP" /ve /d "yt-dlp" /f
reg add "HKCR\Directory\Background\shell\YT-DLP" /v "SubCommands" /d "" /f
reg add "HKCR\Directory\Background\shell\YT-DLP\shell" /f

REM H.264 downloads
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\a_h264" /v "MUIVerb" /d "Download video (H.264)" /f
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\a_h264" /v "SubCommands" /d "" /f
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\a_h264" /v "Icon" /d "imageres.dll,18" /f
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\a_h264\shell\a_best" /ve /d "Best quality" /f
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\a_h264\shell\a_best\command" /ve /d "powershell.exe -Command yt-dlp $(Get-Clipboard) --continue --no-check-certificate --format=bestvideo+bestaudio[ext=m4a]/best --merge-output-format=mp4 \"" /f

reg add "HKCR\Directory\Background\shell\YT-DLP\shell\a_h264\shell\b_1080p" /ve /d "1080p" /f
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\a_h264\shell\b_1080p\command" /ve /d "powershell.exe -Command yt-dlp $(Get-Clipboard) --continue --no-check-certificate --format=bestvideo[height<=1080]+bestaudio[ext=m4a]/best --merge-output-format=mp4 -o '%%(title)s_1080.%%(ext)s' \"" /f

reg add "HKCR\Directory\Background\shell\YT-DLP\shell\a_h264\shell\c_720p" /ve /d "720p" /f
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\a_h264\shell\c_720p\command" /ve /d "powershell.exe -Command yt-dlp $(Get-Clipboard) --continue --no-check-certificate --format=bestvideo[height<=720]+bestaudio[ext=m4a]/best --merge-output-format=mp4 -o '%%(title)s_720.%%(ext)s' \"" /f

REM DNxHR
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\b_dnxhr" /ve /d "Download video (DNxHR 25 FPS)" /f
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\b_dnxhr" /v "Icon" /d "imageres.dll,41" /f
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\b_dnxhr\command" /ve /d "powershell.exe -Command yt-dlp $(Get-Clipboard) --continue --no-check-certificate --format=bestvideo+bestaudio --exec='ffmpeg -i {} -c:v dnxhd -profile:v dnxhr_lb -vf fps=25/1,format=yuv422p -c:a pcm_s16le {}.mov & del {}'\"" /f

REM MP3
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\c_mp3" /ve /d "Download audio (MP3)" /f
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\c_mp3" /v "Icon" /d "imageres.dll,103" /f
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\c_mp3\command" /ve /d "powershell.exe -Command yt-dlp $(Get-Clipboard) --continue --no-check-certificate -f bestaudio -x --audio-format mp3\"" /f

REM WAV
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\d_wav" /ve /d "Download audio (WAV)" /f
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\d_wav" /v "Icon" /d "imageres.dll,80" /f
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\d_wav\command" /ve /d "powershell.exe -Command yt-dlp $(Get-Clipboard) --continue --no-check-certificate -f bestaudio -x --audio-format wav\"" /f

REM Playlist MP4
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\e_playlist" /ve /d "Download playlist (H.264)" /f
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\e_playlist" /v "Icon" /d "imageres.dll,97" /f
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\e_playlist\command" /ve /d "powershell.exe -Command yt-dlp $(Get-Clipboard) --continue --no-check-certificate --yes-playlist -o '%%(playlist)s/%%(playlist_index)s - %%(title)s.%%(ext)s' -i --continue --format=bestvideo+bestaudio[ext=m4a]/best --merge-output-format=mp4\"" /f

REM Playlist MP3
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\f_playlist_mp3" /ve /d "Download playlist (MP3)" /f
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\f_playlist_mp3" /v "Icon" /d "imageres.dll,128" /f
reg add "HKCR\Directory\Background\shell\YT-DLP\shell\f_playlist_mp3\command" /ve /d "powershell.exe -Command yt-dlp $(Get-Clipboard) --continue --no-check-certificate --yes-playlist -o '%%(playlist)s/%%(playlist_index)s - %%(title)s.%%(ext)s' -i --continue -f bestaudio -x --audio-format mp3\"" /f

REM ffmpeg context menu para qualquer arquivo
reg add "HKCR\*\shell\ffmpeg" /v "MUIVerb" /d "ffmpeg" /f
reg add "HKCR\*\shell\ffmpeg" /v "SubCommands" /d "" /f
reg add "HKCR\*\shell\ffmpeg" /v "MultiSelectModel" /d "Document" /f

reg add "HKCR\*\shell\ffmpeg\shell\audio_wav" /ve /d "Convert to WAV" /f
reg add "HKCR\*\shell\ffmpeg\shell\audio_wav" /v "Icon" /d "imageres.dll,103" /f
reg add "HKCR\*\shell\ffmpeg\shell\audio_wav\command" /ve /d "powershell.exe -Command ffmpeg -i '%%1' '%%1_conv.wav'" /f

reg add "HKCR\*\shell\ffmpeg\shell\audio_mp3" /ve /d "Convert to MP3" /f
reg add "HKCR\*\shell\ffmpeg\shell\audio_mp3" /v "Icon" /d "imageres.dll,103" /f
reg add "HKCR\*\shell\ffmpeg\shell\audio_mp3\command" /ve /d "powershell.exe -Command ffmpeg -i '%%1' '%%1_conv.mp3'" /f

reg add "HKCR\*\shell\ffmpeg\shell\video_dnxhr" /ve /d "Convert to DNxHR 25 FPS" /f
reg add "HKCR\*\shell\ffmpeg\shell\video_dnxhr" /v "Icon" /d "imageres.dll,18" /f
reg add "HKCR\*\shell\ffmpeg\shell\video_dnxhr\command" /ve /d "powershell.exe -Command ffmpeg -i '%%1' -c:v dnxhd -profile:v dnxhr_hq -vf fps=25/1,format=yuv422p -c:a pcm_s16le '%%1_conv.mov'" /f

reg add "HKCR\*\shell\ffmpeg\shell\video_mp4" /ve /d "Convert to MP4 H.264" /f
reg add "HKCR\*\shell\ffmpeg\shell\video_mp4" /v "Icon" /d "imageres.dll,18" /f
reg add "HKCR\*\shell\ffmpeg\shell\video_mp4\command" /ve /d "powershell.exe -Command ffmpeg -i '%%1' '%%1_conv.mp4'" /f

echo.
echo Installation complete!
echo yt-dlp and ffmpeg installed to "%TOOLS_DIR%"
echo Context menu entries were added successfully.
pause
ENDLOCAL
