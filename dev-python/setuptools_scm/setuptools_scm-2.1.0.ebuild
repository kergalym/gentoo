# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="package to manage versions by scm tags via setuptools"
HOMEPAGE="https://github.com/pypa/setuptools_scm https://pypi.org/project/setuptools_scm/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-vcs/git
		dev-vcs/mercurial )"

python_prepare_all() {
	# network access
	sed -i -e 's:test_pip_download:_&:' testing/test_regressions.py || die
	# all fetch specific setuptools versions
	rm testing/test_setuptools_support.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	py.test -v -v -x || die "Tests fail with ${EPYTHON}"
}
