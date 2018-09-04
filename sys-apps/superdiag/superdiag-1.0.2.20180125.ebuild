# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MY_DATE="$(ver_cut 4)"
MY_PN="SuperDiag"
MY_PV="$(ver_cut 1-3)"

DESCRIPTION="Provides the capability to determine the health of Supermicro servers components"
HOMEPAGE="https://www.supermicro.com"
SRC_URI="${MY_PN}_${MY_PV}_${MY_DATE}_package.zip"

KEYWORDS="-* ~amd64 ~x86"
LICENSE="supermicro"
SLOT="0"
IUSE="iso usb"

DEPEND="app-arch/unzip"

RESTRICT="bindist fetch mirror"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	unpack "${S}"/${MY_PN}_${MY_PV}_${MY_DATE}.zip

	if use iso; then
		unzip Diagnose_Remotely/ISOFor${MY_PN}_v${MY_PV}.zip -d iso || die
	fi

	if use usb; then
		unzip Diagnose_Remotely/USBFor${MY_PN}_v${MY_PV}.zip -d usb || die
	fi
}

pkg_nofetch() {
	elog "Please download ${A} from"
	elog "https://www.supermicro.com/SwDownload/UserInfo.aspx?sw=0&cat=SDO"
	elog "and place it in your DISTDIR directory."
}

src_install() {
	insinto /usr/share/superdiag
	doins startup.nsh ${MY_PN}_v${MY_PV}.efi
	newins EFI/Boot/BootX64.efi bootx64.efi

	local DOCS=(
		"Superdiag_${MY_PV}_addendum_release_notes.docx"
		"Supermicro Super Diagnostics Offline readme.txt"
		"SupermicroSuperDiagnosticsOfflineUserGuide_V1.0.pdf"
	)
	dodoc "${DOCS[@]}"

	if use iso; then
		insinto /usr/share/superdiag/iso
		doins iso/${MY_PN}_v${MY_PV}_1238_Internal.iso

		docinto iso
		dodoc iso/Readme.txt
	fi

	if use usb; then
		insinto /usr/share/superdiag/usb
		newins usb/STARTUP.nsh startup.nsh

		dosym ../bootx64.efi /usr/share/superdiag/usb/bootx64.efi
		dosym ../${MY_PN}_v${MY_PV}.efi /usr/share/superdiag/usb/${MY_PN}_v${MY_PV}.efi

		docinto usb
		dodoc usb/Readme.txt
	fi
}
