#!/bin/bash

set -e

# Clean old manifest
rm -rf .repo/local_manifests

# Init Infinity Source
repo init -u https://github.com/AxionAOSP/android.git -b lineage-23.2 --git-lfs

# Add local manifest
mkdir -p .repo/local_manifests

# Download manifest
git clone https://github.com/shipukacapri/rhodei_local_manifest --depth 1 -b axion .repo/local_manifests

# Clean previous sources
rm -rf device/motorola/rhodei
rm -rf device/motorola/sm6375-common
rm -rf kernel/motorola/sm6375
rm -rf vendor/motorola/rhodei
rm -rf vendor/motorola/sm6375-common
rm -rf hardware/motorola
rm -rf hardware/dolby

# Sync everything from manifest
/opt/crave/resync.sh

# Clean previous builds
rm -rf out/target/product/rhodei

# Optional conflict fixes

# Build environment
export BUILD_USERNAME=Shipu
export BUILD_HOSTNAME=Crave
export TZ="Asia/Kolkata"
export SKIP_ABI_CHECKS=true

# Build
source build/envsetup.sh
axion rhodei userdebug gms
ax -b
