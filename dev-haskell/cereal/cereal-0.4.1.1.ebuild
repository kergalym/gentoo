# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# ebuild generated by hackport 0.4.4.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="A binary serialization library"
HOMEPAGE="http://hackage.haskell.org/package/cereal"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="test"

RDEPEND=">=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.6
	test? ( dev-haskell/quickcheck:2=[profile?] )
"

src_test() {
	# The test suite isn't integrated with cabal. There's a Makefile
	# under the "tests" directory that will build and run some
	# tests.
	#
	# In v0.4.1.1, the test suite won't fail if a property does. This
	# should be fixed in,
	#
	#   https://github.com/GaloisInc/cereal/pull/29
	#
	emake -C tests
}
