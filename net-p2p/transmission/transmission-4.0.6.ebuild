# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake user xdg-utils

DESCRIPTION="A fast, easy, and free BitTorrent client"
HOMEPAGE="https://transmissionbt.com/"
SRC_URI="https://direct-github.funmore.org/79/42/e1/7942e1a9299ef61a447cd54dfbcb89dfbfbc55214eed15e4c5d685230254b4310c30e65da3cc71a43534a4dcb80ef693c931bad89c8db66ea3aae4b859b72e3d -> transmission-4.0.6-with-submodules.tar.xz"

# web/LICENSE is always GPL-2 whereas COPYING allows either GPL-2 or GPL-3 for the rest
# transmission in licenses/ is for mentioning OpenSSL linking exception
# MIT is in several libtransmission/ headers
LICENSE="|| ( GPL-2 GPL-3 Transmission-OpenSSL-exception ) GPL-2 MIT"
SLOT="0"
KEYWORDS="*"
IUSE="ayatana gtk libressl cli nls mbedtls qt5 test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	nls? (
		gtk? ( sys-devel/gettext )
		qt5? ( dev-qt/linguist-tools:5 )
	)
"

RDEPEND="
	dev-libs/libb64:0=
	>=dev-libs/libevent-2.1.0:=
	!mbedtls? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	mbedtls? ( net-libs/mbedtls:0= )
	>=net-misc/curl-7.16.3[ssl]
	sys-libs/zlib:=
	nls? ( virtual/libintl )
	gtk? (
		>=dev-cpp/gtkmm-3.24.0:3.0
		>=dev-cpp/glibmm-2.60.0:2
		ayatana? ( >=dev-libs/libappindicator-0.4.30:3 )
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtnetwork:5
		dev-qt/qtdbus:5
		dev-qt/qtsvg:5
	)
"
DEPEND="${RDEPEND}
	nls? ( virtual/libintl )"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR=share/doc/${PF}

		-DENABLE_GTK=$(usex gtk ON OFF)
		-DENABLE_MAC=OFF
		-DENABLE_WEB=OFF
		-DENABLE_CLI=$(usex cli ON OFF)
		-DENABLE_NLS=$(usex nls ON OFF)
		-DENABLE_QT=$(usex qt5 ON OFF)
		-DENABLE_TESTS=$(usex test ON OFF)

		-DUSE_GTK_VERSION=3
		-DUSE_SYSTEM_EVENT2=OFF
		-DUSE_SYSTEM_DEFLATE=OFF
		-DUSE_SYSTEM_DHT=OFF
		-DUSE_SYSTEM_MINIUPNPC=OFF
		-DUSE_SYSTEM_NATPMP=OFF
		-DUSE_SYSTEM_UTP=OFF
		-DUSE_SYSTEM_B64=OFF
		-DUSE_SYSTEM_PSL=OFF

		-DWITH_CRYPTO=$(usex mbedtls polarssl openssl)
		-DWITH_INOTIFY=ON
		-DWITH_APPINDICATOR=$(usex ayatana ON OFF)
		-DWITH_SYSTEMD=OFF
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}"/transmission-daemon.initd.10 transmission-daemon
	newconfd "${FILESDIR}"/transmission-daemon.confd.4 transmission-daemon

	insinto /usr/lib/sysctl.d
	doins "${FILESDIR}"/60-transmission.conf
}

pkg_postinst() {
	if use gtk || use qt5; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi

	enewgroup transmission
	enewuser transmission -1 -1 /var/lib/transmission transmission

	if [[ ! -e "${EROOT%/}"/var/lib/transmission ]]; then
		mkdir -p "${EROOT%/}"/var/lib/transmission || die
		chown transmission:transmission "${EROOT%/}"/var/lib/transmission || die
    fi
}

pkg_postrm() {
	if use gtk || use qt5; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}

# vim: ts=4 sw=4 noet