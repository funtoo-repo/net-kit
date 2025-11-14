# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Fuse-filesystem utilizing the sftp service"
HOMEPAGE="https://github.com/libfuse/sshfs"
SRC_URI="https://github.com/libfuse/sshfs/tarball/12d786986f91a7f194791697c8f14b6ca75ff325 -> sshfs-3.7.5-12d7869.tar.gz"

LICENSE="GPL-2"
KEYWORDS="*"
SLOT="0"

DEPEND="sys-fs/fuse
	dev-libs/glib"
RDEPEND="${DEPEND}
	net-misc/openssh"
BDEPEND="dev-python/docutils
	virtual/pkgconfig"

# requires root privs and specific localhost sshd setup
RESTRICT="test"

DOCS=( AUTHORS ChangeLog.rst README.md )

src_unpack() {
	default
	rm -rf ${S}
	mv ${WORKDIR}/libfuse-sshfs-* ${S} || die
}