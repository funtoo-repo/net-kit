# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="bind a local port and connect it to a remote socket"
HOMEPAGE="http://http.distributed.net/pub/dcti/unsupported/"
SRC_URI="ftp://ftp.distributed.net/pub/dcti/unsupported/${P}.tar.gz http://http.distributed.net/pub/dcti/unsupported/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~x86 ~ppc ~arm ~amd64"

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o datapipe datapipe.c
}

src_install() {
	einstalldocs
	dobin datapipe
	dodoc datapipe.txt
}
