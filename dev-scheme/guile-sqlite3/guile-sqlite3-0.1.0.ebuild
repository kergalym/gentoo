# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Guile bindings of sqlite3"
HOMEPAGE="https://notabug.org/civodul/guile-sqlite3.git"
SRC_URI="https://notabug.org/civodul/guile-sqlite3/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+ GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-scheme/guile-2.0.11:=
	dev-db/sqlite:3=
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	default

	# upstream tag on top of source tree. has no autogenerated files
	eautoreconf
}
