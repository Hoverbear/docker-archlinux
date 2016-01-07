#! /bin/bash
set -e

echo "-----> Installing dependencies..."
# We need a relatively up to date version of util-linux, so pin it.
echo "deb http://ca.archive.ubuntu.com/ubuntu/ vivid main" | tee -a /etc/apt/sources.list
apt-get update
echo >> /etc/apt/preferences <<EOF2
    Package: *
    Pin: release n=trusty
    Pin-Priority: 501

    Package: util-linux
    Pin: release n=utopic
    Pin-Priority: 502
EOF2
# Font-config breaks on travis for some reason, so remove it.
apt-get remove --yes --purge fontconfig-config
apt-get install --yes curl gnupg util-linux rng-tools

# RNG Hack: https://github.com/travis-ci/travis-ci/issues/1913
echo "HRNGDEVICE=\"/dev/urandom\"" | sudo tee /etc/default/rng-tools
/etc/init.d/rng-tools restart
