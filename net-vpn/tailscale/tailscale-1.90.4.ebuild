# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module tmpfiles

VERSION_SHORT="1.90.4"
VERSION_LONG="1.90.4-t0d7298602"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/tarball/0d72986024458ffb250def1677a1430beb6b1c8b -> tailscale-1.90.4-0d72986.tar.gz
https://direct-github.funmore.org/e2/e1/c6/e2e1c66de2304a47bef7c8c28829757e4ac6c8bdc5d60938ccb372088b6c8e6e66a0bcbba92375a5092e58bcfc90d202ebedc7319ec9c548da0d6b94f8d0bfeb -> tailscale-1.90.4-funtoo-go-bundle-25c6481383b507fad08b41d133b87ef2e466d58f65e0c3a341e46c32251d8e15dfdd875459e53eec70fb1d64cd098539dea554039134bb94f83e107092c9c348.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

RDEPEND="net-firewall/iptables"
S="${WORKDIR}/tailscale-tailscale-0d72986"

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