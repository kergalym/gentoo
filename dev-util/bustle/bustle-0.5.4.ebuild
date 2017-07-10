# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# ebuild generated by hackport 0.4.5.9999

CABAL_FEATURES="bin test-suite"
inherit eutils haskell-cabal

DESCRIPTION="Draw sequence diagrams of D-Bus traffic"
HOMEPAGE="http://hackage.haskell.org/package/bustle"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-2 GPL-2 GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="interactivetests +threaded"

RESTRICT=test # fails one propery test

RDEPEND="dev-haskell/cairo:=
	>=dev-haskell/dbus-0.10:=
	dev-haskell/gio:=
	dev-haskell/glib:=
	>=dev-haskell/gtk3-0.13.7:0=
	>=dev-haskell/hgettext-0.1.5:=
	dev-haskell/mtl:=
	dev-haskell/pango:=
	dev-haskell/parsec:=
	dev-haskell/pcap:=
	dev-haskell/setlocale:=
	dev-haskell/text:=
	>=dev-lang/ghc-7.4.1:=
	dev-libs/glib:2
	dev-perl/Locale-gettext
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
	virtual/pkgconfig
	test? ( dev-haskell/hunit
		dev-haskell/quickcheck
		dev-haskell/test-framework
		dev-haskell/test-framework-hunit )
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag interactivetests interactivetests) \
		$(cabal_flag threaded threaded)
}

src_compile() {
	# compile haskell part
	cabal_src_compile || die "could not build haskell parts"

	# compile C part
	emake \
		"CC=$(tc-getCC)" \
		"CFLAGS=${CFLAGS}" \
		"CPPFLAGS=${CPPFLAGS}" \
		"LDFLAGS=${LDFLAGS}"
}

src_install() {
	# install haskell part
	cabal_src_install || die "could not install haskell parts"

	dobin "${S}"/dist/build/bustle-pcap
	doman bustle-pcap.1
	dodoc README.md HACKING.md NEWS.md
}
