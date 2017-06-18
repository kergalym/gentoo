# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TLINDEN
DIST_VERSION=2.63
DIST_EXAMPLES=("example.cfg")
inherit perl-module

DESCRIPTION="Config file parser module"

SLOT="0"
KEYWORDS="amd64 arm ~arm64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	virtual/perl-File-Spec
	virtual/perl-IO
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
