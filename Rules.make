# Copyright (C) 2015 Hewlett-Packard Development Company, L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

DISTRO_HELP_LINK=https://rndwiki.corp.hpecorp.net/confluence/display/hpnevpg/Getting+started+with+EnterpriseHalon+development

DISTRO_ARCHIVE_ADDRESS?=archive-nos.rose.rdlabs.hpecorp.net
DISTRO_SSTATE_ADDRESS?=sstate-nos.rose.rdlabs.hpecorp.net
DISTRO_FS_TARGET = hpeops-image

DISTRO_CA_BUNDLE = ${BUILD_ROOT}/yocto/hpeops/certs/hpe.crt

SSTATE_DIR ?= "/ws/openswitch-sstate-cache"

no_proxy = 127.0.0.1,localhost,review-nos.rose.rdlabs.hpecorp.net,archive-nos.rose.rdlabs.hpecorp.net,sstate-nos.rose.rdlabs.hpecorp.net,git-nos.rose.rdlabs.hpecorp.net

ifeq ($(HPE_BUILD_ROOT),)
 $(error Seems like you are not invoking make from the top directory, aborting)
endif
