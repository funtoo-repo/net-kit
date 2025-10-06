# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

go-module_set_globals

DESCRIPTION="CoreDNS is a DNS server that chains plugins"
HOMEPAGE="https://coredns.io/ https://github.com/coredns/coredns"
SRC_URI="https://github.com/coredns/coredns/tarball/51f94b0bb4c59996459b98d395fe9f090906abe8 -> coredns-1.13.0-51f94b0.tar.gz
https://direct-github.funmore.org/69/1d/ce/691dced9d221a4ad33273883f8ee12fb77d8bbfcf92d082a0e8d1a63e03caab77c0e4b25ab43014f4eda39f185b1dd4ba02603594a7bdec32b9fa4cd4a25415c -> coredns-1.13.0-funtoo-go-bundle-638114ce0d593ab1fb652d6a27cfffcd730008cef48549b287258e8132198ded987d3c90ba70637d0e84e2fbde4af02547e9cbf0f89f4d7b3d7091cc9a8f45a7.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.21"
S="${WORKDIR}/coredns-coredns-51f94b0"

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