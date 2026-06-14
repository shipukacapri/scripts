#!/bin/bash

set -e

# Clean old manifest
rm -rf .repo/local_manifests

# Init Infinity Source
repo init --depth=1 --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 16 -g default,-mips,-darwin,-notdefault

# Add local manifest
mkdir -p .repo/local_manifests

# Download manifest
git clone https://github.com/shipukacapri/gta4l_local_manifest --depth 1 -b inf-wifi .repo/local_manifests

# Clean previous sources
rm -rf device/samsung/gta4lwifi
rm -rf device/samsung/gta4l-common
rm -rf kernel/samsung/sm6115
rm -rf vendor/samsung/gta4lwifi
rm -rf vendor/samsung/gta4l-common
rm -rf hardware/samsung
rm -rf hardware/dolby

# Sync everything from manifest
/opt/crave/resync.sh

# Clean previous builds
rm -rf out/target/product/gta4lwifi

# Optional conflict fixes

# Build environment
export BUILD_USERNAME=Shipu
export BUILD_HOSTNAME=Crave
export TZ="Asia/Kolkata"
export SKIP_ABI_CHECKS=true

# Build
source build/envsetup.sh
lunch infinity_gta4lwifi-userdebug

m bacon
