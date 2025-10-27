# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module tmpfiles

VERSION_SHORT="1.90.2"
VERSION_LONG="1.90.2-tefbd11a95"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/tarball/efbd11a951c46499f4626add59381184234ffa69 -> tailscale-1.90.2-efbd11a.tar.gz
https://direct-github.funmore.org/c3/55/b9/c355b960a242bcffcf7bc3d8a6081183ff3b742c6b5472a833044e3896ad314a01f8ab43853522f5e90954ca525c6f261529293af2945aafedb17ba3fd14abf0 -> tailscale-1.90.2-funtoo-go-bundle-25c6481383b507fad08b41d133b87ef2e466d58f65e0c3a341e46c32251d8e15dfdd875459e53eec70fb1d64cd098539dea554039134bb94f83e107092c9c348.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

RDEPEND="net-firewall/iptables"
S="${WORKDIR}/tailscale-tailscale-efbd11a"

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