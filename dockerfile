FROM debian:jessie

COPY install.sh /tmp/
RUN chmod -R 750 /tmp/ && sh /tmp/install.sh