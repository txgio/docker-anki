# Credits: 
#
#   - http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/
#   - https://github.com/jfrazelle/dockerfiles/blob/master/spotify/Dockerfile
#
# Note:
#
#   This Dockerfile sets up everything for studying Japanese with Anki. ADAPT
#   comments point to what you'll probably need to adapt to your situation.
#
# Prepare (example):
# 
#   $ mkdir AnkiDocker
#   $ cd AnkiDocker
#   $ # Save this file to Dockerfile and adapt it to your needs.
#   $ mkdir config
#   $ docker build -t debian-anki .
#
# Run (example):
#
#   $ docker run -ti --rm -e DISPLAY=unix$DISPLAY \
#         -v $HOME/Anki:/home/anki-user/Anki \
#         -v $(pwd)/config:/home/anki-user/.config \ # ADAPT – This is for 
#         -v $HOME/.anthy:/home/anki-user/.anthy \   # Japanese IME.
#         -v $HOME/.Xauthority:/home/anki-user/.Xauthority \
#         --net=host debian-anki

FROM debian:stable

RUN apt-get update

# Credits: https://wiki.debian.org/Locale
RUN apt-get install -y locales
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen

RUN apt-get install -y fonts-vlgothic  # ADAPT – Japanese fonts
RUN apt-get install -y ibus-anthy dbus-x11 x11-xkb-utils # ADAPT – Japanese IME
RUN apt-get install -y anki

# Might only work if your host user and group IDs are both 1000.
ENV HOME /home/anki-user
RUN useradd --create-home --home-dir $HOME anki-user \
        && chown -R anki-user:anki-user $HOME

WORKDIR $HOME
USER anki-user
ENV LANG en_US.UTF-8
ENV XMODIFIERS @im=ibus # ADAPT – Japanese IME again.
CMD /bin/bash -c "(/usr/bin/ibus-daemon -xd; /usr/bin/anki;)"
    # ADAPT – If you don't need an IME, you can just use 'CMD /usr/bin/anki'.

# The MIT License (MIT)
# 
# Copyright (c) 2016 Richard Möhn
# 
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.