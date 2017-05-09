# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_VERSION=2.24
DIST_AUTHOR=RURBAN
inherit perl-module

DESCRIPTION="Interface to Bzip2 compression library"

SLOT="0"
KEYWORDS="~amd64 ~mips ~x86 ~ppc-aix"
IUSE="test"

RDEPEND="
	app-arch/bzip2
	virtual/perl-Carp
	virtual/perl-File-Spec
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
