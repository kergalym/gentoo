# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# ebuild generated by hackport 0.5.1

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Pure-Haskell utilities for dealing with XML with the conduit package"
HOMEPAGE="https://github.com/snoyberg/xml"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/attoparsec-0.10:=[profile?]
	>=dev-haskell/blaze-builder-0.2:=[profile?] <dev-haskell/blaze-builder-0.5:=[profile?]
	>=dev-haskell/blaze-html-0.5:=[profile?]
	>=dev-haskell/blaze-markup-0.5:=[profile?]
	>=dev-haskell/conduit-1.0:=[profile?] <dev-haskell/conduit-1.3:=[profile?]
	>=dev-haskell/conduit-extra-1.1:=[profile?]
	dev-haskell/data-default:=[profile?]
	>=dev-haskell/monad-control-0.3:=[profile?] <dev-haskell/monad-control-1.1:=[profile?]
	>=dev-haskell/resourcet-0.3:=[profile?] <dev-haskell/resourcet-1.2:=[profile?]
	>=dev-haskell/text-0.7:=[profile?]
	>=dev-haskell/xml-types-0.3.4:=[profile?] <dev-haskell/xml-types-0.4:=[profile?]
	>=dev-lang/ghc-7.8.2:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.18.1.3
	test? ( >=dev-haskell/hspec-1.3
		dev-haskell/hunit )
"
