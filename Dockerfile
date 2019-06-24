# Unfortunately VLC does not work on nanoserver
FROM mcr.microsoft.com/windows/servercore:1809

# Copy and unzip VLC
COPY vlc-{vlc.version}.zip C:\\vlc.zip
RUN cmd /C tar -xf C:\\vlc.zip & del vlc.zip

# Image config
WORKDIR C:\\vlc-{vlc.version}
ENTRYPOINT .\vlc.exe