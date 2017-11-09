FROM debian:jessie


RUN apt-get update
RUN apt-get install -y apt-transport-https ca-certificates
RUN apt-get install -y --no-install-recommends curl bzip2 bsdtar build-essential python git wget
RUN dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"
RUN wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.10/gosu-$dpkgArch"
RUN wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/1.10/gosu-$dpkgArch.asc"
RUN gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu
RUN rm -r "$(mktemp -d)" /usr/local/bin/gosu.asc
RUN chmod +x /usr/local/bin/gosu
RUN gosu nobody true
RUN apt-get purge -y --auto-remove wget
RUN curl -v https://install.meteor.com -o /tmp/install_meteor.sh
RUN sed -i.bak "s/tar -xzf.*/bsdtar -xf \"\$TARBALL_FILE\" -C \"\$INSTALL_TMPDIR\"/g" /tmp/install_meteor.sh
RUN sh /tmp/install_meteor.sh
RUN rm -rf /tmp/*


ENV METEOR_ALLOW_SUPERUSER true