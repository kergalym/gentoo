# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CHROMIUM_LANGS="
	be bg bn ca cs da de el en-GB es-419 es fil fi fr-CA fr hi hr hu id it ja
	ko lt lv ms nb nl pl pt-BR pt-PT ro ru sk sr sv sw ta te th tr uk vi zh-CN
	zh-TW
"
inherit chromium-2 gnome2-utils multilib unpacker xdg-utils

DESCRIPTION="A fast and secure web browser"
HOMEPAGE="https://www.opera.com/"
LICENSE="OPERA-2014"
SLOT="0"
SRC_URI_BASE="
	https://download1.operacdn.com/pub/
	https://download2.operacdn.com/pub/
	https://download3.operacdn.com/pub/
	https://download4.operacdn.com/pub/
"
for uri in ${SRC_URI_BASE}; do
SRC_URI+="
	"${uri}${PN}/desktop/${PV}/linux/${PN}-stable_${PV}_amd64.deb"
"
done
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gconf:2
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	net-misc/curl
	net-print/cups
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libnotify
	x11-libs/pango[X]
"

QA_PREBUILT="*"
S=${WORKDIR}
OPERA_HOME="usr/$(get_libdir)/${PN}"

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	case ${ARCH} in
		amd64)
			mv usr/lib/x86_64-linux-gnu usr/$(get_libdir) || die
			rm -r usr/lib || die
			;;
	esac

	rm usr/bin/${PN} || die

	rm usr/share/doc/${PN}-stable/copyright || die
	mv usr/share/doc/${PN}-stable usr/share/doc/${PF} || die

	pushd "${OPERA_HOME}/localization" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	sed -i \
		-e 's|^TargetEnvironment|X-&|g' \
		usr/share/applications/${PN}.desktop || die
}

src_install() {
	mv * "${D}" || die
	dosym ../$(get_libdir)/${PN}/${PN} /usr/bin/${PN}
	fperms 4711 /usr/$(get_libdir)/${PN}/opera_sandbox
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
