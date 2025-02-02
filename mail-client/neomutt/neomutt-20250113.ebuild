# Distributed under the terms of the GNU General Public License v2

EAPI=7

SRC_URI="https://api.github.com/repos/neomutt/neomutt/tarball/20250113 -> neomutt-20250113.tar.gz"
KEYWORDS="*"

DESCRIPTION="A small but very powerful text-based mail client"
HOMEPAGE="https://neomutt.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="autocrypt berkdb doc gdbm gnutls gpgme idn kerberos kyotocabinet libressl
	lmdb nls notmuch pgp-classic qdbm sasl selinux slang smime-classic
	ssl tokyocabinet"
REQUIRED_USE="
	autocrypt? ( gpgme )"

CDEPEND="
	app-misc/mime-types
	berkdb? (
		|| (
			sys-libs/db:6.2
			sys-libs/db:5.3
			sys-libs/db:4.8
		)
		<sys-libs/db-6.3:=
	)
	gdbm? ( sys-libs/gdbm:= )
	kyotocabinet? ( dev-db/kyotocabinet )
	lmdb? ( dev-db/lmdb:= )
	nls? ( virtual/libintl )
	qdbm? ( dev-db/qdbm )
	tokyocabinet? ( dev-db/tokyocabinet )
	gnutls? ( >=net-libs/gnutls-1.0.17:= )
	gpgme? ( >=app-crypt/gpgme-1.13.1:= )
	autocrypt? ( >=dev-db/sqlite-3 )
	idn? ( net-dns/libidn:= )
	kerberos? ( virtual/krb5 )
	notmuch? ( net-mail/notmuch:= )
	sasl? ( >=dev-libs/cyrus-sasl-2 )
	!slang? ( sys-libs/ncurses:0= )
	slang? ( sys-libs/slang )
	ssl? (
		!libressl? ( >=dev-libs/openssl-1.0.2u:0= )
		libressl? ( dev-libs/libressl:= )
	)
"
DEPEND="${CDEPEND}
	dev-lang/tcl:=
	net-mail/mailbase
	doc? (
		dev-libs/libxml2
		dev-libs/libxslt
		app-text/docbook-xsl-stylesheets
		|| (
			www-client/lynx
			www-client/w3m
			www-client/elinks
		)
	)
"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-mutt )
"

src_unpack() {
	default
	rm -rf ${S}
	mv ${WORKDIR}/neomutt-neomutt-* ${S} || die
}


src_configure() {
	local myconf=(
		"$(usex doc --full-doc --disable-doc)"
		"$(use_enable nls)"
		"$(use_enable notmuch)"

		"$(use_enable autocrypt)"
		"$(use_enable gpgme)"
		"$(use_enable pgp-classic pgp)"
		"$(use_enable smime-classic smime)"

		# Database backends.
		"$(use_enable berkdb bdb)"
		"$(use_enable gdbm)"
		"$(use_enable kyotocabinet)"
		"$(use_enable qdbm)"
		"$(use_enable tokyocabinet)"

		"$(use_enable idn)"
		"$(use_enable kerberos gss)"
		"$(use_enable lmdb)"
		"$(use_enable sasl)"
		"--with-ui=$(usex slang slang ncurses)"
		"--sysconfdir=${EPREFIX}/etc/${PN}"
		"$(use_enable ssl)"
		"$(use_enable gnutls)"
		--disable-testing
	)

	econf CCACHE=none "${myconf[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	# A man-page is always handy, so fake one - here neomuttrc.5 (neomutt.1
	# already exists)
	if use !doc; then
		sed -n \
			-e '/^\(CC_FOR_BUILD\|CFLAGS_FOR_BUILD\)\s*=/p' \
			-e '/^\(EXTRA_CFLAGS_FOR_BUILD\|LDFLAGS_FOR_BUILD\)\s*=/p' \
			-e '/^\(EXEEXT\|SRCDIR\)\s*=/p' \
			Makefile > docs/Makefile.fakedoc || die
		sed -n \
			-e '/^MAKEDOC_CPP\s*=/,/^\s*$/p' \
			-e '/^docs\/\(makedoc$(EXEEXT)\|neomutt\.1\|neomuttrc\.5\)\s*:/,/^\s*$/p' \
			docs/Makefile.autosetup >> docs/Makefile.fakedoc || die
		emake -f docs/Makefile.fakedoc docs/neomutt.1
		emake -f docs/Makefile.fakedoc docs/neomuttrc.5
		doman docs/neomutt.1 docs/neomuttrc.5
	fi

	dodoc LICENSE* ChangeLog* README*
}

pkg_postinst() {
	if use gpgme && ( use pgp-classic || use smime-classic ); then
		ewarn "  Note that gpgme (old gpg) includes both pgp and smime"
		ewarn "  support.  You can probably remove pgp-classic (old crypt)"
		ewarn "  and smime-classic (old smime) from your USE-flags and"
		ewarn "  only enable gpgme."
	fi

	if use autocrypt && ! use idn; then
		ewarn "  It is highly recommended that NeoMutt be also configured"
		ewarn "  with idn when autocrypt is enabled."
	fi
}