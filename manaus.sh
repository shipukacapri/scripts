#!/bin/bash

set -e

# Clean old manifest
rm -rf .repo/local_manifests

# Init Lineage Source
repo init -u https://github.com/LineageOS/android.git -b lineage-23.2 --git-lfs

# local manifest
git clone https://github.com/shipukacapri/manaus_local_manifests -b lineage .repo/local_manifests --depth=1

# Sync everything from manifest
/opt/crave/resync.sh

# Clean previous sources
rm -rf device/motorola/manaus
rm -rf device/motorola/manaus-kernel
rm -rf vendor/motorola/manaus
rm -rf kernel/motorola/manaus
rm -rf hardware/motorola
rm -rf device/mediatek/sepolicy_vndr

# Clone Device Trees
git clone https://github.com/shipukacapri/device_motorola_manaus.git -b lineage device/motorola/manaus --depth=1
git clone https://github.com/moto-manaus/device_motorola_manaus-kernel.git -b sixteen device/motorola/manaus-kernel --depth=1
git clone https://codeberg.org/rexix01/vendor_motorola_manaus.git -b lineage-23.2 vendor/motorola/manaus --depth=1
git clone https://github.com/moto-manaus/device_mediatek_sepolicy_vndr.git -b lineage-23.2 device/mediatek/sepolicy_vndr --depth=1
git clone https://github.com/moto-manaus/hardware_mediatek.git -b lineage-23.2 hardware/mediatek --depth=1
git clone https://github.com/shipsingh2002/hardware_motorola.git -b edited hardware/motorola --depth=1

# Optional conflict fixes

# Build environment
export BUILD_USERNAME=Shipu
export BUILD_HOSTNAME=Crave
export TZ="Asia/Kolkata"
export SKIP_ABI_CHECKS=true

# Build
source build/envsetup.sh
lunch manaus-bp4a-userdebug
m bacon
