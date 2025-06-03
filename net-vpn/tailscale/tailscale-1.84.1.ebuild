# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module tmpfiles

VERSION_SHORT="1.84.1"
VERSION_LONG="1.84.1-t1b829929a"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/tarball/1b829929a79c00c264bed731145e0c817e4ca452 -> tailscale-1.84.1-1b82992.tar.gz
https://direct-github.funmore.org/2e/79/bb/2e79bba56c039a160e6813c498f095173d3d592ac44b9fe4c6b3dd348c9706baba4f7cdea8133abcb9de68332ba657d7a7332afe6fbd78675d6c8dd2aab0ae54 -> tailscale-1.84.1-funtoo-go-bundle-19631a433f69bcf534bdeb4ed371c6899a3217a7987ae6b1845181f30ef02f6d71d0496cfc816bc6516a32435453c395563091e34488057a5210bc3134314243.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

RDEPEND="net-firewall/iptables"
S="${WORKDIR}/tailscale-tailscale-1b82992"

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