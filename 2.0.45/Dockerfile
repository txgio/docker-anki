# ubuntu 12.04 was the only version which had the lib libicu48, which is required by
# the Anki tar.bz2 or a warning will print on the console.
# I've tried to use ubuntu 14.04, debian:jessie and debian:stretch, but none of them included
# the libicu48, only newer versions.
#
# debian:wheezy included that lib, but the version of the libc was older than required (it was 2.13 but Anki was
# probably compiled against 2.14)
FROM ubuntu:12.04

RUN apt-get update && \

    # Pulseaudio is used to redirect the audio
    apt-get install -y pulseaudio && \

    # Desktop utilities required by Anki
    apt-get install -y xdg-utils && \

    # Audio and video tools required by Anki
    apt-get install -y mplayer lame sox && \

    # i18n lib required by Anki
    apt-get install -y libicu48 && \

    # Utilities to install Anki
    apt-get install -y wget build-essential && \

    # Install Anki
    wget -q --no-check-certificate https://apps.ankiweb.net/downloads/current/anki-2.0.45-amd64.tar.bz2 && \
    tar xjf anki-2.0.45-amd64.tar.bz2 && cd anki-2.0.45 && make install && cd .. && \
    rm anki-2.0.45-amd64.tar.bz2 && rm -rf anki-2.0.45 && \

    # Install locales, since UTF-8 is required by Anki
    apt-get install -y locales && \
    
    # Clean-up
    apt-get remove -y build-essential && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8

COPY entrypoint.sh /

RUN mkdir /data

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["anki", "-b", "/data"]