# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=UMEMOTO
MODULE_VERSION=0.27
inherit perl-module

DESCRIPTION="IPv6 related part of the C socket.h defines and structure manipulators"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ~m68k ~mips ppc ppc64 ~s390 ~sh x86 ~x64-cygwin ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

SRC_TEST="do"

src_unpack() {
	perl-module_src_unpack
	tc-export CC
}
