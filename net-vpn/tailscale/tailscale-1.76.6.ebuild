# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module tmpfiles

VERSION_SHORT="1.76.6"
VERSION_LONG="1.76.6-t439305eee"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/tarball/439305eeeda64a1851e8b775724ff1fbbd713207 -> tailscale-1.76.6-439305e.tar.gz
https://direct-github.funmore.org/c3/31/38/c3313829a9a63e1b442fa1c3a0504f04b9b5d6166a058ef9ab7f5b8dc081816cd856acd45ce9bbddf857a43f079cf13c88963ec32b2bcd77b38e3f36fa95cf4d -> tailscale-1.76.6-funtoo-go-bundle-9db89d219a3d7150d5bf7fac651c8bb1c1bf27b7bbc3ec87864f4e9114eb98f304e6529b5c0522db728492a571bd647aa4519b7144cfb6f57dea652d8ef05d69.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

RDEPEND="net-firewall/iptables"
S="${WORKDIR}/tailscale-tailscale-439305e"

# This translates the build command from upstream's build_dist.sh to an
# ebuild equivalent.
build_dist() {
	go build -tags xversion -ldflags "
		-X tailscale.com/version.longStamp=${VERSION_LONG}
		-X tailscale.com/version.shortStamp=${VERSION_SHORT}" "$@"
}

src_compile() {
	build_dist ./cmd/tailscale
	build_dist ./cmd/tailscaled
}

src_install() {
	dosbin tailscaled
	dobin tailscale

	insinto /etc/default
	newins cmd/tailscaled/tailscaled.defaults tailscaled
	keepdir /var/lib/${PN}
	fperms 0750 /var/lib/${PN}

	newtmpfiles "${FILESDIR}/${PN}.tmpfiles" ${PN}.conf

	newinitd "${FILESDIR}/${PN}d.initd" ${PN}
	newconfd "${FILESDIR}/${PN}d.confd" ${PN}
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf
}