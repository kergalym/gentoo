# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# ebuild generated by hackport 0.5.1.9999
#hackport: flags: -dev,-has-icu,-has-llvm

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Unicode normalization"
HOMEPAGE="https://github.com/harendra-kumar/unicode-transforms"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/bitarray-0.0.1:=[profile?] <dev-haskell/bitarray-0.1:=[profile?]
	>=dev-haskell/text-1.1.1:=[profile?] <dev-haskell/text-1.3:=[profile?]
	>=dev-lang/ghc-7.8.2:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.18.1.3
	test? ( >=dev-haskell/getopt-generics-0.11 <dev-haskell/getopt-generics-0.14
		>=dev-haskell/quickcheck-2.1 <dev-haskell/quickcheck-2.10
		>=dev-haskell/split-0.1 <dev-haskell/split-0.3 )
"

src_configure() {
	haskell-cabal_src_configure \
		--flag=-dev \
		--flag=-has-icu \
		--flag=-has-llvm
}
