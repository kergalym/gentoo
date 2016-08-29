# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem versionator

DESCRIPTION="Generic Patch Finder"
HOMEPAGE="https://github.com/wchen-r7/patch-finder"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

IUSE=""
