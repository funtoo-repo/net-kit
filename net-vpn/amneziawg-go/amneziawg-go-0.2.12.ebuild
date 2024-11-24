# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="AmneziaWG VPN protocol"
HOMEPAGE="https://github.com/amnezia-vpn/amneziawg-go"
SRC_URI="https://github.com/amnezia-vpn/amneziawg-go/tarball/2e3f7d122ca8ef61e403fddc48a9db8fccd95dbf -> amneziawg-go-0.2.12-2e3f7d1.tar.gz
https://direct-github.funmore.org/a2/06/72/a20672a672554f13249a188b66bf0e84cc9f7e1792c5418402ec017c78e3be3ab108103376b1cdb1dfe44c1cda750bccef9dc6d5cdf4cc852a611dd630707b45 -> amneziawg-go-0.2.12-funtoo-go-bundle-8339e4c2c3f03f5dd55137c8511c86d09d500cedd328fc17ec0984c3fc322d04272aebac6bcb19ab5b3da1a26c998a089dbeaea74733da0476e765bbee33d055.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

post_src_unpack() {
    mv ${WORKDIR}/amnezia-vpn-amneziawg-go-* ${S} || die
}