# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="The class loader framework of the Plexus project"
HOMEPAGE="https://github.com/codehaus"
SRC_URI="https://dev.gentoo.org/~ercpe/distfiles/${CATEGORY}/${PN}/${P}.tar.bz2"

LICENSE="codehaus-classworlds"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.6
		test? ( dev-java/junit:4 )"
RDEPEND=">=virtual/jre-1.6"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_TEST_GENTOO_CLASSPATH="junit-4"
EANT_TEST_ANT_TASKS="ant-junit"

java_prepare() {
	cp "${FILESDIR}"/${PV}-build.xml "${S}"/build.xml || die
}

src_install() {
	java-pkg_newjar "${S}/target/${P}.jar" "${PN}.jar"

	use source && java-pkg_dosrc "${S}"/src/main/java/*
	use doc && java-pkg_dojavadoc "${S}"/target/site/apidocs
}

src_test() {
	java-pkg-2_src_test
}
