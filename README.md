# docker-meteor

This is a very simple `Docker` image to use for `Meteor`.  
Based on `debian:bullseye-slim`.

## Quickstart

Get the correct `Node version` by running:

```bash
docker run --rm ghcr.io/chneau/meteor:2.12-bullseye-slim meteor node --version
# to use with node v14.21.3
```

Add a `Dockerfile` to your project:

```Dockerfile
FROM ghcr.io/chneau/meteor:2.12-bullseye-slim AS builder
WORKDIR /app
COPY --chown=meteor:meteor ./package*.json .
RUN meteor npm ci
COPY --chown=meteor:meteor . .
RUN meteor build --server-only --directory bundle
RUN cd bundle/bundle/programs/server && meteor npm install

FROM node:14.21.3-bullseye-slim AS final
RUN useradd --no-create-home --shell /bin/bash meteor
USER meteor
WORKDIR /app
COPY --from=builder /app/bundle/bundle .
CMD ["node", "main.js"]
```

Add a `.dockerignore`:

```
node_modules
.meteor/local
```

For more information, see the [`example`](https://github.com/chneau/docker-meteor/tree/master/example) folder.
