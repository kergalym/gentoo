# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit user
MY_PN=${PN/-bin/}
MY_PV="4.1.1-1484211277"
S=${WORKDIR}/${MY_PN}-${MY_PV}

DESCRIPTION="Gorgeous metric viz, dashboards & editors for Graphite, InfluxDB & OpenTSDB"
HOMEPAGE="http://grafana.org"
SRC_URI="https://grafanarel.s3.amazonaws.com/builds/${MY_PN}-${MY_PV}.linux-x64.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	app-admin/logrotate
	>=dev-lang/go-1.5
	net-libs/nodejs
"

pkg_setup() {
	enewgroup grafana
	enewuser grafana -1 -1 /usr/share/grafana grafana
}

src_install() {
	keepdir /etc/grafana
	insinto /etc/grafana
	newins "${S}"/conf/sample.ini grafana.ini
	rm "${S}"/conf/sample.ini

	# Frontend assets
	insinto /usr/share/${MY_PN}
	doins -r public conf vendor

	dobin bin/grafana-cli
	dobin bin/grafana-server

	newconfd "${FILESDIR}"/grafana.confd grafana
	newinitd "${FILESDIR}"/grafana.initd.2 grafana

	keepdir /var/{lib,log}/grafana /var/lib/grafana/dashboards
	fowners grafana:grafana /var/{lib,log}/grafana /var/lib/grafana/dashboards
	fperms 0755 /var/{lib,log}/grafana /var/lib/grafana/dashboards

	# Logrotation
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/logrotated.grafana ${PN}
}
