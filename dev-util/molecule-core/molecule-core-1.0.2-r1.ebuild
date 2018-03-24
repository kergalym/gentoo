# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5,3_6} )

inherit python-r1

DESCRIPTION="Sabayon distro-agnostic images build tool"
HOMEPAGE="http://www.sabayon.org"
SRC_URI="mirror://sabayon/${CATEGORY}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="dev-util/intltool
	sys-devel/gettext"
RDEPEND="!<dev-util/molecule-1
	sys-process/lsof
	${PYTHON_DEPS}"

src_install() {
	emake DESTDIR="${D}" LIBDIR="/usr/lib" \
		PREFIX="/usr" SYSCONFDIR="/etc" install
}
