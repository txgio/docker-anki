FROM txgio/anki:2.0.45

RUN apt-get update && \
    apt-get install -y rsync && \
    rm -rf /var/lib/apt/lists/*

VOLUME /import

ENTRYPOINT ["rsync", "-avzh", "/import/.", "/data/"]