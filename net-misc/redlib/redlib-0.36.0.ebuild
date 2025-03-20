# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION=" Private front-end for Reddit "
HOMEPAGE="https://github.com/redlib-org/redlib"
SRC_URI="https://github.com/redlib-org/redlib/tarball/15147cea8e42f6569a11603d661d71122f6a02dc -> redlib-0.36.0-15147ce.tar.gz
https://direct-github.funmore.org/6f/77/b5/6f77b503dede975b90670584f749e2300f64879c222df36380b596e245a165b1de8c3d2720c817b8f7b408c5d93e7833f95340b5a28961da3164f6ba4b758eee -> redlib-0.36.0-funtoo-crates-bundle-f21431ffcb2ea2828869cfa4f5621e477edec9c2a417aaba5f202ccc04f0c7ef0b37bd8bb85ba84dfb12652687eece33609d43b0159774e9ec5277b49557a737.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="*"

DOCS=( README.md )

QA_FLAGS_IGNORED="/usr/bin/redlib"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/redlib-org-redlib-* ${S} || die
}