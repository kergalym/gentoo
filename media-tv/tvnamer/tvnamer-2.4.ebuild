# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_3 python3_4 python3_5 )
inherit distutils-r1

DESCRIPTION="Automatic TV episode file renamer, data from thetvdb.com"
HOMEPAGE="https://github.com/dbr/tvnamer"
SRC_URI="mirror://pypi/t/${PN}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/tvdb_api-1.10_pre[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
