SUMMARY = "IPsec Configuration Daemon"
LICENSE = "Apache-2.0"

LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

DEPENDS = "ops-ovsdb doxygen-native gtest gmock strongswan"

SRC_URI = "git://git-nos.rose.rdlabs.hpecorp.net/hpe/hpe-ipsec;protocol=http\
           file://hpe-ipsec.service"

SRCREV="ea0bc416e0ae5745549fb73cecb5b81ced97a8e6"

# When using AUTOREV, we need to force the package version to the revision of git
# in order to avoid stale shared states.
PV = "git${SRCPV}"

S = "${WORKDIR}/git"

do_install_append() {
     install -d ${D}${systemd_unitdir}/system
     install -m 0644 ${WORKDIR}/hpe-ipsec.service ${D}${systemd_unitdir}/system/
}

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "hpe-ipsec.service"

inherit openswitch cmake systemd
