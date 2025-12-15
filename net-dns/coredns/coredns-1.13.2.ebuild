# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

go-module_set_globals

DESCRIPTION="CoreDNS is a DNS server that chains plugins"
HOMEPAGE="https://coredns.io/ https://github.com/coredns/coredns"
SRC_URI="https://github.com/coredns/coredns/tarball/0233f3e7c600b730426628f2cf9c829d404a181f -> coredns-1.13.2-0233f3e.tar.gz
https://direct-github.funmore.org/a0/2f/29/a02f29580dfa683510aa939ab1d82c316e383daee07c1975e4da452a03e8030c18736dd6ca7d73c4872a6b661cae80d15ddc4363161153a5d25805d0555baba3 -> coredns-1.13.2-funtoo-go-bundle-b7894f51a37ef56fec0fdf60ca7d284cf01e4a1153e55511b3cdcdfe3541738b4f7c3a104b02bebaa0b7573aa92f811d1c0a529d9334c3b5f04168258bde57a9.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.21"
S="${WORKDIR}/coredns-coredns-0233f3e"

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