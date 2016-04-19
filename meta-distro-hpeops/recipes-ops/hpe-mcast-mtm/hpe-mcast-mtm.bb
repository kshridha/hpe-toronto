SUMMARY = "Multicast Traffic Manager Daemon"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

DEPENDS = "ops-ovsdb hpe-libdeltatimers libtins boost gtest gmock doxygen-native git-native ruby-native"

SRC_URI = "git://git-nos.rose.rdlabs.hpecorp.net/hpe/hpe-mcast-mtm;protocol=http\
           file://mtmd.service"

SRCREV = "${AUTOREV}"

# When using AUTOREV, we need to force the package version to the revision of git
# in order to avoid stale shared states.
PV = "git${SRCPV}"

S = "${WORKDIR}/git"

do_install_append() {
     install -d ${D}${systemd_unitdir}/system
     install -m 0644 ${WORKDIR}/mtmd.service ${D}${systemd_unitdir}/system/
}

EXTRA_OECMAKE = "-DGIT_EXECUTABLE=`which git`"

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "mtmd.service"

inherit openswitch cmake systemd
