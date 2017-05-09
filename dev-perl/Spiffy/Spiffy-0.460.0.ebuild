# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=INGY
MODULE_VERSION=0.46
inherit perl-module

DESCRIPTION="Spiffy Perl Interface Framework For You"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~mips ppc ppc64 ~s390 ~sh x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=">=virtual/perl-ExtUtils-MakeMaker-6.300.0"

SRC_TEST="do"
