FROM debian:stretch-slim

USER 0
RUN apt-get update\
 && apt-get install -y --no-install-recommends curl ca-certificates\
 && rm -rf /var/lib/apt/lists/*
RUN curl -sSL https://install.meteor.com | bash
