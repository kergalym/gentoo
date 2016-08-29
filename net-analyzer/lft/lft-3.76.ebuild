# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Layer Four Traceroute (LFT) and WhoB"
HOMEPAGE="http://pwhois.org/lft/"
SRC_URI="https://dev.gentoo.org/~jer/${P}.tar.gz"

LICENSE="VOSTROM"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND="
	net-libs/libpcap
"
RDEPEND="
	${DEPEND}
"

DOCS=( CHANGELOG README TODO )

src_prepare() {
	sed -i Makefile.in -e 's:strip:true:g' || die
}
