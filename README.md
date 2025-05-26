# yt-dlp and ffmpeg
This script installs yt-dlp and ffmpeg and integrates them into the context menu, making it possible to download videos and convert them without leaving Windows Explorer.

https://github.com/user-attachments/assets/5366885a-95f3-4b15-8397-9eb12ba1697f

# Features
- Install the ffmpeg and yt-dlp binaries directly from source.
- Create an entry in PATH.
- Explorer context menu integration.
- 
## Installation
Paste this in Windows Powershell (open as admin): 
```
Start-Process -FilePath "cmd.exe" -ArgumentList "/c curl -o install.bat https://raw.githubusercontent.com/nukhes/easy-ytdlp-and-ffmpeg/refs/heads/main/install.bat && install.bat" -Verb RunAs
```

or run the `.\install.bat` and grab a coffee, to uninstall run `.\uninstall.bat`.

## Acknowledgements
 - [Explorer Integration](https://github.com/notthebee/ytdl-explorer)
 - [yt-dlp](https://github.com/yt-dlp/yt-dlp)
 - [ffmpeg](https://github.com/FFmpeg/FFmpeg)

