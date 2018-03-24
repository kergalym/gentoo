# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit autotools gnome2 python-single-r1

DESCRIPTION="A personal finance manager"
HOMEPAGE="http://www.gnucash.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="chipcard debug +doc gnome-keyring hbci mysql ofx postgres python quotes sqlite"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# README.dependencies mentions qof, but ${PN} has their own fork in the
# source code that appears to have deviated from that project.
#
# libdbi version requirement for sqlite taken from bug #455134
RDEPEND="
	>=dev-libs/glib-2.32.0:2
	>=dev-libs/libxml2-2.5.10:2
	>=dev-libs/popt-1.5
	>=dev-scheme/guile-1.8.5:12=[deprecated,regex]
	<dev-scheme/guile-2.2
	>=net-libs/webkit-gtk-1.2:2
	>=sys-libs/zlib-1.1.4
	>=x11-libs/goffice-0.7.0:0.8[gnome]
	>=x11-libs/gtk+-2.24:2
	dev-libs/libxslt
	dev-scheme/guile-www
	gnome-base/dconf
	gnome-base/libgnomecanvas
	x11-libs/pango
	gnome-keyring? ( >=app-crypt/libsecret-0.18 )
	hbci? (
		>=net-libs/aqbanking-5[gtk,ofx?]
		sys-libs/gwenhywfar[gtk]
		chipcard? ( sys-libs/libchipcard )
	)
	mysql? (
		dev-db/libdbi
		dev-db/libdbi-drivers[mysql]
	)
	ofx? ( >=dev-libs/libofx-0.9.1 )
	postgres? (
		dev-db/libdbi
		dev-db/libdbi-drivers[postgres]
	)
	python? ( ${PYTHON_DEPS} )
	quotes? (
		>=dev-perl/Finance-Quote-1.11
		dev-perl/Date-Manip
		dev-perl/HTML-TableExtract
	)
	sqlite? (
		>=dev-db/libdbi-0.9.0
		>=dev-db/libdbi-drivers-0.9.0[sqlite]
	)
"

DEPEND="${RDEPEND}
	dev-util/intltool
	gnome-base/gnome-common
	sys-devel/libtool
	virtual/pkgconfig
"

PDEPEND="doc? (
	~app-doc/gnucash-docs-${PV}
	gnome-extra/yelp
)"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# Skip test that needs some locales to be present
	sed -i -e '/test_suite_gnc_date/d' src/libqof/qof/test/test-qof.c || die

	# We need to run eautoreconf to prevent linking against system libs,
	# this can be noticed, for example, when updating an old version
	# compiled against guile-1.8 to a newer one relying on 2.0
	# https://bugs.gentoo.org/show_bug.cgi?id=590536#c39
	# https://bugzilla.gnome.org/show_bug.cgi?id=775634
	eautoreconf

	gnome2_src_prepare
}

src_configure() {
	local myconf

	DOCS="doc/README.OFX doc/README.HBCI"

	if use sqlite || use mysql || use postgres ; then
		myconf+=" --enable-dbi"
	else
		myconf+=" --disable-dbi"
	fi

	# gtkmm is experimental and shouldn't be enabled, upstream bug #684166
	gnome2_src_configure \
		--disable-doxygen \
		--disable-error-on-warning \
		--disable-gtkmm \
		--enable-locale-specific-tax \
		$(use_enable debug) \
		$(use_enable gnome-keyring password-storage) \
		$(use_enable hbci aqbanking) \
		$(use_enable ofx) \
		$(use_enable python) \
		${myconf}
}

src_install() {
	# Parallel installation fails from time to time, bug #359123
	# Usually reproducible after removing any gnucash installed copy
	MAKEOPTS="${MAKEOPTS} -j1" GNC_DOC_INSTALL_DIR=/usr/share/doc/${PF} \
	gnome2_src_install

	rm -rf "${ED}"/usr/share/doc/${PF}/{examples/,COPYING,INSTALL,*win32-bin.txt,projects.html}
	mv "${ED}"/usr/share/doc/${PF} "${T}"/cantuseprepalldocs || die
	dodoc "${T}"/cantuseprepalldocs/*
}
