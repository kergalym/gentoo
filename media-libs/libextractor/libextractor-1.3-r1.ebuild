# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Library to extract metadata from files of arbitrary type"
HOMEPAGE="https://www.gnu.org/software/libextractor/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE="+archive +bzip2 ffmpeg flac gif gsf gtk jpeg +magic midi mp4 mpeg tidy tiff vorbis +zlib" # test

RESTRICT="test"

COMMON_DEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2
	media-gfx/exiv2:=
	sys-devel/libtool
	virtual/libiconv
	virtual/libintl
	archive? ( app-arch/libarchive:= )
	bzip2? ( app-arch/bzip2 )
	ffmpeg? ( virtual/ffmpeg )
	flac? (
		media-libs/flac
		media-libs/libogg
	)
	gif? ( media-libs/giflib:= )
	gsf? ( gnome-extra/libgsf:= )
	gtk? ( x11-libs/gtk+:3 )
	jpeg? ( virtual/jpeg:0 )
	magic? ( sys-apps/file )
	midi? ( media-libs/libsmf )
	mp4? ( media-libs/libmp4v2:0 )
	mpeg? ( media-libs/libmpeg2 )
	tidy? ( app-text/htmltidy )
	tiff? ( media-libs/tiff:0 )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	zlib? ( sys-libs/zlib )
"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	virtual/pkgconfig"
# test? ( app-forensics/zzuf )
RDEPEND="${COMMON_DEPEND}
	!sci-biology/glimmer
	!sci-chemistry/pdb-extract
"

PATCHES=(
	"${FILESDIR}"/${P}-giflib-5.patch #571902
	"${FILESDIR}"/${P}-ffmpeg-2.9.patch
	"${FILESDIR}"/${P}-exiv2-0.26.patch #621242
)

src_prepare() {
	default

	# m4/ax_create_pkgconfig_info.m4 is passing environment LDFLAGS to Libs:
	sed -i \
		-e '/^ax_create_pkgconfig_ldflags=/s:$LDFLAGS ::' \
		-e 's:tidy/tidy.h:tidy.h:' \
		-e 's:tidy/buffio.h:buffio.h:' \
		configure src/plugins/html_extractor.c || die

	if ! use tidy; then
		sed -i -e 's:tidy.h:dIsAbLe&:' configure || die
	fi
}

src_configure() {
	e_ac_cv() {
		export ac_cv_"$@"
	}

	e_ac_cv {lib_rpm_rpmReadPackageFile,prog_HAVE_ZZUF}=no

	e_ac_cv header_FLAC_all_h=$(usex flac)
	e_ac_cv lib_FLAC_FLAC__stream_decoder_init_stream=$(usex flac)
	e_ac_cv lib_FLAC_FLAC__stream_decoder_init_ogg_stream=$(usex flac)

	e_ac_cv header_archive_h=$(usex archive)
	e_ac_cv header_bzlib_h=$(usex bzip2)
	e_ac_cv header_gif_lib_h=$(usex gif)
	e_ac_cv header_jpeglib_h=$(usex jpeg)
	e_ac_cv header_magic_h=$(usex magic)
	e_ac_cv header_mpeg2dec_mpeg2_h=$(usex mpeg)
	e_ac_cv header_tiffio_h=$(usex tiff)
	e_ac_cv header_vorbis_vorbisfile_h=$(usex vorbis)
	e_ac_cv header_zlib_h=$(usex zlib)
	e_ac_cv lib_mp4v2_MP4ReadProvider=$(usex mp4)
	e_ac_cv lib_smf_smf_load_from_memory=$(usex midi)

	# gstreamer support is for 1.0, no 0.10 support
	econf \
		--disable-static \
		--enable-experimental \
		--enable-glib \
		--with-gtk_version=$(usex gtk 3.0.0 false) \
		--without-gstreamer \
		--disable-gsf-gnome \
		$(use_enable gsf) \
		$(use_enable ffmpeg)
}

src_install() {
	default

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
