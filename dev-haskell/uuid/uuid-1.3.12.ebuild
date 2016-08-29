# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# ebuild generated by hackport 0.4.7.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="For creating, comparing, parsing and printing Universally Unique Identifiers"
HOMEPAGE="https://github.com/aslatter/uuid"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/binary-0.4:=[profile?] <dev-haskell/binary-0.9:=[profile?]
	dev-haskell/cryptonite:=[profile?]
	dev-haskell/memory:=[profile?]
	>=dev-haskell/network-info-0.2:=[profile?] <dev-haskell/network-info-0.3:=[profile?]
	>=dev-haskell/random-1.0.1:=[profile?] <dev-haskell/random-1.2:=[profile?]
	>=dev-haskell/text-1:=[profile?] <dev-haskell/text-1.3:=[profile?]
	>=dev-haskell/uuid-types-1.0.2:=[profile?] <dev-haskell/uuid-types-2:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
	test? ( >=dev-haskell/hunit-1.2 <dev-haskell/hunit-1.4
		>=dev-haskell/quickcheck-2.4 <dev-haskell/quickcheck-2.9
		>=dev-haskell/tasty-0.10 <dev-haskell/tasty-0.12
		>=dev-haskell/tasty-hunit-0.9 <dev-haskell/tasty-hunit-0.10
		>=dev-haskell/tasty-quickcheck-0.8 <dev-haskell/tasty-quickcheck-0.9 )
"
