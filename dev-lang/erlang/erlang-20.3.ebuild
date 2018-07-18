# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WX_GTK_VER="3.0"

inherit autotools elisp-common java-pkg-opt-2 systemd versionator wxwidgets

# NOTE: If you need symlinks for binaries please tell maintainers or
# open up a bug to let it be created.

DESCRIPTION="Erlang programming language, runtime environment and libraries (OTP)"
HOMEPAGE="http://www.erlang.org/"
SRC_URI="http://www.erlang.org/download/otp_src_${PV}.tar.gz
	http://erlang.org/download/otp_doc_man_${PV}.tar.gz
	doc? ( http://erlang.org/download/otp_doc_html_${PV}.tar.gz )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"

IUSE="compat-ethread dirty-schedulers doc emacs hipe java kpoll libressl odbc smp sctp ssl systemd tk wxwidgets"
REQUIRED_USE="dirty-schedulers? ( smp )" #621610

# False positives caused by nested configure scripts
QA_CONFIGURE_OPTIONS="--disable-silent-rules"

RDEPEND="
	ssl? (
		!libressl? ( >=dev-libs/openssl-0.9.7d:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	emacs? ( virtual/emacs )
	java? ( >=virtual/jdk-1.2:* )
	odbc? ( dev-db/unixODBC )
	systemd? ( sys-apps/systemd )
"
DEPEND="${RDEPEND}
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}[X,opengl] virtual/glu )
	sctp? ( net-misc/lksctp-tools )
	tk? ( dev-lang/tk )
"

S="${WORKDIR}/otp_src_${PV}"

SITEFILE=50${PN}-gentoo.el

src_prepare() {
	default

	eapply "${FILESDIR}"/18.2.1-wx3.0.patch

	if ! use odbc; then
		sed -i 's: odbc : :' lib/Makefile || die
		rm -rf lib/odbc/
	fi

	# bug 263129, don't ignore LDFLAGS, reported upstream
	sed -e 's:LDFLAGS = \$(DED_LDFLAGS):LDFLAGS += \$(DED_LDFLAGS):' -i "${S}"/lib/megaco/src/flex/Makefile.in

	# don't ignore LDFLAGS, reported upstream
	use odbc && sed -e 's:LDFLAGS =  \$(ODBC_LIB) \$(EI_LDFLAGS):LDFLAGS += \$(ODBC_LIB) \$(EI_LDFLAGS):' -i "${S}"/lib/odbc/c_src/Makefile.in

	if ! use wxwidgets; then
		sed -i 's: wx : :' lib/Makefile
		rm -rf lib/wx
	fi

	# Nasty workaround, reported upstream
	cp "${S}"/lib/configure.in.src "${S}"/lib/configure.in

	# bug 383697
	sed -i '1i#define OF(x) x' erts/emulator/drivers/common/gzio.c

	cd erts && mv configure.in configure.ac && eautoreconf
}

src_configure() {
	use wxwidgets && need-wxwidgets unicode
	use java || export JAVAC=false

	econf \
		--enable-threads \
		$(use_enable sctp) \
		$(use_enable systemd) \
		$(use_enable hipe) \
		$(use_with ssl ssl "${EPREFIX}"/usr) \
		$(use_enable ssl dynamic-ssl-lib) \
		$(use_enable kpoll kernel-poll) \
		$(use_enable smp smp-support) \
		$(use compat-ethread && echo "--enable-ethread-pre-pentium4-compatibility") \
		$(use x64-macos && echo "--enable-darwin-64bit") \
		$(use_enable dirty-schedulers)
}

src_compile() {
	use java || export JAVAC=false
	emake

	if use emacs ; then
		pushd lib/tools/emacs
		elisp-compile *.el
		popd
	fi
}

extract_version() {
	sed -n -e "/^$2 = \(.*\)$/s::\1:p" "${S}/$1/vsn.mk"
}

src_install() {
	local ERL_LIBDIR=/usr/$(get_libdir)/erlang
	local ERL_INTERFACE_VER=$(extract_version lib/erl_interface EI_VSN)
	local ERL_ERTS_VER=$(extract_version erts VSN)

	emake INSTALL_PREFIX="${D}" install
	einstalldocs

	dosym "${ERL_LIBDIR}/bin/erl" /usr/bin/erl
	dosym "${ERL_LIBDIR}/bin/erlc" /usr/bin/erlc
	dosym "${ERL_LIBDIR}/bin/escript" /usr/bin/escript
	dosym \
		"${ERL_LIBDIR}/lib/erl_interface-${ERL_INTERFACE_VER}/bin/erl_call" \
		/usr/bin/erl_call

	if use smp; then
		dosym "${ERL_LIBDIR}/erts-${ERL_ERTS_VER}/bin/beam.smp" /usr/bin/beam.smp
	else
		dosym "${ERL_LIBDIR}/erts-${ERL_ERTS_VER}/bin/beam" /usr/bin/beam
	fi

	## Clean up the no longer needed files
	rm "${ED}/${ERL_LIBDIR}/Install"

	for i in "${WORKDIR}"/man/man* ; do
		dodir "${ERL_LIBDIR}/${i##${WORKDIR}}"
	done
	for file in "${WORKDIR}"/man/man*/*.[1-9]; do
		# doman sucks so we can't use it
		cp ${file} "${ED}/${ERL_LIBDIR}"/man/man${file##*.}/
	done
	# extend MANPATH, so the normal man command can find it
	# see bug 189639
	dodir /etc/env.d/
	echo "MANPATH=\"${EPREFIX}${ERL_LIBDIR}/man\"" > "${ED}/etc/env.d/90erlang"

	if use doc ; then
		dohtml -A README,erl,hrl,c,h,kwc,info -r \
			"${WORKDIR}"/doc "${WORKDIR}"/lib "${WORKDIR}"/erts-*
	fi

	if use emacs ; then
		pushd "${S}"
		elisp-install erlang lib/tools/emacs/*.{el,elc}
		sed -e "s:/usr/share:${EPREFIX}/usr/share:g" \
			"${FILESDIR}"/${SITEFILE} > "${T}"/${SITEFILE}
		elisp-site-file-install "${T}"/${SITEFILE}
		popd
	fi

	newinitd "${FILESDIR}"/epmd.init epmd
	systemd_dounit "${FILESDIR}"/epmd.service
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
