FROM ghcr.io/chneau/meteor:2.7.3-bullseye-slim AS builder
WORKDIR /home/meteor/app
COPY --chown=meteor:meteor ./package*.json .
RUN meteor npm ci
COPY --chown=meteor:meteor . .
RUN meteor build --server-only --directory ..

FROM node:14.19.3-bullseye-slim AS final
