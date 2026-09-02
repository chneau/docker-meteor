#!/bin/sh
set -eu

IMAGE_NAME="${1:-test-meteor}"

echo "Testing image: $IMAGE_NAME"

echo "1. Checking Meteor version..."
docker run --rm "$IMAGE_NAME" meteor --version

echo "2. Checking Node version bundled with Meteor..."
docker run --rm "$IMAGE_NAME" meteor node --version

echo "3. Checking npm version bundled with Meteor..."
docker run --rm "$IMAGE_NAME" meteor npm --version

echo "✅ All smoke tests passed!"
