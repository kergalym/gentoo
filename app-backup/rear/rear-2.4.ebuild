# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Relax-and-Recover is a setup-and-forget bare metal disaster recovery solution"
HOMEPAGE="http://relax-and-recover.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="libressl udev samba"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	net-dialup/mingetty
	net-fs/nfs-utils
	sys-apps/gawk
	sys-apps/iproute2
	sys-apps/lsb-release
	sys-apps/util-linux
	sys-apps/sed
	sys-block/parted
	sys-boot/syslinux
	virtual/cdrtools
	udev? ( virtual/udev )
	samba? ( net-fs/cifs-utils )
"

src_compile () { :; }
