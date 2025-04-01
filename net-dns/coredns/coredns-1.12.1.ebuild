# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

go-module_set_globals

DESCRIPTION="CoreDNS is a DNS server that chains plugins"
HOMEPAGE="https://coredns.io/ https://github.com/coredns/coredns"
SRC_URI="https://github.com/coredns/coredns/tarball/707c7c10acd52cb94e959e76ae233d9b76af0854 -> coredns-1.12.1-707c7c1.tar.gz
https://direct-github.funmore.org/9f/65/85/9f6585579ecb8bebf0d105e102937dab1d665c7da27b433d4007c85c5a4af0a754a9dcfe54215bfce16457dd81dc40cd817dc362c74cec2f911fabf677a27ae3 -> coredns-1.12.1-funtoo-go-bundle-561bcf7b9702778b4b25007f0e5dd49bbd0d3d38a156adf1c81439882cbc4fc8ac82f3032f6d8f6ec692923c053991abbbf43a5fa21af4aef305b886fc3dec27.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.21"
S="${WORKDIR}/coredns-coredns-707c7c1"

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