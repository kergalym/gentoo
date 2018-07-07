# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit unpacker multilib-minimal

SUPER_PN='amdgpu-pro'
MY_PV=$(ver_rs 2 '-')

DESCRIPTION="Proprietary OpenCL implementation for AMD GPUs"
HOMEPAGE="https://support.amd.com/en-us/kb-articles/Pages/Radeon-Software-for-Linux-Release-Notes.aspx"
SRC_URI="${SUPER_PN}-${MY_PV}.tar.xz"

LICENSE="AMD-GPU-PRO-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="dev-libs/ocl-icd"

RESTRICT="mirror fetch strip"

QA_PREBUILT="/opt/amdgpu/lib*/*.so"

S="${WORKDIR}/${SUPER_PN}-${MY_PV}"

pkg_nofetch() {
	local pkgver=$(ver_cut 1-2)
	einfo "Please download the Radeon Software for Linux Driver ${pkgver} for Ubuntu 16 from"
	einfo "    ${HOMEPAGE}"
	einfo "The archive should then be placed into ${DISTDIR}."
}

src_unpack() {
	multilib_src_unpack() {
		local deb_abi
		[[ ${ABI} == x86 ]] && deb_abi=i386
		mkdir -p "${BUILD_DIR}" || die
		pushd "${BUILD_DIR}" >/dev/null || die
		unpack_deb "${S}/opencl-orca-amdgpu-pro-icd_${MY_PV}_${deb_abi:-${ABI}}.deb"
		popd >/dev/null || die
	}
	default
	multilib_parallel_foreach_abi multilib_src_unpack
}

multilib_src_install() {
	local dir_abi short_abi
	[[ ${ABI} == x86 ]] && dir_abi=i386-linux-gnu && short_abi=32
	[[ ${ABI} == amd64 ]] && dir_abi=x86_64-linux-gnu && short_abi=64

	into /opt/amdgpu
	dolib.so "opt/${SUPER_PN}/lib/${dir_abi}"/*
	echo "/opt/amdgpu/$(get_libdir)/libamdocl-orca${short_abi}.so" \
		> "${T}/${SUPER_PN}-${ABI}.icd" || die "Failed to generate ICD file"
	insinto /etc/OpenCL/vendors
	doins "${T}/${SUPER_PN}-${ABI}.icd"
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		ewarn "Please note that using proprietary OpenCL libraries together with the"
		ewarn "Open Source amdgpu stack is not officially supported by AMD. Do not ask them"
		ewarn "for support in case of problems with this package."
		ewarn ""
		ewarn "Furthermore, if you have the whole AMDGPU-Pro stack installed this package"
		ewarn "will almost certainly conflict with it. This might change once AMDGPU-Pro"
		ewarn "has become officially supported by Gentoo."
	fi

	elog "AMD OpenCL driver relies on dev-libs/ocl-icd to work. To enable it, please run"
	elog ""
	elog "    eselect opencl set ocl-icd"
	elog ""
}
