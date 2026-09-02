# docker-meteor

[![Publish all releases](https://github.com/chneau/docker-meteor/actions/workflows/publish-all.yml/badge.svg)](https://github.com/chneau/docker-meteor/actions/workflows/publish-all.yml)
[![Docker Image](https://img.shields.io/badge/docker_image-ghcr.io%2Fchneau%2Fmeteor-blue?logo=docker)](https://ghcr.io/chneau/meteor)

Lightweight Docker image designed to build [Meteor](https://www.meteor.com/) applications in CI/CD pipelines and multi-stage Docker builds.

Based on `debian:bookworm-slim` with pre-installed `curl`, `ca-certificates`, and the official Meteor CLI under a non-root `meteor` user.

---

## ✨ Features

- 🚀 **Multi-Architecture**: Official support for both `linux/amd64` and `linux/arm64` on Meteor 3.x (Apple Silicon, AWS Graviton).
- 🛡️ **Non-Root**: Runs under an unprivileged `meteor` user (`/home/meteor`).
- 🪶 **Debian Bookworm**: Built on `debian:bookworm-slim` for standard glibc compatibility and minimal size.
- 📦 **Multi-Version Matrix**: Daily automated builds for all active Meteor 3.x and LTS releases.
- 🧪 **Smoke-Tested**: Verified in CI with `meteor --version`, `meteor node --version`, and `meteor npm --version`.

---

## 🚀 Quickstart

### 1. Check Bundled Node & Meteor Versions

```bash
# Check Meteor version
docker run --rm ghcr.io/chneau/meteor:latest --version

# Check matching Node version bundled with Meteor
docker run --rm ghcr.io/chneau/meteor:latest node --version

# Check npm version
docker run --rm ghcr.io/chneau/meteor:latest npm --version
```

---

## 🛠️ Multi-Stage Dockerfile Example

Use `docker-meteor` as the build stage and a minimal `node` image for your production runtime:

```dockerfile
# Stage 1: Build Meteor bundle
FROM ghcr.io/chneau/meteor:3.5 AS builder
WORKDIR /app

# Cache package dependencies
COPY --chown=meteor:meteor ./package*.json ./
RUN meteor npm install

# Build the bundle
COPY --chown=meteor:meteor . ./
RUN meteor build --server-only --directory bundle

# Install server production dependencies
RUN cd bundle/bundle/programs/server && meteor npm install --production

# Stage 2: Production runtime
FROM node:20-bookworm-slim AS final

RUN useradd --no-create-home --shell /bin/bash meteor
USER meteor
WORKDIR /app

COPY --from=builder /app/bundle/bundle ./

ENV PORT=3000
EXPOSE 3000

CMD ["node", "main.js"]
```

### Recommended `.dockerignore`

```
.git
.meteor/local
node_modules
```

---

## 🧪 Testing Locally

Run the smoke test suite against any local image or tag:

```bash
# Test local build
docker build --build-arg RELEASE=3.5 -t test-meteor .
./test.sh test-meteor
```

---

## 📄 License

MIT © [chneau](https://github.com/chneau)

