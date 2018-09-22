# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A GTK theme to match Enlightenment WM's default theme"
HOMEPAGE="https://gitlab.com/tokiclover/e-gtk-theme"
SRC_URI="https://gitlab.com/tokiclover/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	:;
}

src_install() {
	insinto /usr/share/themes/e-gtk-theme
	doins -r gtk-2.0/
	doins -r gtk-3.0/
	doins index.theme
	doins start-here.png

	einstalldocs

	find "${D}" -name 'Makefile' -delete || die
}

pkg_postinst() {
	elog "If you wish to have matching theme for Openbox or Firefox, visit"
	elog "project's homepage at https://gitlab.com/tokiclover/e-gtk-theme"
}
