# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="5"

IUSE=""
MODS="dkim"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for dkim"

if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
fi

DEPEND="${DEPEND}
	sec-policy/selinux-milter
"
RDEPEND="${RDEPEND}
	sec-policy/selinux-milter
"
