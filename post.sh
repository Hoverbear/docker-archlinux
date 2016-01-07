#! /bin/bash
set -e

echo "-----> Testing..."
docker import archlinux.tar hoverbear/archlinux
docker run --rm=true hoverbear/archlinux /bin/bash -c "echo \"Success, hoverbear/archlinux prepared.\""
