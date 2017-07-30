# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils autotools

MY_P=Eterm-${PV}

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://git.enlightenment.org/apps/eterm.git"
	inherit git-r3
else
	SRC_URI="http://www.eterm.org/download/${MY_P}.tar.gz
		!minimal? ( http://www.eterm.org/download/Eterm-bg-${PV}.tar.gz )"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~ppc-macos ~x86-macos"
fi

DESCRIPTION="A vt102 terminal emulator for X"
HOMEPAGE="http://www.eterm.org/"

LICENSE="BSD"
SLOT="0"
IUSE="escreen minimal cpu_flags_x86_mmx cpu_flags_x86_sse2 unicode +utempter"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libICE
	x11-libs/libSM
	x11-proto/xextproto
	x11-proto/xproto
	>=x11-libs/libast-0.6.1
	media-libs/imlib2[X]
	media-fonts/font-misc-misc
	escreen? ( app-misc/screen )
"
DEPEND="${RDEPEND}"

if [[ ${PV} == "9999" ]] ; then
	S=${WORKDIR}/${P}
else
	S=${WORKDIR}/${MY_P}
fi

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git-r3_src_unpack
		cd "${S}" || die
		eautoreconf
	else
		unpack ${MY_P}.tar.gz
		cd "${S}" || die
		use minimal || unpack Eterm-bg-${PV}.tar.gz
	fi
}

src_configure() {
	export TIC="true"
	econf \
		--disable-static \
		$(use_enable escreen) \
		--with-imlib \
		--enable-trans \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable unicode multi-charset) \
		$(use_enable utempter utmp) \
		--with-delete=execute \
		--with-backspace=auto
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ChangeLog README ReleaseNotes
	use escreen && dodoc doc/README.Escreen
	dodoc bg/README.backgrounds

	# We don't install headers to link against this library
	rm -f "${D}"/usr/*/libEterm.{so,la}
}
