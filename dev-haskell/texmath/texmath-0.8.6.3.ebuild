# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# ebuild generated by hackport 0.5.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Conversion between formats used to represent mathematics"
HOMEPAGE="https://github.com/jgm/texmath"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="executable +network-uri"

RDEPEND="dev-haskell/mtl:=[profile?]
	>=dev-haskell/pandoc-types-1.12.3.3:=[profile?] <dev-haskell/pandoc-types-1.17:=[profile?]
	>=dev-haskell/parsec-3:=[profile?]
	dev-haskell/syb:=[profile?]
	dev-haskell/xml:=[profile?]
	>=dev-lang/ghc-7.4.1:=
	executable? ( dev-haskell/aeson:=[profile?]
			dev-haskell/split:=[profile?]
			dev-haskell/text:=[profile?]
			network-uri? ( >=dev-haskell/network-uri-2.6:=[profile?] )
			!network-uri? ( <dev-haskell/network-2.6:=[profile?] ) )
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.10
	test? ( dev-haskell/temporary
		dev-haskell/utf8-string
		!executable? ( dev-haskell/split
				dev-haskell/text ) )
"

PATCHES=("${FILESDIR}"/${P}-build-deps.patch)

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag executable executable) \
		$(cabal_flag network-uri network-uri)
}
