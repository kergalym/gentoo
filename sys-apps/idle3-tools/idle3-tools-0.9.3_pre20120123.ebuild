# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="Set, get or disable the value of the idle3 timer found on WD HDDs"
HOMEPAGE="http://idle3-tools.sourceforge.net/"
SRC_URI="https://www.bl4ckb0x.de/files/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

PATCHES=( "${FILESDIR}"/makefile.patch )

src_compile() {
	CC="$(tc-getCC)" emake
}
