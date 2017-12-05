# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils

MY_PN=${PN/grabi/GrabI}

DESCRIPTION="wmGrabImage grabs an image from the WWW and displays it"
HOMEPAGE="http://www.dockapps.net/wmgrabimage"
SRC_URI="http://www.dockapps.net/download/${MY_PN}-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

RDEPEND=">=net-misc/wget-1.9-r2
	>=media-gfx/imagemagick-5.5.7.15
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto
	>=sys-apps/sed-4.1.5-r1"

S=${WORKDIR}/${MY_PN}-${PV}/${MY_PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-noman.patch
	sed -i -e 's/-geom /-geometry /' GrabImage || die "sed failed."
	sed -i -e 's/install -s -m /install -m /' Makefile || die "sed failed."
}

src_compile() {
	emake clean || die "emake clean failed."
	emake CFLAGS="${CFLAGS} -Wall" SYSTEM="${LDFLAGS}" || die "emake failed."
}

src_install() {
	dodir /usr/bin
	emake DESTDIR="${D}/usr" install || die "einstall failed."

	doman wmGrabImage.1

	dodoc ../{BUGS,CHANGES,HINTS,TODO}

	domenu "${FILESDIR}"/${PN}.desktop
}
