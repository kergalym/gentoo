# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="A bi-directional ping utility"
HOMEPAGE="https://www.finnie.org/software/2ping/"
SRC_URI="https://www.finnie.org/software/2ping/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
IUSE="server"

src_install() {
	distutils-r1_src_install
	doman doc/2ping.1
	dodoc doc/{2ping-protocol-examples.py,2ping-protocol.md}
	use server && {
		doinitd "${FILESDIR}"/2pingd
		newconfd "${FILESDIR}"/2pingd.conf 2pingd
	}
}
