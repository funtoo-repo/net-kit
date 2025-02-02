# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit flag-o-matic readme.gentoo-r1 user

MY_PV="$(ver_rs 4 -)"
MY_PF="${PN}-${MY_PV}"
DESCRIPTION="Anonymizing overlay network for TCP"
HOMEPAGE="http://www.torproject.org/"
SRC_URI="https://dist.torproject.org/tor-0.4.9.1-alpha.tar.gz -> tor-0.4.9.1-alpha.tar.gz
"
S="${WORKDIR}/${MY_PF}"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="caps libressl lzma scrypt seccomp selinux tor-hardening test zstd"

DEPEND="
	app-text/asciidoc
	dev-libs/libevent[ssl]
	sys-libs/zlib
	caps? ( sys-libs/libcap )
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	libressl? ( dev-libs/libressl:0= )
	lzma? ( app-arch/xz-utils )
	scrypt? ( app-crypt/libscrypt )
	seccomp? ( sys-libs/libseccomp )
	zstd? ( app-arch/zstd )"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-tor )"

DOCS=( README.md ChangeLog ReleaseNotes doc/HACKING )

pkg_setup() {
	enewgroup tor
	enewuser tor -1 -1 /var/lib/tor tor
}

src_configure() {
	export ac_cv_lib_cap_cap_init=$(usex caps)
	econf \
		--localstatedir="${EPREFIX}/var" \
		--enable-system-torrc \
		--enable-asciidoc \
		--disable-android \
		--disable-libfuzzer \
		--disable-module-dirauth \
		--enable-pic \
		--disable-rust \
		--disable-restart-debugging \
		--disable-zstd-advanced-apis  \
		$(use_enable lzma) \
		$(use_enable scrypt libscrypt) \
		$(use_enable seccomp) \
		$(use_enable tor-hardening gcc-hardening) \
		$(use_enable tor-hardening linker-hardening) \
		$(use_enable test unittests) \
		$(use_enable test coverage) \
		$(use_enable zstd)
}

src_install() {
	default
	readme.gentoo_create_doc

	newconfd "${FILESDIR}"/tor.confd tor
	newinitd "${FILESDIR}"/tor.initd-r8 tor

	keepdir /var/lib/tor

	fperms 750 /var/lib/tor
	fowners tor:tor /var/lib/tor

	insinto /etc/tor/
	newins "${FILESDIR}"/torrc-r1 torrc
}