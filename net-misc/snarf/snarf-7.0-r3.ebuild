# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils

IUSE=""
DESCRIPTION="Small and fast CLI resource grabber for http, gopher, finger, ftp"
SRC_URI="https://www.xach.com/snarf/${P}.tar.gz"
HOMEPAGE="https://www.xach.com/snarf/"
KEYWORDS="alpha amd64 ppc sparc x86"
LICENSE="GPL-2"
SLOT="0"

DEPEND=""

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/snarf-basename-patch.diff
	epatch "${FILESDIR}"/snarf-unlink-empty.diff
	epatch "${FILESDIR}"/snarf-fix-off-by-ones.diff
}

src_install() {
	dobin snarf
	doman snarf.1
	dodoc ChangeLog README TODO
}

pkg_postinst() {
	elog 'To use snarf with portage, try these settings in your make.conf'
	elog
	elog '	FETCHCOMMAND="/usr/bin/snarf -b \${URI} \${DISTDIR}/\${FILE}"'
	elog '	RESUMECOMMAND="/usr/bin/snarf -rb \${URI} \${DISTDIR}/\${FILE}"'
}
