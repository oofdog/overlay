# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 gnome2-utils xdg-utils qmake-utils

HOMEPAGE="https://github.com/uglide/RedisDesktopManager"
DESCRIPTION="Redis Desktop Manager"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="X"

EGIT_REPO_URI="https://github.com/uglide/RedisDesktopManager.git"
EGIT_COMMIT="${PV}"

ECONF_SOURCE="src"

RDEPEND="
        dev-qt/qtconcurrent:5
        dev-qt/qtcore:5
        dev-qt/qtcharts:5
        dev-qt/qtgui:5[gif,jpeg,png,xcb]
        dev-qt/qtnetwork:5
        dev-qt/qtopengl:5
        dev-qt/qtsql:5
        dev-qt/qtsvg:5
        dev-qt/qtquickcontrols2:5
        dev-qt/qtwidgets:5
        dev-qt/qtxml:5
        sys-libs/zlib
        X? ( x11-libs/libX11 x11-libs/libXScrnSaver )"
DEPEND="${RDEPEND}"

src_prepare() {
  eapply_user
}

src_configure() {
  if [[ -x ${ECONF_SOURCE:-.}/configure ]] ; then
    econf
  fi
}

src_compile() {
  eqmake5 src/${PN}.pro
  emake
}

src_install() {
  emake INSTALL_ROOT="${D}" install

  cp bin/linux/release/rdm "${D}/opt/redis-desktop-manager/rdm"
  chmod 0755 "${D}/opt/redis-desktop-manager/rdm.sh"

  mv "${D}/opt/redis-desktop-manager/qt.conf" "${D}/opt/redis-desktop-manager/qt.conf.backup"
}

pkg_postinst() {
  gnome2_icon_cache_update
  xdg_desktop_database_update
}

pkg_postrm() {
  gnome2_icon_cache_update
  xdg_desktop_database_update
}
