FROM debian:jessie

ENV GOSU_VERSION 1.10

COPY install.sh /tmp/
RUN chmod -R 750 /tmp/ && sh /tmp/install.sh


ENV METEOR_ALLOW_SUPERUSER true