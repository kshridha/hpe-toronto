# Copyright (C) 2015 Hewlett Packard Enterprise Development LP
# All Rights Reserved.

DISTRO_KERNEL_FILE = $(BASE_BZIMAGE_FILE)
DISTRO_FS_FILE = $(BASE_TARGZ_FS_FILE)
#DISTRO_EXTRA_FS_FILES = $(BASE_BOX_FILE)
# Use openswitch-appliance-image if you want to build an appliance
DISTRO_FS_TARGET = openswitch-disk-image

# For this platform we create a itb image that includes a kernel, fs and dtb
all:: kernel fs

