# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Convert MS Office docx files to plain text"
HOMEPAGE="http://docx2txt.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-arch/unzip
	dev-lang/perl"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1-paragraph-newline.patch
)

src_compile() { :; }

src_install() {
	newbin docx2txt.pl docx2txt
	dodoc docx2txt.config README ChangeLog ToDo AUTHORS
}
