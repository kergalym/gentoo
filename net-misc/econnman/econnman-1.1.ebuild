# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{4..7} )

inherit python-any-r1

DESCRIPTION="ConnMan User Interface written with EFL & python"
HOMEPAGE="https://phab.enlightenment.org/w/projects/econnman/ https://www.enlightenment.org/"
SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${P}.tar.xz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="${PYTHON_DEPS}"
RDEPEND="
	${DEPEND}
	dev-libs/efl[X,connman]
	$(python_gen_any_dep '
		dev-python/python-efl[${PYTHON_USEDEP}]
	')
"
