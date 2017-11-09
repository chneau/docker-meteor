FROM debian:jessie


RUN apt-get update \
 && apt-get install -y --no-install-recommends curl bsdtar build-essential python git
RUN curl -v https://install.meteor.com -o /tmp/install_meteor.sh \
 && sed -i.bak "s/tar -xzf.*/bsdtar -xf \"\$TARBALL_FILE\" -C \"\$INSTALL_TMPDIR\"/g" /tmp/install_meteor.sh \
 && sh /tmp/install_meteor.sh \
 && rm -rf /tmp/*


ENV METEOR_ALLOW_SUPERUSER true