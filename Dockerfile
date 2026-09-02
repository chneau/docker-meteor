FROM debian:bookworm-slim

ARG RELEASE

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    useradd --create-home --shell /bin/bash meteor

USER meteor
WORKDIR /home/meteor

ENV PATH="/home/meteor/.meteor:${PATH}"

RUN curl -fsSL "https://install.meteor.com/?release=${RELEASE}" | bash

CMD ["meteor", "--version"]

