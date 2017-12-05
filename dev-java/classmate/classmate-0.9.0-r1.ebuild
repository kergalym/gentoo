# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-pkg-simple vcs-snapshot

DESCRIPTION="Zero-dependency Java library for accurately introspecting type information"
HOMEPAGE="https://github.com/cowtowncoder/java-classmate/"
SRC_URI="https://github.com/cowtowncoder/java-classmate/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6
	test? ( dev-java/junit:4 )"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/main/java"

# This one test is buggy.
JAVA_RM_FILES=(
	src/test/java/com/fasterxml/classmate/AnnotationsTest.java
)

java_prepare() {
	rm pom.xml || die
}

src_test() {
	testcp="${S}/${PN}.jar:$(java-pkg_getjars junit-4):target/tests"

	mkdir target/tests || die
	ejavac -cp "${testcp}" -d target/tests $(find src/test/java -name "*.java")

	tests=$(find target/tests -name "*Test.class" -not -name "BaseTest.class" \
			| sed -e 's/target\/tests\///g' -e "s/\.class//" -e "s/\//./g" \
			| grep -vP '\$');
	ejunit4 -cp "${testcp}" ${tests}
}
