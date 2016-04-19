SUMMARY = "MCLAG Daemon"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

DEPENDS = "ops-ovsdb"

SRC_URI = "git://git-nos.rose.rdlabs.hpecorp.net/hpe/hpe-mclagd;protocol=http\
           file://hpe-mclagd.service\
           file://hpe-mclagkad.service"

SRCREV = "ce4ccfca25d454bf238fc9263427dd70519a7e1e"

# When using AUTOREV, we need to force the package version to the revision of git
# in order to avoid stale shared states.
PV = "git${SRCPV}"

S = "${WORKDIR}/git"

do_install_append() {
     install -d ${D}${systemd_unitdir}/system
     install -m 0644 ${WORKDIR}/hpe-mclagd.service ${D}${systemd_unitdir}/system/
     install -m 0644 ${WORKDIR}/hpe-mclagkad.service ${D}${systemd_unitdir}/system/
}

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "hpe-mclagd.service hpe-mclagkad.service"

inherit openswitch cmake systemd
