# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# ebuild generated by hackport 0.5.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Authentication plugin for Yesod"
HOMEPAGE="https://github.com/paul-rouse/yesod-auth-hashdb"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/cryptohash-0.8:=[profile?]
	>=dev-haskell/persistent-2.1:=[profile?] <dev-haskell/persistent-2.6:=[profile?]
	>=dev-haskell/pwstore-fast-2.2:=[profile?]
	>=dev-haskell/text-0.7:=[profile?]
	>=dev-haskell/yesod-auth-1.4:=[profile?] <dev-haskell/yesod-auth-1.5:=[profile?]
	>=dev-haskell/yesod-core-1.4:=[profile?] <dev-haskell/yesod-core-1.5:=[profile?]
	>=dev-haskell/yesod-form-1.4:=[profile?] <dev-haskell/yesod-form-1.5:=[profile?]
	>=dev-haskell/yesod-persistent-1.2:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8.0
	test? ( dev-haskell/classy-prelude
		>=dev-haskell/hspec-2.0.0
		dev-haskell/http-conduit
		dev-haskell/http-types
		dev-haskell/monad-logger
		dev-haskell/network-uri
		dev-haskell/persistent-sqlite
		dev-haskell/resourcet
		dev-haskell/wai-extra
		dev-haskell/yesod
		>=dev-haskell/yesod-test-1.4.3 )
"
