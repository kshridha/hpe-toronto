SUMMARY = "UDLD Daemon"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

DEPENDS = "ops-utils ops-ovsdb libpcap"

SRC_URI = "git://git-nos.rose.rdlabs.hpecorp.net/hpe/hpe-udldd;protocol=http\
           file://udldd.service"

SRCREV = "e645fd225ee5e06886e379555fe57e050c3bcae7"

# When using AUTOREV, we need to force the package version to the revision of git
# in order to avoid stale shared states.
PV = "git${SRCPV}"

S = "${WORKDIR}/git"

do_install_append() {
     install -d ${D}${systemd_unitdir}/system
     install -m 0644 ${WORKDIR}/udldd.service ${D}${systemd_unitdir}/system/
}

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "udldd.service"

inherit openswitch cmake systemd
