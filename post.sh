#! /bin/bash
set -e

VERSION="$(cat version)"

echo "-----> Testing..."
docker import archlinux.tar hoverbear/archlinux:$VERSION
docker tag -f hoverbear/archlinux:$VERSION hoverbear/archlinux:latest
docker run --rm=true hoverbear/archlinux /bin/bash -c "echo \"Success, hoverbear/archlinux prepared.\""
