# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} pypy )

inherit distutils-r1

DESCRIPTION="RSS feed generator written in Python"
HOMEPAGE="http://www.dalkescientific.com/Python/PyRSS2Gen.html https://pypi.python.org/pypi/PyRSS2Gen"
SRC_URI="http://www.dalkescientific.com/Python/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
