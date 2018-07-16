# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( pypy{,3} python{2_7,3_{4,5,6}} )

inherit distutils-r1

DESCRIPTION="Configures Flask applications in a canonical way"
HOMEPAGE="https://github.com/mbr/flask-appconfig"
# PyPI tarballs don't include tests
# https://github.com/mbr/flask-appconfig/pull/4
SRC_URI="https://github.com/mbr/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	sed -i "s/, 'sphinx.ext.intersphinx'//" docs/conf.py || die
	# These conflict with recent flask versions, #589548
	sed -i '/entry_points={/,/},$/d' setup.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		sphinx-build docs docs/_build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	py.test || die "Tests failed with ${EPYTHON}"
}
