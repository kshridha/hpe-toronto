# Copyright (C) 2016 Hewlett Packard Enterprise Development LP
# All Rights Reserved.

DISTRO_KERNEL_FILE = $(BASE_BZIMAGE_FILE)
DISTRO_FS_FILE = $(BASE_CPIO_FS_FILE)
DISTRO_FS_TARGET = openswitch-disk-image
ONIE_INSTALLER_RECIPE = openswitch-onie-installer
ONIE_INSTALLER_FILE = onie-installer-x86_64-as7712_32x

# For this platform we create an onie-installer
all:: onie-installer

