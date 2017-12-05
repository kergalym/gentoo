# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

#inherit eutils multilib toolchain-funcs
inherit toolchain-funcs

DESCRIPTION="Utility to detect other OSs on a set of drives"
HOMEPAGE="https://packages.debian.org/source/sid/os-prober"
SRC_URI="mirror://debian/pool/main/${PN::1}/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# bug 594250
QA_MULTILIB_PATHS="usr/lib/os-prober/.*"

src_prepare() {
	# use default GNU rules
	rm Makefile || die 'rm Makefile failed'
}

src_compile() {
	tc-export CC
	emake newns
}

src_install() {
	dobin os-prober linux-boot-prober

	# Note: as no shared libraries are installed, /usr/lib is correct
	exeinto /usr/lib/os-prober
	doexe newns

	insinto /usr/share/os-prober
	doins common.sh

	keepdir /var/lib/os-prober

	local debarch=${ARCH%-*} dir

	case ${debarch} in
		amd64)		debarch=x86 ;;
		ppc|ppc64)	debarch=powerpc ;;
	esac

	for dir in os-probes{,/mounted,/init} linux-boot-probes{,/mounted}; do
		exeinto /usr/lib/$dir
		doexe $dir/common/*
		if [[ -d $dir/$debarch ]]; then
			doexe $dir/$debarch/*
		fi
		if [[ -d $dir/$debarch/efi ]]; then
			exeinto /usr/lib/$dir/efi
			doexe $dir/$debarch/efi/*
		fi
	done

	if use amd64 || use x86; then
		exeinto /usr/lib/os-probes/mounted
		doexe os-probes/mounted/powerpc/20macosx
	fi

	dodoc README TODO debian/changelog
}

pkg_postinst() {
	elog "If you intend for os-prober to detect versions of Windows installed on"
	elog "NTFS-formatted partitions, your system must be capable of reading the"
	elog "NTFS filesystem. One way to do this is by installing sys-fs/ntfs3g"
}
