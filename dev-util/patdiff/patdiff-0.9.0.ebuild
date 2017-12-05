# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Colored patience diffs with word-level refinement"
HOMEPAGE="https://github.com/janestreet/patdiff"
SRC_URI="https://github.com/janestreet/patdiff/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-lang/ocaml:=
	dev-ml/core:=
	dev-ml/core_extended:=
	dev-ml/patience_diff:=
	dev-ml/ppx_driver:=
	dev-ml/ppx_jane:=
	dev-ml/re2:=
	dev-ml/sexplib:=
	dev-ml/ocaml-migrate-parsetree:=
	dev-ml/pcre-ocaml:=
"
DEPEND="${RDEPEND} dev-ml/opam dev-ml/jbuilder"

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		--mandir="${ED}/usr/share/man" \
		${PN}.install || die
}
