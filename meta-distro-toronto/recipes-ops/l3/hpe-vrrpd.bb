SUMMARY = "Virtual Router Redundancy Protocol"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

DEPENDS = "ops-utils ops-ovsdb ops-cli"

SRC_URI = "git://git-nos.rose.rdlabs.hpecorp.net/hpe/hpe-vrrpd;protocol=http\
           file://hpe-vrrpd.service"

SRCREV = "0a3946e2ed38a8ce75800c3120910035c2cc35ae"

# When using AUTOREV, we need to force the package version to the revision of git
# in order to avoid stale shared states.
PV = "git${SRCPV}"

S = "${WORKDIR}/git"

do_install_append() {
     install -d ${D}${systemd_unitdir}/system
     install -m 0644 ${WORKDIR}/hpe-vrrpd.service ${D}${systemd_unitdir}/system/
}

FILES_${PN} += "/usr/lib/cli/plugins/"
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "hpe-vrrpd.service"

inherit openswitch cmake systemd 
