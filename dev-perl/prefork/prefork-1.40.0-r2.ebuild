# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ADAMK
MODULE_VERSION=1.04
inherit perl-module

DESCRIPTION="Optimized module loading for forking or non-forking processes"

SLOT="0"
KEYWORDS="alpha amd64 ~arm arm64 hppa ia64 m68k ~mips ppc ~ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

DEPEND=">=virtual/perl-File-Spec-0.80
	>=virtual/perl-Scalar-List-Utils-1.10"
RDEPEND="${DEPEND}"

SRC_TEST="do"

src_prepare() {
	sed -i -e 's/use inc::Module::Install::DSL /use lib q[.];\nuse inc::Module::Install::DSL /' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
