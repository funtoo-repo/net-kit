# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

go-module_set_globals

DESCRIPTION="CoreDNS is a DNS server that chains plugins"
HOMEPAGE="https://coredns.io/ https://github.com/coredns/coredns"
SRC_URI="https://github.com/coredns/coredns/tarball/463fd1c1b390ef68f638e2f4e09837721b19efba -> coredns-1.12.3-463fd1c.tar.gz
https://direct-github.funmore.org/9a/cd/ff/9acdff276067e19b85e3418e8cc797d723fc95303775332485f3fb3dc85b6b750d0a87ece28ee75949bfe5e9224b7dd1886e8167c8013715009315aeefde3d31 -> coredns-1.12.3-funtoo-go-bundle-6eb082408d3f08c5f613cab4e9d8ce9e8c9ee02c9ef9f5cd7992dd14c21a31de07b409d380e30a9ec29c14701e3c323c172d25db7f97272bb9a76193521496c7.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.21"
S="${WORKDIR}/coredns-coredns-463fd1c"

src_compile() {
	FORCE_HOST_GO=yes
	emake
}

src_install() {
	dobin ${PN}
	insinto /etc/"${PN}"
	doins "${FILESDIR}"/Corefile
	dodoc README.md
	doman man/*

	newinitd "${FILESDIR}"/"${PN}".initd ${PN}
	newconfd "${FILESDIR}"/"${PN}".confd ${PN}
	keepdir /var/log/"${PN}"
}