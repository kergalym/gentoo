# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual for LeechCraft plugins capable of visually notifying the user"
SLOT="0"

RDEPEND="|| (
		~app-leechcraft/lc-kinotify-${PV}
		~app-leechcraft/lc-dbusmanager-${PV}
	)"
