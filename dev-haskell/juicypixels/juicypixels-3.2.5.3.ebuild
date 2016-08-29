# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# ebuild generated by hackport 0.4.5.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

MY_PN="JuicyPixels"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Picture loading/serialization (in png, jpeg, bitmap, gif, tga, tiff and others)"
HOMEPAGE="https://github.com/Twinside/Juicy.Pixels"
SRC_URI="mirror://hackage/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 x86"
IUSE="mmap"

RDEPEND=">=dev-haskell/binary-0.5:=[profile?] <dev-haskell/binary-0.8:=[profile?]
	>=dev-haskell/mtl-1.1:=[profile?] <dev-haskell/mtl-2.3:=[profile?]
	>=dev-haskell/primitive-0.4:=[profile?] <dev-haskell/primitive-0.7:=[profile?]
	>=dev-haskell/transformers-0.2:=[profile?]
	>=dev-haskell/vector-0.9:=[profile?] <dev-haskell/vector-0.12:=[profile?]
	>=dev-haskell/zlib-0.5.3.1:=[profile?] <dev-haskell/zlib-0.7:=[profile?]
	>=dev-lang/ghc-7.4.1:=
	mmap? ( dev-haskell/mmap:=[profile?] )
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.10
"

S="${WORKDIR}/${MY_P}"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag mmap mmap)
}
