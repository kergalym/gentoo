# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson xdg-utils

DESCRIPTION="An EFL-based IDE"
HOMEPAGE="https://www.enlightenment.org/about-edi"
SRC_URI="https://github.com/Enlightenment/edi/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="clang"

RDEPEND="
	>=dev-libs/efl-1.21.1[eet,X]
	clang? ( sys-devel/clang:* )
"
DEPEND="
	${RDEPEND}
	dev-libs/check
"

src_prepare() {
	default
	xdg_environment_reset
}

src_configure() {
	local emesonargs=(
		-D bear=false
	)

	if use clang; then
		local clangver=$(clang --version | grep -Eo '[0-9]' | head -n1) || die
		emesonargs+=(
			-D libclang=true
			-D libclang-headerdir="/usr/lib/llvm/${clangver}/include/"
			-D libclang-libdir="/usr/lib/llvm/${clangver}/$(get_libdir)/"
		)

	else
		emesonargs+=(
			-D libclang=false
		)

	fi

	meson_src_configure
}
