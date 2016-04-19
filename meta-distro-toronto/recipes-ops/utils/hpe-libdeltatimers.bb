SUMMARY = "Delta Timers Library"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

DEPENDS = "gtest doxygen-native"

SRC_URI = "git://git-nos.rose.rdlabs.hpecorp.net/hpe/hpe-libdeltatimers;protocol=http"

SRCREV = "f78646c24b4570e5f13cf1e2762d1cb593be79b9"

# When using AUTOREV, we need to force the package version to the revision of git
# in order to avoid stale shared states.
PV = "git${SRCPV}"

S = "${WORKDIR}/git"

inherit openswitch cmake

