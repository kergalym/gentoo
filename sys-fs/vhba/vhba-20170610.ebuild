# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils linux-mod udev

MY_P=vhba-module-${PV}
DESCRIPTION="Virtual (SCSI) Host Bus Adapter kernel module for the CDEmu suite"
HOMEPAGE="http://cdemu.org"
SRC_URI="mirror://sourceforge/cdemu/${MY_P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~hppa x86"
IUSE=""

RDEPEND="virtual/udev"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}
MODULE_NAMES="vhba(block:${S})"
BUILD_TARGETS=modules

pkg_setup() {
	CONFIG_CHECK="~BLK_DEV_SR ~CHR_DEV_SG"
	check_extra_config
	BUILD_PARAMS="KDIR=${KV_OUT_DIR}"
	linux-mod_pkg_setup
}

src_prepare() {
	# Avoid "make jobserver unavailable" warning and -Werror problems
	sed -e '/ccflags/s/-Werror$/-Wall/' \
		-i Makefile || die "sed failed"

	eapply_user
}

src_install() {
	dodoc AUTHORS ChangeLog README
	linux-mod_src_install

	einfo "Generating udev rules ..."
	dodir "$(get_udevdir)"/rules.d
	cat > "${D}/$(get_udevdir)"/rules.d/69-vhba.rules <<-EOF || die
	# do not edit this file, it will be overwritten on update
	#
	KERNEL=="vhba_ctl", SUBSYSTEM=="misc", TAG+="uaccess"
	EOF
}

pkg_postinst() {
	# Older versions of vhba installed their rule file in /etc/udev/rules.d,
	# which overrides rules in /lib/udev/rules.d. We remove the old file
	# automatically if it is identical to the default one installed by
	# vhba-1.2.1 or 20101015-r1. Note that the comment at the top of the rules
	# file states that it can be automatically overwritten by the system.
	old_rules="${ROOT}etc/udev/rules.d/70-vhba.rules"
	if [[ -f "${old_rules}" ]]; then
		case "$(md5sum ${old_rules})" in
		  2959b3cf61cfe6e466cc3516a7bc19de* | 1e7a7e5d6d28c811eeec98ec26ed5d28* )
		  	elog
			elog "Removing old ${old_rules} ..."
			rm -f "${old_rules}" ||
				eerror "Failed, please remove ${old_rules} manually."
			;;
		  * )
			ewarn
			ewarn "The ${old_rules} file from a previous"
			ewarn "installation of ${PN} is overriding ${P}'s"
			ewarn "udev rules. Unless you had deliberately customized it,"
			ewarn "you should remove it."
			ewarn
			;;
		esac
	fi

	linux-mod_pkg_postinst
}
