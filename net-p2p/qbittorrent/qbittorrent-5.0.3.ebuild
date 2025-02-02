# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake multibuild systemd xdg

DESCRIPTION="BitTorrent client in C++ and Qt"
HOMEPAGE="https://www.qbittorrent.org
	  https://github.com/qbittorrent"

SRC_URI="https://github.com/qbittorrent/qBittorrent/tarball/0188e11dd7ece1ee8b6004145c4437d7455745d4 -> qBittorrent-5.0.3-0188e11.tar.gz"
KEYWORDS="*"

LICENSE="GPL-2"
SLOT="0"
IUSE="+dbus +gui webui"
REQUIRED_USE="dbus? ( gui )
	|| ( gui webui )"

RDEPEND="
	dev-libs/boost:=
	dev-libs/openssl:=
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5
	dev-qt/qtxml:5
	net-libs/libtorrent-rasterbar:=
	sys-libs/zlib
	dbus? ( dev-qt/qtdbus:5 )
	gui? (
		dev-libs/geoip
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
	)"

DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools:5
	virtual/pkgconfig"

DOCS=( AUTHORS Changelog CONTRIBUTING.md README.md )

post_src_unpack() {
	mv ${WORKDIR}/qbittorrent-qBittorrent* "${S}" || die
}

src_prepare() {
	MULTIBUILD_VARIANTS=( base )
	use webui && MULTIBUILD_VARIANTS+=( webui )

	cmake_src_prepare
}

src_configure() {
	multibuild_src_configure() {
		local mycmakeargs=(
			-DDBUS=$(usex dbus)

			# musl lacks execinfo.h
			-DSTACKTRACE=$(usex !elibc_musl)

			-DSYSTEMD=OFF

			# More verbose build logs are preferable for bug reports
			-DVERBOSE_CONFIGURE=ON

			# Not yet in Funtoo
			-DQT6=OFF

			# We do these in multibuild, see bug #839531 for why.
			# Fedora has to do the same thing.
			-DGUI=$(usex gui)
		)

		if [[ ${MULTIBUILD_VARIANT} == webui ]] ; then
			mycmakeargs+=(
				-DGUI=OFF
				-DWEBUI=ON
			)
		else
			mycmakeargs+=( -DWEBUI=OFF )
		fi

		cmake_src_configure
	}

	multibuild_foreach_variant multibuild_src_configure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_install() {
	multibuild_foreach_variant cmake_src_install

	if ! use webui ; then
		# No || die deliberately as it doesn't always exist
		rm "${D}/$(systemd_get_systemunitdir)"/qbittorrent-nox*.service
	fi

	einstalldocs
}