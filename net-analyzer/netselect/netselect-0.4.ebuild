# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Ultrafast implementation of ping"
HOMEPAGE="http://apenwarr.ca/netselect/"
SRC_URI="https://github.com/apenwarr/${PN}/archive/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4-bsd.patch
	"${FILESDIR}"/${PN}-0.4-flags.patch
)
S=${WORKDIR}/${PN}-${P}

src_prepare() {
	default

	rm -r netinet || die

	tc-export CC
}

src_install () {
	dobin netselect

	if ! use prefix ; then
		fowners root:wheel /usr/bin/netselect
		fperms 4711 /usr/bin/netselect
	fi

	dodoc HISTORY README

	doman netselect.1
}
