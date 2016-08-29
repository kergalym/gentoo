# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=utilities/${PN}

inherit ros-catkin

DESCRIPTION="C++ implementation of the XML-RPC protocol"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-ros/cpp_common"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/headers.patch" )

src_configure() {
	ros-catkin_src_configure
	# Hack so that proper -I are added
	sed -e "s#_include_dirs \"include\"#_include_dirs \"include;${EPREFIX}/usr/include/xmlrpcpp\"#" \
		-i "${BUILD_DIR}/catkin_generated/installspace/xmlrpcppConfig.cmake" ||	die

	sed -e "s#/usr/include#/usr/include;${EPREFIX}/usr/include/xmlrpcpp#g" \
		-i "${BUILD_DIR}/catkin_generated/pkg.installspace.context.pc.py" || die

	sed -e "s#/usr/include#/usr/include -I${EPREFIX}/usr/include/xmlrpcpp#g" \
		-i "${BUILD_DIR}/./catkin_generated/installspace/xmlrpcpp.pc" || die
}
