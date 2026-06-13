#!/bin/bash

set -e

# Clean old manifest
rm -rf .repo/local_manifests

# Init Infinity Source
repo init --depth=1 --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 16 -g default,-mips,-darwin,-notdefault

# Add local manifest
mkdir -p .repo/local_manifests

# Download manifest
git clone https://github.com/shipukacapri/fogos_local_manifest --depth 1 -b inf-qp2 .repo/local_manifests

# Clean previous sources
rm -rf device/motorola/fogos
rm -rf device/motorola/sm6375-common
rm -rf kernel/motorola/sm6375
rm -rf vendor/motorola/fogos
rm -rf vendor/motorola/sm6375-common
rm -rf hardware/motorola
rm -rf hardware/dolby

# Sync everything from manifest
/opt/crave/resync.sh

# Clean previous builds
rm -rf out/target/product/fogos

# Optional conflict fixes

# Build environment
export BUILD_USERNAME=Shipu
export BUILD_HOSTNAME=Crave
export TZ="Asia/Kolkata"
export SKIP_ABI_CHECKS=true

# Build
source build/envsetup.sh
lunch infinity_fogos-userdebug

m bacon
