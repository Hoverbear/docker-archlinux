#! /bin/bash
set -e

# Make some space
mkdir -p archbuild

# Get the Image
echo "-----> Fetching Arch Bootstrap..."
VERSION=$(curl https://mirrors.kernel.org/archlinux/iso/latest/ | grep -Poh '(?<=archlinux-bootstrap-)\d*\.\d*\.\d*(?=\-x86_64)' | head -n 1)
curl https://mirrors.kernel.org/archlinux/iso/latest/archlinux-bootstrap-$VERSION-x86_64.tar.gz -o archbuild/archlinux-bootstrap-$VERSION-x86_64.tar.gz
curl https://mirrors.kernel.org/archlinux/iso/latest/archlinux-bootstrap-$VERSION-x86_64.tar.gz.sig -o archbuild/archlinux-bootstrap-$VERSION-x86_64.tar.gz.sig

# Travis doesn't give their gpg configuration proper permissions. Fix it for them.
rm -rf ~/.gnupg

# Pull Pierre Schmitz PGP Key.
# http://pgp.mit.edu:11371/pks/lookup?op=vindex&fingerprint=on&exact=on&search=0x4AA4767BBC9C4B1D18AE28B77F2D434B9741E8AC
gpg --keyserver pgp.mit.edu --recv-keys 9741E8AC

# Verify its integrity.
gpg --verify archbuild/archlinux-bootstrap-$VERSION-x86_64.tar.gz.sig
VALID=$?
if [[ $VALID == 1 ]]; then
	echo "Verification Failed";
	exit 1;
fi

echo "-----> Extracting..."
# Extract
tar -xf archbuild/archlinux-bootstrap-$VERSION-x86_64.tar.gz -C archbuild/ > /dev/null # Quiet output

# Do necessary install steps.
echo "-----> Installing in chroot..."
./archbuild/root.x86_64/bin/arch-chroot archbuild/root.x86_64 << EOF
	# Setup a mirror.
	echo 'Server = https://mirrors.kernel.org/archlinux/\$repo/os/\$arch' > /etc/pacman.d/mirrorlist
	# Setup Keys
	pacman-key --init
	pacman-key --populate archlinux
	# Base without the following packages, to save space.
	# linux jfsutils lvm2 cryptsetup groff man-db man-pages mdadm pciutils pcmciautils reiserfsprogs s-nail xfsprogs vi
	pacman -Syu --noconfirm bash bzip2 coreutils device-mapper dhcpcd gcc-libs gettext glibc grep gzip inetutils iproute2 iputils less libutil-linux licenses logrotate psmisc sed shadow sysfsutils systemd-sysvcompat tar texinfo usbutils util-linux which
	# Pacman doesn't let us force ignore files, so clean up.
	pacman -Scc --noconfirm
	# Install stuff
	echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
	locale-gen
	exit
EOF

# udev doesnt work in containers, rebuild /dev
# Taken from https://raw.githubusercontent.com/dotcloud/docker/master/contrib/mkimage-arch.sh
echo "-----> Running mknod commands..."
DEV=root.x86_64/dev
bash << EOF
	rm -rf $DEV
	mkdir -p $DEV
	mknod -m 0666 $DEV/null c 1 3
	mknod -m 0666 $DEV/zero c 1 5
	mknod -m 0666 $DEV/random c 1 9
	mknod -m 0666 $DEV/urandom c 1 9
	mkdir -m 0755 $DEV/pts
	mkdir -m 1777 $DEV/shm
	mknod -m 0666 $DEV/tty c 5 0
	mknod -m 0600 $DEV/console c 5 1
	mknod -m 0666 $DEV/tty0 c 4 0
	mknod -m 0666 $DEV/full c 1 7
	mknod -m 0600 $DEV/initctl p
	mknod -m 0666 $DEV/ptmx c 5 2
	ln -sf /proc/self/fd $DEV/fd
EOF

# Build the container., Import it.
echo "-----> Tarballing..."
tar --numeric-owner -C archbuild/root.x86_64 -c . -f archlinux.tar
echo "$VERSION" > version
