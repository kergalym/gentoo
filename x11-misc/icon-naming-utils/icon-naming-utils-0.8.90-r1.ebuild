# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Utils to help with the transition to the new freedesktop.org naming scheme"
HOMEPAGE="http://tango.freedesktop.org"
SRC_URI="http://tango.freedesktop.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=dev-perl/XML-Simple-2
	 >=dev-lang/perl-5"
DEPEND="${RDEPEND}"
