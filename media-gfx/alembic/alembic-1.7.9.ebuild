# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

DESCRIPTION="Alembic is an open framework for storing and sharing scene data"
HOMEPAGE="http://alembic.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64"
IUSE="arnold +boost doc examples hdf5 maya prman python test zlib"

# pyalembic python bindings need boost
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	hdf5? ( zlib )
	python? ( boost )
"

CDEPEND="${PYTHON_DEPS}
	>=media-libs/openexr-2.2.0
	boost? ( >=dev-libs/boost-1.65.0[python,${PYTHON_USEDEP}] )
	hdf5? ( >=sci-libs/hdf5-1.8.18[zlib(+)] )
	python? ( >=dev-python/pyilmbase-2.2.0[${PYTHON_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.11-r1 )
"
DEPEND="${CDEPEND}
	>=dev-util/cmake-3.9.6
	doc? ( >=app-doc/doxygen-1.8.13-r1 )
"
RDEPEND="${CDEPEND}"

DOCS=( "ACKNOWLEDGEMENTS.txt" "FEEDBACK.txt" "NEWS.txt" "README.txt" )

PATCHES=(
	"${FILESDIR}/${PN}-FindIlmBase-pkgconfig.patch"
	"${FILESDIR}/${P}-CMakeLists-fix_lib.patch"
	"${FILESDIR}/${P}-prman.patch"
)

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DALEMBIC_SHARED_LIBS=ON
		# The CMakeLists.txt file needs C++11 or C++-0x if none of them
		# is defined
		-DALEMBIC_LIB_USES_BOOST=$(usex boost)
		-DALEMBIC_LIB_USES_TR1=$(usex !boost)
		-DUSE_ARNOLD=$(usex arnold)
		-DUSE_BINARIES=ON
		-DUSE_EXAMPLES=$(usex examples)
		-DUSE_HDF5=$(usex hdf5)
		-DUSE_MAYA=$(usex maya)
		-DUSE_PRMAN=$(usex prman)
		-DUSE_PYALEMBIC=$(usex python)
		-DUSE_TESTS=$(usex test)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc; then
		doxygen -u Doxyfile || die
		doxygen Doxyfile || die
	fi
}

src_test() {
	if use test; then
		cmake-utils_src_test
	fi
}

src_install() {
	DESTDIR="${D}" cmake-utils_src_install
	if use doc; then
		dodoc -r "doc/html"
	fi
}

pkg_postinst() {
	if use arnold; then
		einfo "NOTE: The arnold plugin is highly experimental and hasn't been"
		einfo "tested, due to missing license. If you have trouble compiling"
		einfo "or running it, please file a bug report for the package at"
		einfo "gentoo's bugzilla."
	fi
	if use maya; then
		einfo "NOTE: The maya plugin is highly experimental and hasn't been"
		einfo "tested, due to missing license. If you have trouble compiling"
		einfo "or running it, please file a bug report for the package at"
		einfo "gentoo's bugzilla."
	fi
	if use prman; then
		einfo "NOTE: The renderman plugin is still experimental and has not"
		einfo "been tested much. If you have trouble running it, please file"
		einfo "a bug report for the package at gentoo's bugzilla."
		einfo "If you're looking for an ebuild for renderman, you may want to"
		einfo "to try the waebbl overlay: 'eselect repository enable waebbl'"
		einfo "followed by 'emerge renderman'"
	fi
}
