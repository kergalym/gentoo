# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit eutils check-reqs flag-o-matic multilib pax-utils prefix \
	python-any-r1 toolchain-funcs

DESCRIPTION="Low Level Virtual Machine"
HOMEPAGE="http://llvm.org/"
SRC_URI="http://llvm.org/releases/${PV}/${P}.src.tar.xz
	clang? ( http://llvm.org/releases/${PV}/compiler-rt-${PV}.src.tar.xz
		http://llvm.org/releases/${PV}/cfe-${PV}.src.tar.xz )
	https://dev.gentoo.org/~voyageur/distfiles/${PN}-3.5.0-manpages.tar.bz2"

# Additional licenses:
# 1. OpenBSD regex: Henry Spencer's license ('rc' in Gentoo) + BSD.
# 2. ARM backend: LLVM Software Grant by ARM.
# 3. MD5 code: public-domain.
# 4. autoconf (not installed): some undefined M.I.T. license.
# 5. Tests (not installed):
#  a. gtest: BSD.
#  b. YAML tests: MIT.

LICENSE="UoI-NCSA rc BSD public-domain"
SLOT="0/3.5"
KEYWORDS="~ppc-macos ~x64-macos ~x86-macos"
IUSE="clang +libffi"

COMMON_DEPEND="
	sys-libs/zlib:0=
	libffi? ( >=virtual/libffi-3.0.13-r1:0= )"
# configparser-3.2 breaks the build (3.3 or none at all are fine)
DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils
	dev-lang/perl
	>=sys-devel/make-3.81
	>=sys-devel/flex-2.5.4
	>=sys-devel/bison-1.875d
	|| ( >=sys-devel/gcc-apple-4.2.1 >=sys-devel/llvm-3.3 )
	>=sys-devel/binutils-apple-5.1
	libffi? ( virtual/pkgconfig )
	!!<dev-python/configparser-3.3.0.2
	${PYTHON_DEPS}"
RDEPEND="${COMMON_DEPEND}
	clang? ( !<=sys-devel/clang-${PV}-r99
		!>=sys-devel/clang-9999 )"
PDEPEND="clang? ( =sys-devel/clang-${PV}-r100 )"

S=${WORKDIR}/${P}.src

check_space() {
	# in megs
	# !clang !debug !multitarget -O2       400
	# !clang !debug  multitarget -O2       550
	#  clang !debug !multitarget -O2       950
	#  clang !debug  multitarget -O2      1200
	# !clang  debug  multitarget -O2      5G
	#  clang !debug  multitarget -O0 -g  12G
	#  clang  debug  multitarget -O2     16G
	#  clang  debug  multitarget -O0 -g  14G

	local build_size=550
	use clang && build_size=1200

	if is-flagq '-g?(gdb)?([1-9])'; then
		ewarn "The C++ compiler -g option is known to increase the size of the package"
		ewarn "considerably. If you run out of space, please consider removing it."
		ewarn

		(( build_size *= 10 ))
	fi

	local CHECKREQS_DISK_BUILD=${build_size}M
	check-reqs_pkg_pretend

	if [[ ${MERGE_TYPE} != binary ]]; then
		echo 'int main() {return 0;}' > "${T}"/test.cxx || die
		ebegin "Trying to build a C++11 test program"
		if ! $(tc-getCXX) -std=c++11 -o /dev/null "${T}"/test.cxx; then
			eerror "LLVM-${PV} requires C++11-capable C++ compiler. Your current compiler"
			eerror "does not seem to support -std=c++11 option. Please upgrade your compiler"
			eerror "to gcc-4.7 or an equivalent version supporting C++11."
			die "Currently active compiler does not support -std=c++11"
		fi
		eend ${?}
	fi
}

pkg_pretend() {
	check_space
}

pkg_setup() {
	check_space
}

src_unpack() {
	default

	rm -f "${S}"/tools/clang "${S}"/projects/compiler-rt \
		|| die "symlinks removal failed"

	if use clang; then
		mv "${WORKDIR}"/cfe-${PV}.src "${S}"/tools/clang \
			|| die "clang source directory move failed"
		mv "${WORKDIR}"/compiler-rt-${PV}.src "${S}"/projects/compiler-rt \
			|| die "compiler-rt source directory move failed"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/3.6.2/nodoctargz.patch
	epatch "${FILESDIR}"/3.6.2/gcc-4.9.patch
	epatch "${FILESDIR}"/3.5.2/gentoo-install.patch
	epatch "${FILESDIR}"/3.5.2/gcc-5.1.patch

	if use clang; then
		# Automatically select active system GCC's libraries, bugs #406163 and #417913
		epatch "${FILESDIR}"/3.8.1/clang/gentoo-runtime-gcc-detection-v3.patch

		epatch "${FILESDIR}"/3.5.2/clang/gentoo-install.patch
		epatch "${FILESDIR}"/3.9.1/clang/darwin_prefix-include-paths.patch
		eprefixify tools/clang/lib/Frontend/InitHeaderSearch.cpp
	fi

	if use prefix && use clang; then
		sed -i -e "/^CFLAGS /s@-Werror@-I${EPREFIX}/usr/include@" \
			projects/compiler-rt/make/platform/clang_*.mk || die
	fi

	# disable use of SDK on OSX, bug #568758
	sed -i -e 's/xcrun/false/' utils/lit/lit/util.py || die

	local sub_files=(
		Makefile.config.in
		Makefile.rules
		tools/llvm-config/llvm-config.cpp
	)
	use clang && sub_files+=(
		tools/clang/lib/Driver/Tools.cpp
		tools/clang/tools/scan-build/scan-build
	)

	# unfortunately ./configure won't listen to --mandir and the-like, so take
	# care of this.
	# note: we're setting the main libdir intentionally.
	# where per-ABI is appropriate, we use $(GENTOO_LIBDIR) make.
	einfo "Fixing install dirs"
	sed -e "s,@libdir@,$(get_libdir),g" \
		-e "s,@PF@,${PF},g" \
		-e "s,@EPREFIX@,${EPREFIX},g" \
		-i "${sub_files[@]}" \
		|| die "install paths sed failed"

	if use clang; then
		# constantly fails for a long time, likely due to our patches
		rm tools/clang/test/Driver/cross-linux.c || die
	fi

	# User patches
	epatch_user

	python_setup
}

src_configure() {
	# disable timestamps since they confuse ccache
	local conf_flags=(
		--disable-timestamps
		--enable-keep-symbols
		--enable-shared
		--with-optimize-option=
		--enable-optimized
		--disable-assertions
		--disable-expensive-checks
		--disable-libedit
		--disable-terminfo
		$(use_enable libffi)

		--enable-bindings=none
		--enable-targets=host

		ac_cv_prog_XML2CONFIG=""
	)

	if use libffi; then
		local CPPFLAGS=${CPPFLAGS}
		append-cppflags "$($(tc-getPKG_CONFIG) --cflags libffi)"
	fi

	# llvm prefers clang over gcc, so we may need to force that
	tc-export CC CXX

	ECONF_SOURCE=${S} \
	econf "${conf_flags[@]}"
}

src_compile() {
	LLVM_MAKEARGS=(
		VERBOSE=1
		REQUIRES_RTTI=1
		GENTOO_LIBDIR=$(get_libdir)
	)

	emake "${LLVM_MAKEARGS[@]}"

	pax-mark m Release/bin/llvm-rtdyld
	pax-mark m Release/bin/lli
	pax-mark m Release/bin/lli-child-target
}

src_install() {
	emake "${LLVM_MAKEARGS[@]}" DESTDIR="${D}" install

	if ! use clang; then
		rm "${WORKDIR}"/${PN}-3.5.0-manpages/clang.1 || die
	else
		for tool in clang{,++} ; do
			dosym ${tool} /usr/bin/${CHOST}-${tool}
		done
	fi
	doman "${WORKDIR}"/${PN}-3.5.0-manpages/*.1

	# Fix install_names on Darwin.  The build system is too complicated
	# to just fix this, so we correct it post-install
	local lib= f= odylib= ndylib= libpv=${PV}
	if [[ ${CHOST} == *-darwin* ]] ; then
		eval $(grep PACKAGE_VERSION= configure)
		[[ -n ${PACKAGE_VERSION} ]] && libpv=${PACKAGE_VERSION}
		libpvminor=${libpv%.[0-9]*}
		for lib in lib{EnhancedDisassembly,LLVM-${libpv},LTO,profile_rt,clang}.dylib LLVMHello.dylib clang/${libpv}/lib/darwin/libclang_rt.asan_{osx,iossim}_dynamic.dylib; do
			# libEnhancedDisassembly is Darwin10 only, so non-fatal
			# + omit clang libs if not enabled
			[[ -f ${ED}/usr/lib/${lib} ]] || continue

			ebegin "fixing install_name of $lib"
			install_name_tool \
				-id "${EPREFIX}"/usr/lib/${lib} \
				"${ED}"/usr/lib/${lib}
			eend $?
		done
		for f in "${ED}"/usr/bin/* "${ED}"/usr/lib/lib*.dylib "${ED}"/usr/lib/clang/${libpv}/lib/darwin/*.dylib ; do
			# omit clang libs if not enabled
			[[ -f "${f}" ]] || continue

			scanmacho -BF'%n#f' "${f}" | tr ',' '\n' | \
			while read odylib ; do
				ndylib=
				case ${odylib} in
					*/libclang.dylib)
						ndylib="${EPREFIX}"/usr/lib/libclang.dylib
						;;
					*/libLLVM-${libpv}.dylib)
						ndylib="${EPREFIX}"/usr/lib/libLLVM-${libpv}.dylib
						;;
					*/libLLVM-${libpvminor}.dylib)
						ndylib="${EPREFIX}"/usr/lib/libLLVM-${libpvminor}.dylib
						;;
					*/libLTO.dylib)
						ndylib="${EPREFIX}"/usr/lib/libLTO.dylib
						;;
				esac
				if [[ -n ${ndylib} ]] ; then
					ebegin "fixing install_name reference to ${odylib} of ${f##*/}"
					install_name_tool \
						-change "${odylib}" "${ndylib}" \
						"${f}"
					eend $?
				fi
			done
		done
	fi
}
