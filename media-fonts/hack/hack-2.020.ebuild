# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit font versionator

DESCRIPTION="A typeface designed for source code"
HOMEPAGE="https://github.com/source-foundry/Hack"
SRC_URI="https://github.com/source-foundry/Hack/releases/download/v${PV}/Hack-v$(replace_version_separator 1 '_' )-otf.tar.xz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""
RESTRICT="binchecks strip"

DEPEND=""
RDEPEND=""

FONT_SUFFIX="otf"

src_unpack() {
	mkdir "${S}" && cd "${S}"
	unpack ${A}
}
