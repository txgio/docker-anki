FROM ubuntu:16.04

RUN apt-get update && \

    # Pulseaudio is used to redirect the audio
    apt-get install -y pulseaudio && \

    # Desktop utilities required by Anki
    apt-get install -y xdg-utils && \

    # Audio tools required by Anki
    apt-get install -y mplayer lame sox && \

    # Dependencies required by Anki
    apt-get install -y libnss3 libxcb-xfixes0 libwayland-server0 libwayland-client0 && \

    # Utilities to install Anki
    apt-get install -y wget build-essential && \

    # Install Anki
    wget -q --no-check-certificate https://apps.ankiweb.net/downloads/beta/anki-2.1.0beta14-amd64.tar.bz2 && \
    tar xjf anki-2.1.0beta14-amd64.tar.bz2 && cd anki-2.1.0beta14-amd64 && make install && cd .. && \
    rm anki-2.1.0beta14-amd64.tar.bz2 && rm -rf anki-2.1.0beta14-amd64 && \

    # Install locales, since UTF-8 is required by Anki
    apt-get install -y locales && \

    # Clean-up
    apt-get remove -y build-essential && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8

# Force Qt to use software acceleration for OpenGL
ENV QMLSCENE_DEVICE softwarecontext

# Configuration for the keyboard input
ENV QT_XKB_CONFIG_ROOT=/usr/share/X11/xkb

ENV LANG en_US.UTF-8

COPY entrypoint.sh /

RUN mkdir /data

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["anki", "-b", "/data"]