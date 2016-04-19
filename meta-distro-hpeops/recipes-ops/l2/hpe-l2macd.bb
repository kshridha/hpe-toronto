SUMMARY = "L2MACD Daemon"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

DEPENDS = "ops-ovsdb ops-cli"

SRC_URI = "git://git-nos.rose.rdlabs.hpecorp.net/hpe/hpe-l2macd;protocol=http\
           file://hpe-l2macd.service"

SRCREV = "af73a5ca56c30b1b80b587de7f28dc85a48128df"

# When using AUTOREV, we need to force the package version to the revision of git
# in order to avoid stale shared states.
PV = "git${SRCPV}"

S = "${WORKDIR}/git"

FILES_${PN} += "/usr/lib/cli/plugins/"

inherit openswitch cmake
