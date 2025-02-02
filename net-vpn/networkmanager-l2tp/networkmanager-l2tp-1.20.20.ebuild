# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="NetworkManager-l2tp"
MY_P="${MY_PN}-${PV}"

inherit eutils gnome.org autotools

DESCRIPTION="NetworkManager L2TP plugin"
HOMEPAGE="https://github.com/nm-l2tp/network-manager-l2tp"
SRC_URI="https://api.github.com/repos/nm-l2tp/NetworkManager-l2tp/tarball/1.20.20 -> networkmanager-l2tp-1.20.20.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="gnome static-libs"

RDEPEND="
	>=net-misc/networkmanager-1.8[ppp]
	dev-libs/dbus-glib
	net-dialup/ppp[eap-tls]
	net-dialup/xl2tpd
	>=dev-libs/glib-2.32
	|| (
		net-vpn/strongswan
		net-vpn/libreswan
	)
	gnome? (
		>=x11-libs/gtk+-3.14:3
		>=app-crypt/libsecret-0.18
		>=net-libs/libnma-1.8.0
	)"

BDEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack "${A}"
	mv ${WORKDIR}/nm-l2tp-NetworkManager* $S || die
}

src_prepare() {
	eautoreconf
	eapply_user
}

src_configure() {
	local myeconfargs=(
		--localstatedir=/var
		$(use_with gnome)
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}