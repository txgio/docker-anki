FROM txgio/anki:2.0.45

RUN apt-get update && \

    # Install Japanese fonts
    apt-get install -y fonts-vlgothic && \

    # Install Japanese IME support
    apt-get install -y ibus-anthy dbus-x11 x11-xkb-utils && \
    rm -rf /var/lib/apt/lists/*

# Setting up Japanese IME
ENV XMODIFIERS @im=ibus

CMD /bin/bash -c "(/usr/bin/ibus-daemon -xd; anki -b /data;)"