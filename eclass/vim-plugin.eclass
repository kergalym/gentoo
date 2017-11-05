# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: vim-plugin.eclass
# @MAINTAINER:
# vim@gentoo.org
# @BLURB: used for installing vim plugins
# @DESCRIPTION:
# This eclass simplifies installation of app-vim plugins into
# /usr/share/vim/vimfiles.  This is a version-independent directory
# which is read automatically by vim.  The only exception is
# documentation, for which we make a special case via vim-doc.eclass.

inherit estack vim-doc
EXPORT_FUNCTIONS src_install pkg_postinst pkg_postrm

VIM_PLUGIN_VIM_VERSION="${VIM_PLUGIN_VIM_VERSION:-7.3}"

DEPEND="|| ( >=app-editors/vim-${VIM_PLUGIN_VIM_VERSION}
	>=app-editors/gvim-${VIM_PLUGIN_VIM_VERSION} )"
RDEPEND="${DEPEND}"
if [[ ${PV} != 9999* ]] ; then
	SRC_URI="mirror://gentoo/${P}.tar.bz2
		https://dev.gentoo.org/~radhermit/vim/${P}.tar.bz2"
fi
SLOT="0"

# @FUNCTION: vim-plugin_src_install
# @DESCRIPTION:
# Overrides the default src_install phase. In order, this function:
# * fixes file permission across all files in ${S}.
# * installs help and documentation files.
# * installs all files in "${ED}"/usr/share/vim/vimfiles.
vim-plugin_src_install() {
	has "${EAPI:-0}" 0 1 2 && ! use prefix && ED="${D}"
	local f

	# When globbing, if nothing exists, the shell literally returns the glob
	# pattern. So turn on nullglob and extglob options to avoid this.
	eshopts_push -s extglob
	eshopts_push -s nullglob

	ebegin "Cleaning up unwanted files and directories"
	# We're looking for dotfiles, dotdirectories and Makefiles here.
	local obj
	eval "local matches=(@(.[^.]|.??*|Makefile*))"
	for obj in "${matches[@]}"; do
		rm -rv "${obj}" || die "cannot remove ${obj}"
	done
	eend $?

	# Turn those options back off.
	eshopts_pop
	eshopts_pop

	# Install non-vim-help-docs
	cd "${S}" || die "couldn't cd in ${S}"
	local f
	for f in *; do
		[[ -f "${f}" ]] || continue
		if [[ "${f}" = *.html ]]; then
			dohtml "${f}"
		else
			dodoc "${f}"
		fi
		rm "${f}" || die
	done

	# Install remainder of plugin
	cd "${WORKDIR}" || die "couldn't cd in ${WORKDIR}"
	dodir /usr/share/vim
	mv "${S}" "${ED}"/usr/share/vim/vimfiles || die \
		"couldn't move ${S} to ${ED}/usr/share/vim/vimfiles"

	# Set permissions
	fperms -R a+rX /usr/share/vim/vimfiles
}

# @FUNCTION: vim-plugin_pkg_postinst
# @DESCRIPTION:
# Overrides the pkg_postinst phase for this eclass.
# The following functions are called:
# * update_vim_helptags
# * update_vim_afterscripts
# * display_vim_plugin_help
vim-plugin_pkg_postinst() {
	update_vim_helptags		# from vim-doc
	update_vim_afterscripts	# see below
	display_vim_plugin_help	# see below
}

# @FUNCTION: vim-plugin_pkg_postrm
# @DESCRIPTION:
# Overrides the pkg_postrm phase for this eclass.
# This function calls the update_vim_helptags and update_vim_afterscripts
# functions and eventually removes a bunch of empty directories.
vim-plugin_pkg_postrm() {
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=
	update_vim_helptags		# from vim-doc
	update_vim_afterscripts	# see below

	# Remove empty dirs; this allows
	# /usr/share/vim to be removed if vim-core is unmerged
	find "${EPREFIX}/usr/share/vim/vimfiles" -depth -type d -exec rmdir {} \; 2>/dev/null || \
		die "rmdir failed"
}

# @FUNCTION: update_vim_afterscripts
# @DESCRIPTION:
# Creates scripts in /usr/share/vim/vimfiles/after/*
# comprised of the snippets in /usr/share/vim/vimfiles/after/*/*.d
update_vim_afterscripts() {
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EROOT="${ROOT}"
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=
	local d f afterdir="${EROOT}"/usr/share/vim/vimfiles/after

	# Nothing to do if the dir isn't there
	[ -d "${afterdir}" ] || return 0

	einfo "Updating scripts in ${EPREFIX}/usr/share/vim/vimfiles/after"
	find "${afterdir}" -type d -name \*.vim.d | while read d; do
		echo '" Generated by update_vim_afterscripts' > "${d%.d}" || die
		find "${d}" -name \*.vim -type f -maxdepth 1 -print0 | sort -z | \
			xargs -0 cat >> "${d%.d}" || die "update_vim_afterscripts failed"
	done

	einfo "Removing dead scripts in ${EPREFIX}/usr/share/vim/vimfiles/after"
	find "${afterdir}" -type f -name \*.vim | \
	while read f; do
		[[ "$(head -n 1 ${f})" == '" Generated by update_vim_afterscripts' ]] \
			|| continue
		# This is a generated file, but might be abandoned.  Check
		# if there's no corresponding .d directory, or if the
		# file's effectively empty
		if [[ ! -d "${f}.d" || -z "$(grep -v '^"' "${f}")" ]]; then
			rm "${f}" || die
		fi
	done
}

# @FUNCTION: display_vim_plugin_help
# @DESCRIPTION:
# Displays a message with the plugin's help file if one is available. Uses the
# VIM_PLUGIN_HELPFILES env var. If multiple help files are available, they
# should be separated by spaces. If no help files are available, but the env
# var VIM_PLUGIN_HELPTEXT is set, that is displayed instead. Finally, if we
# have nothing else, this functions displays a link to VIM_PLUGIN_HELPURI. An
# extra message regarding enabling filetype plugins is displayed if
# VIM_PLUGIN_MESSAGES includes the word "filetype".
display_vim_plugin_help() {
	local h

	if ! has_version ${CATEGORY}/${PN} ; then
		if [[ -n "${VIM_PLUGIN_HELPFILES}" ]] ; then
			elog " "
			elog "This plugin provides documentation via vim's help system. To"
			elog "view it, use:"
			for h in ${VIM_PLUGIN_HELPFILES} ; do
				elog "    :help ${h}"
			done
			elog " "

		elif [[ -n "${VIM_PLUGIN_HELPTEXT}" ]] ; then
			elog " "
			while read h ; do
				elog "$h"
			done <<<"${VIM_PLUGIN_HELPTEXT}"
			elog " "

		elif [[ -n "${VIM_PLUGIN_HELPURI}" ]] ; then
			elog " "
			elog "Documentation for this plugin is available online at:"
			elog "    ${VIM_PLUGIN_HELPURI}"
			elog " "
		fi

		if has "filetype" "${VIM_PLUGIN_MESSAGES}" ; then
			elog "This plugin makes use of filetype settings. To enable these,"
			elog "add lines like:"
			elog "    filetype plugin on"
			elog "    filetype indent on"
			elog "to your ~/.vimrc file."
			elog " "
		fi
	fi
}
