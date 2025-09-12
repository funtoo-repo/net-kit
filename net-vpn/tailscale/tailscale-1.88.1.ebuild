# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module tmpfiles

VERSION_SHORT="1.88.1"
VERSION_LONG="1.88.1-t032962f4b"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/tarball/032962f4bc982fe8b6b58df01c33cf2904d07d67 -> tailscale-1.88.1-032962f.tar.gz
https://direct-github.funmore.org/7b/c0/73/7bc0733f72333e8feebd382f7036685beac6fa3c520540720ef49690fbd93285bd63a8b0fb5808a83e81fb75907f4477c301836baa5610ef93a6db6231abe418 -> tailscale-1.88.1-funtoo-go-bundle-2a48bf911192069affefe6475ce2c385603489d6fa9b3cfb923bb39cf925ae77f7072cc8daa9298c0b923064ec0fec31d3b409c8cba73325c5b698bd1c0ee8d4.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

RDEPEND="net-firewall/iptables"
S="${WORKDIR}/tailscale-tailscale-032962f"

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