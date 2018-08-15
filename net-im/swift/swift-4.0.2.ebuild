# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils scons-utils toolchain-funcs

DESCRIPTION="An elegant, secure, adaptable and intuitive XMPP Client"
HOMEPAGE="https://www.swift.im/"
SRC_URI="https://swift.im/downloads/releases/${P}/${P}.tar.gz"

LICENSE="BSD BSD-1 CC-BY-3.0 GPL-3 OFL-1.1"
SLOT="0/4"
KEYWORDS="~amd64 ~x86"
IUSE="client expat examples experimental ft gconf hunspell lua icu idn test tools unbound zeroconf"
REQUIRED_USE="ft? ( experimental )
	gconf? ( client )
	hunspell? ( client )"

RDEPEND="dev-lang/lua:=
	dev-libs/boost:=
	dev-libs/openssl:0=
	sys-libs/zlib:=
	expat? ( dev-libs/expat )
	!expat? ( dev-libs/libxml2:2 )
	experimental? ( dev-db/sqlite:3 )
	client? ( dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		dev-qt/qtwebkit:5
		dev-qt/qtx11extras:5 )
	ft? ( net-libs/libnatpmp
		net-libs/miniupnpc:= )
	hunspell? ( app-text/hunspell:= )
	icu? ( dev-libs/icu:= )
	gconf? ( gnome-base/gconf:2 )
	idn? ( net-dns/libidn:= )
	unbound? ( net-dns/unbound
		net-libs/ldns )
	zeroconf? ( net-dns/avahi )"

DEPEND="${RDEPEND}
	>=dev-util/scons-3.0.1-r3
	client? ( dev-qt/linguist-tools:5 )"

DOCS=(
	"DEVELOPMENT.md"
	"README.md"
	"Swiften/ChangeLog.md"
)

PATCHES=(
	"${FILESDIR}"/${P}-make-generated-files-handle-unicode-characters.patch
	"${FILESDIR}"/${P}-qt-5.11-compat.patch
)

src_prepare() {
	default

	# Hack for finding qt system libs
	mkdir "${T}"/qt || die
	ln -s "${EPREFIX%/}"/usr/$(get_libdir)/qt5/bin "${T}"/qt/bin || die
	ln -s "${EPREFIX%/}"/usr/$(get_libdir)/qt5 "${T}"/qt/lib || die
	ln -s "${EPREFIX%/}"/usr/include/qt5 "${T}"/qt/include || die

	# Remove parts of Swift, which a user don't want to compile
	if use client; then rm -fr Swift Slimber || die; fi
	if use lua; then rm -fr Sluift || die; fi
	if use tools; then rm -fr SwiftTools || die; fi
	if use zeroconf; then rm -fr Limber || die; fi

	# Remove '3rdParty', as the system libs should be used
	rm -fr 3rdParty || die
}

src_configure() {
	MYSCONS=(
		ar="$(tc-getAR)"
		allow_warnings="yes"
		assertions="no"
		build_examples="yes"
		boost_bundled_enable="false"
		boost_force_bundled="false"
		cc="$(tc-getCC)"
		ccache="no"
		ccflags="${CFLAGS}"
		coverage="no"
		cxx="$(tc-getCXX)"
		cxxflags="${CXXFLAGS}"
		debug="no"
		distcc="no"
		experimental="$(usex experimental)"
		experimental_ft="$(usex ft)"
		hunspell_enable="$(usex hunspell)"
		icu="$(usex icu)"
		install_git_hooks="no"
		libidn_bundled_enable="false"
		libminiupnpc_force_bundled="false"
		libnatpmp_force_bundled="false"
		link="$(tc-getCXX)"
		linkflags="${LDFLAGS}"
		max_jobs="no"
		optimize="no"
		qt="${T}/qt"
		qt5="$(usex client)"
		swiften_dll="true"
		swift_mobile="no"
		target="native"
		test="none"
		try_avahi="$(usex zeroconf)"
		try_expat="$(usex expat)"
		try_gconf="$(usex gconf)"
		try_libidn="$(usex idn)"
		try_libxml="$(usex !expat)"
		tls_backend="openssl"
		unbound="$(usex unbound)"
		V="1"
		valgrind="no"
		zlib_bundled_enable="false"
	)
}

src_compile() {
	local mysconstargets=(
		Swiften
		$(usex client Slimber '')
		$(usex client Swift '')
		$(usex lua Sluift '')
		$(usex tools SwifTools '')
		$(usex zeroconf Limber '')
	)

	escons "${MYSCONS[@]}" ${mysconstargets[@]}
}

src_test() {
	escons test=unit QA
}

src_install() {
	local mysconsinstall=(
		"${MYSCONS[@]}"
		SLUIFT_DIR="${ED%/}/usr"
		SWIFTEN_INSTALLDIR="${ED%/}/usr"
		SWIFTEN_LIBDIR="${ED%/}/usr/$(get_libdir)"
		"${ED%/}"
	)
	escons "${mysconsinstall[@]}"

	use client && newbin Slimber/CLI/slimber slimber-cli
	use client && newbin Slimber/Qt/slimber slimber-qt
	use lua && dobin Sluift/exe/sluift
	use zeroconf && dobin Limber/limber

	local HTML_DOCS=( "Documentation/SwiftenDevelopersGuide/Swiften Developers Guide.xml" )
	einstalldocs
}

pkg_postinst() {
	use client && gnome2_icon_cache_update
}

pkg_postrm() {
	use client && gnome2_icon_cache_update
}
