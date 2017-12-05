# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs vcs-snapshot versionator

REF="079b006cdab6f0ae594f80fff18ad61b71b0754d"

DESCRIPTION="Selection-oriented code editor inspired by vim"
HOMEPAGE="https://github.com/mawww/kakoune"
SRC_URI="https://github.com/mawww/${PN}/tarball/${REF} -> ${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug static"

RDEPEND="
	sys-libs/ncurses:0=[unicode]
"
DEPEND="
	app-text/asciidoc
	virtual/pkgconfig
	${RDEPEND}
"

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if tc-is-gcc && ! version_is_at_least 5.0 $(gcc-version); then
			die "Clang or GCC >=5.0 is required to build this version"
		fi
	fi
}

src_prepare() {
	default

	sed -i -e '/CXXFLAGS += -O3/d' src/Makefile || \
		die "Failed to patch makefile"
}

src_configure() {
	tc-export CXX
	export debug=$(usex debug)
	export static=$(usex static)
}

src_install() {
	emake -C src DESTDIR="${D}" PREFIX="${EPREFIX}/usr" docdir="${ED%/}/usr/share/doc/${PF}" install
}
