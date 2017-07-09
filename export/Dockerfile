FROM txgio/anki:dev

RUN apt-get update && \
    apt-get install -y rsync && \
    rm -rf /var/lib/apt/lists/*

VOLUME /export

ENTRYPOINT ["rsync", "-avzh", "/data/.", "/export/"]