# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# Don't depend on itself.
JAVA_ANT_DISABLE_ANT_CORE_DEP="true"

# Rewriting build.xml files for the testcases has no use at the moment.
JAVA_PKG_BSFIX_ALL="no"
JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2 prefix versionator

MY_P="apache-ant-${PV}"

DESCRIPTION="Java-based build tool similar to 'make' that uses XML configuration files"
HOMEPAGE="http://ant.apache.org/"
SRC_URI="https://archive.apache.org/dist/ant/source/${MY_P}-src.tar.bz2
	https://dev.gentoo.org/~tomwij/files/dist/ant-${PV}-gentoo.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc64 x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

DEPEND="|| ( >=virtual/jdk-1.5 dev-java/gcj-jdk )
	!dev-java/ant-tasks
	!dev-java/ant-optional"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

RESTRICT="test"

src_prepare() {
	EPATCH_FORCE="yes" EPATCH_SUFFIX="patch" epatch "${WORKDIR}/patches/"
	eprefixify "${WORKDIR}/ant"

	# use our split-ant build.xml.
	mv -f "${WORKDIR}/build.xml" . || die

	# Fixes bug 556008.
	java-ant_xml-rewrite -f build.xml \
		-c -e javadoc \
		-a failonerror \
		-v "false"

	# See bug #196080 for more details.
	java-ant_bsfix_one build.xml
	java-pkg-2_src_prepare
}

src_compile() {
	export ANT_HOME=""

	local bsyscp

	# This ensures that when building ant with bootstrapped ant,
	# only the source is used for resolving references, and not
	# the classes in bootstrapped ant but jikes in kaffe has issues with this...
	if ! java-pkg_current-vm-matches kaffe; then
		bsyscp="-Dbuild.sysclasspath=ignore"
	fi

	CLASSPATH="$(java-config -t)" ./build.sh ${bsyscp} jars internal_dist \
		$(use_doc javadocs) || die "build failed"
}

src_install() {
	dodir /usr/share/ant/lib

	for jar in ant.jar ant-bootstrap.jar ant-launcher.jar ; do
		java-pkg_dojar build/lib/${jar}
		dosym /usr/share/${PN}/lib/${jar} /usr/share/ant/lib/${jar}
	done

	dobin "${WORKDIR}/ant"

	dodir /usr/share/${PN}/bin
	for each in antRun antRun.pl runant.pl runant.py complete-ant-cmd.pl ; do
		dobin "${S}/src/script/${each}"
		dosym /usr/bin/${each} /usr/share/${PN}/bin/${each}
	done
	dosym /usr/share/${PN}/bin /usr/share/ant/bin

	insinto /usr/share/${PN}
	doins -r dist/etc
	dosym /usr/share/${PN}/etc /usr/share/ant/etc

	echo "ANT_HOME=\"${EPREFIX}/usr/share/ant\"" > "${T}/20ant"
	doenvd "${T}/20ant"

	dodoc NOTICE README WHATSNEW KEYS

	if use doc; then
		dohtml -r manual/*
		java-pkg_dojavadoc --symlink manual/api build/javadocs
	fi

	use source && java-pkg_dosrc src/main/*
}

pkg_postinst() {
	if [[ -n ${REPLACING_VERSIONS} ]]; then
		if ! version_is_at_least 1.7.0 ${REPLACING_VERSIONS}; then
			elog "The way of packaging ant in Gentoo has changed significantly since"
			elog "the 1.7.0 version, For more information, please see:"
			elog "https://www.gentoo.org/proj/en/java/ant-guide.xml"
		fi

		if ! version_is_at_least 1.7.1 ${REPLACING_VERSIONS}; then
			elog "Since 1.7.1, the ant-tasks meta-ebuild has been removed and its USE"
			elog "flags have been moved to dev-java/ant."
		fi
	fi
}
