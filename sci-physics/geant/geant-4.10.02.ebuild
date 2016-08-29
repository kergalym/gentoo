# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CMAKE_MIN_VERSION="3.3"
inherit cmake-utils eutils versionator multilib

PV1=$(get_version_component_range 1 ${PV})
PV2=$(get_version_component_range 2 ${PV})
PV3=$(get_version_component_range 3 ${PV})
SPV3=$(printf %1d ${PV3})
MYP=${PN}$(replace_version_separator 3 .)

DESCRIPTION="Toolkit for simulation of passage of particles through matter"
HOMEPAGE="http://geant4.cern.ch/"
SRC_URI="http://geant4.cern.ch/support/source/${MYP}.tar.gz"

LICENSE="geant4"
SLOT="4"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+data dawn doc examples gdml geant3 inventor motif opengl
	raytracerx qt4 static-libs vrml zlib threads"

RDEPEND="
	dev-libs/expat
	=sci-physics/clhep-2.3.1.0:2=
	dawn? ( media-gfx/dawn )
	gdml? ( dev-libs/xerces-c )
	motif? ( x11-libs/motif:0 )
	opengl? ( virtual/opengl )
	inventor? ( media-libs/SoXt )
	qt4? ( dev-qt/qtgui:4 opengl? ( dev-qt/qtopengl:4 ) )
	raytracerx? ( x11-libs/libX11 x11-libs/libXmu )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND} prefix? ( app-shells/tcsh )"
PDEPEND="
	data? ( ~sci-physics/geant-data-${PV1}.${PV2}.${PV3} )
	doc? ( ~app-doc/geant-docs-${PV1}.${PV2}.${SPV3} )"

S="${WORKDIR}/${MYP}"

src_prepare() {
	epatch -p1 "${FILESDIR}/${P}-std-isnan.patch"
	use examples || epatch "${FILESDIR}"/${PN}-${PV1}.${PV2}.${SPV3}-no-examples.patch
}

src_configure() {
	local mycmakeargs=(
		-DGEANT4_USE_SYSTEM_CLHEP=ON
		-DGEANT4_INSTALL_DATA=OFF
		$(cmake-utils_use threads GEANT4_BUILD_MULTITHREADED)
		$(cmake-utils_use dawn GEANT4_USE_NETWORKDAWN)
		$(cmake-utils_use gdml GEANT4_USE_GDML)
		$(cmake-utils_use geant3 GEANT4_USE_G3TOG4)
		$(cmake-utils_use motif GEANT4_USE_XM)
		$(cmake-utils_use opengl GEANT4_USE_OPENGL_X11)
		$(cmake-utils_use inventor GEANT4_USE_INVENTOR)
		$(cmake-utils_use qt4 GEANT4_USE_QT)
		$(cmake-utils_use raytracerx GEANT4_USE_RAYTRACER_X11)
		$(cmake-utils_use vrml GEANT4_USE_NETWORKVRML)
		$(cmake-utils_use zlib GEANT4_USE_SYSTEM_ZLIB)
		$(cmake-utils_use_build static-libs STATIC_LIBS)
	)
	if use inventor; then
		mycmakeargs+=(
			-DINVENTOR_INCLUDE_DIR="$(coin-config --includedir)"
			-DINVENTOR_SOXT_INCLUDE_DIR="$(coin-config --includedir)"
		)
	fi
	cmake-utils_src_configure
}

src_install() {
	# adjust clhep linking flags for system clhep
	# binmake.gmk is only useful for legacy build systems
	sed -i -e 's/-lG4clhep/-lCLHEP/' config/binmake.gmk || die
	cmake-utils_src_install
	insinto /usr/share/doc/${PF}
	doins ReleaseNotes/ReleaseNotes${PV1}.${PV2}.${SPV3}.html
	[[ -f ReleaseNotes/Patch${PV1}.${PV2}.${SPV3}-1.txt ]] && \
		dodoc ReleaseNotes/Patch${PV1}.${PV2}.${SPV3}-*.txt
}

pkg_postinst() {
	elog "The following scripts are provided for backward compatibility:"
	elog "$(ls -1 ${EROOT%/}/usr/share/Geant4-${PV2}.${SPV3}.*/geant4make/*sh)"
}
