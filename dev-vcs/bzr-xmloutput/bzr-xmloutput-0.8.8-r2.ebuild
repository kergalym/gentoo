# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Bazaar plugin providing an option to generate XML output for builtin commands"
HOMEPAGE="http://bazaar-vcs.org/XMLOutput"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="dev-vcs/bzr[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}"/${P}_remove-relative-imports.patch )

pkg_setup() {
	python-single-r1_pkg_setup
}
