# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# ebuild generated by hackport 0.5.3.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Git operations in haskell"
HOMEPAGE="https://github.com/vincenthz/hit"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="debug executable"

RDEPEND=">=dev-haskell/attoparsec-0.10.1:=[profile?]
	dev-haskell/byteable:=[profile?]
	dev-haskell/cryptohash:=[profile?]
	>=dev-haskell/hourglass-0.2:=[profile?]
	dev-haskell/mtl:=[profile?]
	>=dev-haskell/parsec-3:=[profile?]
	dev-haskell/patience:=[profile?]
	dev-haskell/random:=[profile?]
	dev-haskell/system-fileio:=[profile?]
	dev-haskell/system-filepath:=[profile?]
	dev-haskell/unix-compat:=[profile?]
	dev-haskell/utf8-string:=[profile?]
	dev-haskell/vector:=[profile?]
	dev-haskell/zlib:=[profile?]
	>=dev-haskell/zlib-bindings-0.1:=[profile?] <dev-haskell/zlib-bindings-0.2:=[profile?]
	>=dev-lang/ghc-7.4.1:=
	executable? ( >=dev-haskell/hashable-1.2:=[profile?]
			dev-haskell/hashtables:=[profile?] )
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
	test? ( >=dev-haskell/bytedump-1.0
		dev-haskell/tasty
		dev-haskell/tasty-quickcheck )
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag debug debug) \
		$(cabal_flag executable executable)
}
