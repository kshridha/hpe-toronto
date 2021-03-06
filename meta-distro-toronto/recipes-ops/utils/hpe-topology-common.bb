SUMMARY = "Common Code Library for the Topology Modular Test Framework"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "git://git-nos.rose.rdlabs.hpecorp.net/hpe/hpe-topology-common;protocol=http"

SRCREV = "${AUTOREV}"

# When using AUTOREV, we need to force the package version
# to the revision of git in order to avoid stale shared states.
PV = "git${SRCPV}"

S = "${WORKDIR}/git"

RDEPENDS_${PN} = "python-pytest"
DEPENDS_class-native = "python-pytest-native"

BBCLASSEXTEND = "native"
