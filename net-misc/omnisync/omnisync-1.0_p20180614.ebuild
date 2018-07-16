# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils vcs-snapshot

SNAPSHOT="b3a759af454552f4bbd3b1e097b41bd0d1d7fcf5"

DESCRIPTION="A driver for NTPd for people who are firewall-challenged"
HOMEPAGE="https://www.vanheusden.com/time/omnisync"
LICENSE="GPL-2"
SRC_URI="https://gitlab.com/grknight/omnisync/-/archive/${SNAPSHOT}/omnisync-${SNAPSHOT}.tar.bz2 -> ${P}.tar.bz2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-libs/gnutls:= net-analyzer/net-snmp:="
DEPEND="${RDEPEND}"
DOCS=( readme.txt Changes )

src_install() {
	cmake-utils_src_install
	newinitd "${FILESDIR%/}/${PN}.initd" ${PN}
	newconfd "${FILESDIR%/}/${PN}.confd" ${PN}
	einstalldocs
}

pkg_postinst() {
	local isConfigured=$(grep 'OMNISYNC_MODE=""' "${ROOT%/}/etc/conf.d/${PN}")
	if [[ -n "${isConfigured}" ]] ; then
		elog "Be sure to configure ${PN} in ${ROOT%/}/etc/conf.d before trying to start the service"
	fi
}
