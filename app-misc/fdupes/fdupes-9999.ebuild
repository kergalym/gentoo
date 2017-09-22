# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic git-r3 toolchain-funcs

MY_P="${PN}-${PV/_pre/-PR}"

DESCRIPTION="Identify/delete duplicate files residing within specified directories"
HOMEPAGE="https://github.com/adrianlopezroche/fdupes"
SRC_URI=""
EGIT_REPO_URI="https://github.com/adrianlopezroche/fdupes.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

S="${WORKDIR}/${MY_P}"
PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_configure() {
	append-lfs-flags
	tc-export CC
}

src_install() {
	dobin fdupes
	dodoc CHANGES CONTRIBUTORS README
	doman fdupes.1
}
