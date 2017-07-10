# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils libtool multilib-minimal toolchain-funcs

DESCRIPTION="BSD tar command"
HOMEPAGE="http://www.libarchive.org/"
SRC_URI="http://www.libarchive.org/downloads/${P}.tar.gz"

LICENSE="BSD BSD-2 BSD-4 public-domain"
SLOT="0/13"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x64-cygwin ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="acl +bzip2 +e2fsprogs expat +iconv kernel_linux libressl lz4 +lzma lzo nettle static-libs +threads xattr +zlib"

RDEPEND="
	acl? ( virtual/acl[${MULTILIB_USEDEP}] )
	bzip2? ( app-arch/bzip2[${MULTILIB_USEDEP}] )
	expat? ( dev-libs/expat[${MULTILIB_USEDEP}] )
	!expat? ( dev-libs/libxml2[${MULTILIB_USEDEP}] )
	iconv? ( virtual/libiconv[${MULTILIB_USEDEP}] )
	kernel_linux? (
		xattr? ( sys-apps/attr[${MULTILIB_USEDEP}] )
	)
	!libressl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
	libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
	lz4? ( >=app-arch/lz4-0_p131:0=[${MULTILIB_USEDEP}] )
	lzma? ( app-arch/xz-utils[threads=,${MULTILIB_USEDEP}] )
	lzo? ( >=dev-libs/lzo-2[${MULTILIB_USEDEP}] )
	nettle? ( dev-libs/nettle:0=[${MULTILIB_USEDEP}] )
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	kernel_linux? (
		virtual/os-headers
		e2fsprogs? ( sys-fs/e2fsprogs )
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-3.3.1-libressl.patch
)

src_prepare() {
	default
	elibtoolize  # is required for Solaris sol2_ld linker fix
}

multilib_src_configure() {
	export ac_cv_header_ext2fs_ext2_fs_h=$(usex e2fsprogs) #354923

	local myconf=()
	myconf=(
		$(use_enable acl)
		$(use_enable static-libs static)
		$(use_enable xattr)
		$(use_with bzip2 bz2lib)
		$(use_with expat)
		$(use_with !expat xml2)
		$(use_with iconv)
		$(use_with lz4)
		$(use_with lzma)
		$(use_with lzo lzo2)
		$(use_with nettle)
		$(use_with zlib)
	)
	if multilib_is_native_abi ; then myconf+=(
		--enable-bsdcat=$(tc-is-static-only && echo static || echo shared)
		--enable-bsdcpio=$(tc-is-static-only && echo static || echo shared)
		--enable-bsdtar=$(tc-is-static-only && echo static || echo shared)
	); else myconf+=(
		--disable-bsdcat
		--disable-bsdcpio
		--disable-bsdtar
	); fi

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_compile() {
	if multilib_is_native_abi ; then
		emake
	else
		emake libarchive.la
	fi
}

multilib_src_test() {
	# Replace the default src_test so that it builds tests in parallel
	multilib_is_native_abi && emake check
}

multilib_src_install() {
	if multilib_is_native_abi ; then
		emake DESTDIR="${D}" install

		# Create symlinks for FreeBSD
		if ! use prefix && [[ ${CHOST} == *-freebsd* ]]; then
			# Exclude cat for the time being #589876
			for bin in cpio tar; do
				dosym bsd${bin} /usr/bin/${bin}
				echo '.so bsd${bin}.1' > "${T}"/${bin}.1
				doman "${T}"/${bin}.1
			done
		fi
	else
		emake DESTDIR="${D}" \
			install-includeHEADERS \
			install-libLTLIBRARIES \
			install-pkgconfigDATA
	fi

	# Libs.private: should be used from libarchive.pc instead
	prune_libtool_files
}

multilib_src_install_all() {
	cd "${S}" || die
	einstalldocs
}
