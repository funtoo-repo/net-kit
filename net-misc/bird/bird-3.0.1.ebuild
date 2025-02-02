# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A routing daemon implementing OSPF, RIPv2 & BGP for IPv4 & IPv6"
HOMEPAGE="http://bird.network.cz"
SRC_URI="https://github.com/CZ-NIC/bird/tarball/77582da162d19af1073cbe56c7884b7e758b6a7a -> bird-3.0.1-77582da.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="*"
IUSE="+client debug"

S="${WORKDIR}/CZ-NIC-bird-77582da"

RDEPEND="client? ( sys-libs/ncurses )
	client? ( sys-libs/readline )"
DEPEND="sys-devel/flex
	sys-devel/bison
	sys-devel/m4"

src_prepare() {
    default
    eautoreconf
}

src_configure() {
	econf \
		--localstatedir="${EPREFIX}/var" \
		$(use_enable client) \
		$(use_enable debug)
}

src_install() {
	if use client; then
		dobin birdc
	fi
	dobin birdcl
	dosbin bird
	newinitd "${FILESDIR}/initd-${PN}-2" bird
	dodoc doc/bird.conf.example
}
