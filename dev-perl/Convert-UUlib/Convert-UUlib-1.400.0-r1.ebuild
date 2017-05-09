# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MLEHMANN
MODULE_VERSION=1.4
inherit perl-module

DESCRIPTION="A Perl interface to the uulib library"

LICENSE="Artistic GPL-2" # needs both
SLOT="0"
KEYWORDS="alpha amd64 arm hppa m68k ppc ppc64 s390 sh x86"
IUSE=""

SRC_TEST="do"
