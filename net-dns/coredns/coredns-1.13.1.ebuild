# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

go-module_set_globals

DESCRIPTION="CoreDNS is a DNS server that chains plugins"
HOMEPAGE="https://coredns.io/ https://github.com/coredns/coredns"
SRC_URI="https://github.com/coredns/coredns/tarball/1db4568df6aaacda6ebbce87717156bd855f8103 -> coredns-1.13.1-1db4568.tar.gz
https://direct-github.funmore.org/42/4a/51/424a51725c70d01253c7ff3fda8502af5783e621e8ee7ba7b0e364ec5716d9d14ea84b360a0099071906e670281727b8636a321e5f8511a4a45cac670e3d0c79 -> coredns-1.13.1-funtoo-go-bundle-aacac665a7c9490d645b460889571035603183d085f84ee17e52dda25aa02407a049093c3386fe49e8d00c186867ef57a087ae03cc43a9b7f90fefc33d503dbf.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.21"
S="${WORKDIR}/coredns-coredns-1db4568"

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