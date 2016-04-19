SUMMARY = "Enterprise Tests"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "git://git-nos.rose.rdlabs.hpecorp.net/hpe/hpe-enterprise-tests;protocol=http"

SRCREV = "9fdcfc39594a0a261fcb25957a54c3245b128913"

# When using AUTOREV, we need to force the package version to the revision of git
# in order to avoid stale shared states.
PV = "git${SRCPV}"

S = "${WORKDIR}/git"

