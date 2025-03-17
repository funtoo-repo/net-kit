# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Fuse-filesystem utilizing the sftp service"
HOMEPAGE="https://github.com/libfuse/sshfs"
SRC_URI="https://github.com/libfuse/sshfs/tarball/65b3534051f658872d81a20194f6381f532327e1 -> sshfs-3.7.3-65b3534.tar.gz"

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

DOCS=( AUTHORS ChangeLog.rst README.rst )

src_unpack() {
	default
	rm -rf ${S}
	mv ${WORKDIR}/libfuse-sshfs-* ${S} || die
}