# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Open-source library for reading, mastering and writing optical discs"
HOMEPAGE="https://dev.lovelyhq.com/libburnia/web/wikis/home"
SRC_URI="http://files.libburnia-project.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 ~sparc x86"
IUSE="cdio debug static-libs track-src-odirect"

RDEPEND="cdio? ( >=dev-libs/libcdio-0.83 )"
DEPEND="$RDEPEND
	virtual/pkgconfig"

src_configure() {
	econf \
	$(use_enable static-libs static) \
	$(use_enable track-src-odirect) \
	--enable-pkg-check-modules \
	$(use_enable cdio libcdio) \
	--disable-ldconfig-at-install \
	$(use_enable debug)
}

src_install() {
	default

	dodoc CONTRIBUTORS doc/{comments,*.txt}

	docinto cdrskin
	dodoc cdrskin/{*.txt,README}
	docinto cdrskin/html
	dodoc cdrskin/cdrskin_eng.html

	find "${D}" -name '*.la' -delete || die
}
