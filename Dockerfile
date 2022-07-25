ARG NODE_VERSION
FROM node:$NODE_VERSION-bullseye-slim
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates && rm -rf /var/lib/apt/lists/* && useradd --create-home --shell /bin/bash meteor
USER meteor
WORKDIR /home/meteor
ARG RELEASE
RUN curl -s https://install.meteor.com/?release=$RELEASE | bash
ENV PATH="${PATH}:/home/meteor/.meteor"
