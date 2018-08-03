# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( pypy{,3} python2_7 python3_{4,5,6,7} )

inherit distutils-r1

DESCRIPTION="A Python wrapper for GnuPG"
HOMEPAGE="https://bitbucket.org/vinay.sajip/python-gnupg
	https://pypi.org/project/python-gnupg/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
LICENSE="BSD"
SLOT="0"

RDEPEND="app-crypt/gnupg"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-skip_network_needing_test.patch
	"${FILESDIR}"/${P}-use_seperate_keys_directory.patch
)

python_test() {
	"${PYTHON}" test_gnupg.py || die "Tests failed with ${EPYTHON}"
}
