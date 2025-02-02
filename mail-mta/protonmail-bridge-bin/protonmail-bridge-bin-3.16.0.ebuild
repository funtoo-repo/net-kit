# Distributed under the terms of the GNU General Public License v2
 
EAPI=7

inherit rpm xdg
 
DESCRIPTION="The Bridge is an application that runs on your computer in the background and seamlessly encrypts and decrypts your mail as it enters and leaves your computer."
HOMEPAGE="https://protonmail.com/bridge/"
SRC_URI="https://proton.me/download/bridge/protonmail-bridge-3.16.0-1.x86_64.rpm -> protonmail-bridge-bin-3.16.0.rpm"
 
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="mysql odbc postgres"
 
DEPEND=""
RDEPEND="${DEPEND}
	media-libs/libglvnd
	app-crypt/libsecret
	sys-libs/glibc
	dev-libs/glib
	media-fonts/dejavu
	mysql? ( virtual/mysql )
	odbc? ( dev-db/libiodbc )
	postgres? ( dev-db/postgresql )
	x11-libs/xcb-util
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-renderutil
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-image
	x11-libs/libxkbcommon
"
# FL-12208: all these x11-libs/... needed for @preserved-rebuild

# This app depends on Qt6 at this time.  Please re-add these runtime dependencies when that is out
#	dev-qt/qtcore
#	dev-qt/qtdeclarative
#	dev-qt/qtmultimedia
#	dev-qt/qtsvg
#	dev-qt/qtquickcontrols
#	dev-qt/qtquickcontrols2

BDEPEND=""

S=${WORKDIR}/usr

src_install() {
	cp -pRP ${S} "${D}"

	# remove hanging shared object links
	destlibdir="${D}"/usr/lib/protonmail/bridge
	rm ${destlibdir}/plugins/designer/libqquickwidget.so
	rm ${destlibdir}/qml/Qt/labs/animation/liblabsanimationplugin.so
	rm ${destlibdir}/qml/Qt/labs/folderlistmodel/libqmlfolderlistmodelplugin.so
	rm ${destlibdir}/qml/Qt/labs/qmlmodels/liblabsmodelsplugin.so
	rm ${destlibdir}/qml/Qt/labs/settings/libqmlsettingsplugin.so
	rm ${destlibdir}/qml/Qt/labs/sharedimage/libsharedimageplugin.so
	rm ${destlibdir}/qml/Qt/labs/wavefrontmesh/libqmlwavefrontmeshplugin.so
	rm ${destlibdir}/qml/QtQml/XmlListModel/libqmlxmllistmodelplugin.so
	rm ${destlibdir}/qml/QtQuick/LocalStorage/libqmllocalstorageplugin.so
	rm ${destlibdir}/qml/QtQuick/Particles/libparticlesplugin.so
	rm ${destlibdir}/qml/QtQuick/Shapes/libqmlshapesplugin.so
	rm ${destlibdir}/qml/QtTest/libquicktestplugin.so

	use mysql || rm ${destlibdir}/plugins/sqldrivers/libqsqlmysql.so
	use postgres || rm ${destlibdir}/plugins/sqldrivers/libqsqlpsql.so
	use odbc || rm ${destlibdir}/plugins/sqldrivers/libqsqlodbc.so
}