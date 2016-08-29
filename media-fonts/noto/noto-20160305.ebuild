# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit font

DESCRIPTION="Google's font family that aims to support all the world's languages"
HOMEPAGE="https://www.google.com/get/noto/"
SRC_URI="https://dev.gentoo.org/~pacho/${PN}/${P}.zip"
# renamed from upstream's unversioned Noto-hinted.zip
# version number based on the timestamp of most recently updated font in the zip

LICENSE="OFL-1.1" # https://github.com/googlei18n/noto-fonts/blob/master/NEWS
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RESTRICT="binchecks strip"

S=${WORKDIR}
FONT_S="${S}"
FONT_SUFFIX="otf ttf"
