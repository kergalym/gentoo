# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils user

DESCRIPTION="An authentication service for creating and validating credentials"
HOMEPAGE="https://github.com/dun/munge"
SRC_URI="https://github.com/dun/munge/releases/download/munge-${PV}/munge-${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

IUSE="gcrypt"

DEPEND="
	app-arch/bzip2
	sys-libs/zlib
	gcrypt? ( dev-libs/libgcrypt:0 )
	!gcrypt? ( dev-libs/openssl:0 )"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup munge
	enewuser munge -1 -1 /var/lib/munge munge
}

src_prepare() {
	# Accepted upstream, https://github.com/dun/munge/pull/40
	epatch "${FILESDIR}"/fixed-recursive-use-of-make-in-makefiles.patch

	hprefixify config/x_ac_path_openssl.m4

	eautoreconf
}

src_configure() {
	econf \
		--localstatedir="${EPREFIX}"/var \
		--with-crypto-lib=$(usex gcrypt libgcrypt openssl)
}

src_install() {
	local d

	default

	# 450830
	if [ -d "${ED}"/var/run ]; then
		rm -rf "${ED}"/var/run || die
	fi

	dodir /etc/munge

	for d in "init.d" "default" "sysconfig"; do
		if [ -d "${ED}"/etc/${d} ]; then
			rm -r "${ED}"/etc/${d} || die
		fi
	done

	newconfd "$(prefixify_ro "${FILESDIR}"/${PN}d.confd)" ${PN}d
	newinitd "$(prefixify_ro "${FILESDIR}"/${PN}d.initd)" ${PN}d
}
