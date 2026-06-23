#!/bin/bash

set -e

# Clean old manifest
rm -rf .repo/local_manifests

# Init Lineage Source
repo init -u https://github.com/LineageOS/android.git -b lineage-23.2 --git-lfs

# Add local manifest
mkdir -p .repo/local_manifests

# Download manifest
git clone https://github.com/shipukacapri/manaus_local_manifests --depth 1 -b lineage .repo/local_manifests

# Clean previous sources
rm -rf device/motorola/manaus
rm -rf device/motorola/manaus-kernel
rm -rf vendor/motorola/manaus
rm -rf kernel/motorola/manaus
rm -rf hardware/motorola
rm -rf device/mediatek/sepolicy_vndr

# Sync everything from manifest
/opt/crave/resync.sh

# Clean previous builds
rm -rf out/target/product/manaus

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
