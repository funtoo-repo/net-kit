# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Desktop Syncing Client for Nextcloud"
HOMEPAGE="https://github.com/nextcloud/desktop"
SRC_URI="https://api.github.com/repos/nextcloud/desktop/tarball/v3.15.3 -> nextcloud-desktop-3.15.3.tar.gz"

LICENSE="CC-BY-3.0 GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="doc dolphin nautilus test webengine"
RESTRICT="!test? ( test )"

COMMON_DEPEND=">=dev-db/sqlite-3.8:3
	>=dev-libs/openssl-1.1.0:0=
	dev-libs/qtkeychain[qt5(+)]
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtquickcontrols2:5
	dev-qt/qtsvg:5
	dev-qt/qtwebsockets:5
	dev-qt/qtwidgets:5
	kde-frameworks/karchive
	sys-libs/zlib
	dolphin? (
		kde-frameworks/kcoreaddons:5
		kde-frameworks/kio:5
	)
	nautilus? ( dev-python/nautilus-python )
	webengine? ( dev-qt/qtwebengine:5[widgets] )"

DEPEND="${COMMON_DEPEND}
	dev-qt/linguist-tools:5
	dev-qt/qtconcurrent:5
	dev-qt/qtxml:5
	gnome-base/librsvg
	doc? (
		dev-python/sphinx
		dev-tex/latexmk
		dev-texlive/texlive-latexextra
		virtual/latex-base
	)
	dolphin? ( kde-frameworks/extra-cmake-modules )
	test? (
		dev-util/cmocka
		dev-qt/qttest:5
	)"

RDEPEND="${COMMON_DEPEND}"

post_src_unpack() {
	mv ${WORKDIR}/nextcloud* ${S} || die
}

src_prepare() {
	# Keep tests in ${T}
	sed -i -e "s#\"/tmp#\"${T}#g" test/test*.cpp || die
	# FL-9136: only use rsvg-convert, not inkscape:
	sed -i -e 's/NAMES.*rsvg-convert/NAMES rsvg-convert/g' src/gui/CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSYSCONF_INSTALL_DIR="${EPREFIX}"/etc
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DBUILD_UPDATER=OFF
		$(cmake_use_find_package doc Sphinx)
		$(cmake_use_find_package doc PdfLatex)
		$(cmake_use_find_package webengine Qt5WebEngine)
		$(cmake_use_find_package webengine Qt5WebEngineWidgets)
		-DBUILD_SHELL_INTEGRATION_DOLPHIN=$(usex dolphin)
		-DBUILD_SHELL_INTEGRATION_NAUTILUS=$(usex nautilus)
		-DUNIT_TESTING=$(usex test)
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	if ! use doc ; then
		elog "Documentation and man pages not installed"
		elog "Enable doc USE-flag to generate them"
	fi
}