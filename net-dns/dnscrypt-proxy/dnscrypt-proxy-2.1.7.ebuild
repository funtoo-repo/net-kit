# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/DNSCrypt/${PN}"

inherit fcaps go-module user

DESCRIPTION="A flexible DNS proxy, with support for encrypted DNS protocols"
HOMEPAGE="https://github.com/DNSCrypt/dnscrypt-proxy"
SRC_URI="https://api.github.com/repos/DNSCrypt/dnscrypt-proxy/tarball/2.1.7 -> dnscrypt-proxy-2.1.7.tar.gz"

KEYWORDS="*"
LICENSE="Apache-2.0 BSD ISC MIT MPL-2.0"
SLOT="0"
IUSE="pie"

DEPEND=">=dev-lang/go-1.13"

FILECAPS=( cap_net_bind_service+ep usr/bin/dnscrypt-proxy )

pkg_setup() {
	enewgroup dnscrypt-proxy
	enewuser dnscrypt-proxy -1 -1 /dev/null dnscrypt-proxy
}

src_unpack() {
	unpack "${A}"
	mv "${WORKDIR}/DNSCrypt-${PN}"-* "${S}" || die
}

src_prepare() {
	default

	# fix paths of log and cache files
	sed -i \
		-e "s# file *= *'\(.\+.log\)'# file = '/var/log/dnscrypt-proxy/\1'#" \
		-e "s#log_file *= *'\(.\+.log\)'#log_file = '/var/log/dnscrypt-proxy/\1'#" \
		-e "s#cache_file *= *'\(.\+.md\)'#cache_file = '/var/cache/dnscrypt-proxy/\1'#" \
		${S}/dnscrypt-proxy/example-dnscrypt-proxy.toml || die
}

src_compile() {
	pushd "${PN}" >/dev/null || die
	go build -v -x -mod=readonly -mod=vendor -buildmode="$(usex pie pie default)" || die
	popd >/dev/null || die
}

src_test() {
	cd "${PN}" || die
	go test -mod=vendor -buildmode="$(usex pie pie default)" || die "Failed to run tests"
}

src_install() {
	pushd "${PN}" >/dev/null || die

	dobin dnscrypt-proxy

	insinto /etc/dnscrypt-proxy
	newins example-dnscrypt-proxy.toml dnscrypt-proxy.toml
	doins example-*.txt

	popd >/dev/null || die

	insinto /usr/share/dnscrypt-proxy
	doins -r "utils/generate-domains-blocklist/."

	newinitd "${FILESDIR}"/dnscrypt-proxy.initd dnscrypt-proxy
	newconfd "${FILESDIR}"/dnscrypt-proxy.confd dnscrypt-proxy

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/dnscrypt-proxy.logrotate dnscrypt-proxy

	einstalldocs
}

pkg_postinst() {
	fcaps_pkg_postinst
	go-module_pkg_postinst

	if ! use filecaps; then
		ewarn "'filecaps' USE flag is disabled"
		ewarn "${PN} will fail to listen on port 53"
		ewarn "please do one the following:"
		ewarn "1) re-enable 'filecaps'"
		ewarn "2) change port to > 1024"
		ewarn "3) configure to run ${PN} as root (not recommended)"
		ewarn
	fi

	elog "After starting the service you will need to update your"
	elog "/etc/resolv.conf and replace your current set of resolvers"
	elog "with:"
	elog
	elog "nameserver 127.0.0.1"
	elog
	elog "Also see https://github.com/DNSCrypt/${PN}/wiki"
}