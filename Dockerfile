FROM debian:jessie

USER root

RUN apt-get update\
 && apt-get install -y --no-install-recommends apt-transport-https ca-certificates curl bsdtar build-essential python git\
 && rm -rf /var/lib/apt/lists/*
RUN curl -sSL https://install.meteor.com -o /tmp/install_meteor.sh\
 && sed -i.bak "s/tar -xzf.*/bsdtar -xf \"\$TARBALL_FILE\" -C \"\$INSTALL_TMPDIR\"/g" /tmp/install_meteor.sh\
 && sh /tmp/install_meteor.sh\
 && rm -rf /tmp/*


ENV METEOR_ALLOW_SUPERUSER true