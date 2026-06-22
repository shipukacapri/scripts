#!/bin/bash

set -e

# Clean old manifest
rm -rf .repo/local_manifests

# Init Infinity Source
repo init -u https://github.com/VoltageOS/manifest.git -b 16.2 --git-lfs

# Add local manifest
mkdir -p .repo/local_manifests

# Download manifest
git clone https://github.com/shipukacapri/nio_local_manifest --depth 1 -b voltage .repo/local_manifests

# Clean previous sources
rm -rf device/motorola/nio
rm -rf device/motorola/sm8250-common
rm -rf kernel/motorola/sm8250
rm -rf vendor/motorola/nio
rm -rf vendor/motorola/sm8250-common
rm -rf hardware/motorola

# Sync everything from manifest
/opt/crave/resync.sh

# REGENERATE VOLTAGE OS KEYS
# ==========================================
# The ( ) runs these commands in a subshell, leaving your main script's directory unchanged.
(
    cd vendor/voltage-priv/keys
    ./keys.sh
)
# ==========================================

# Clean previous builds
rm -rf out/target/product/nio

# Optional conflict fixes

# Build environment
export BUILD_USERNAME=Shipu
export BUILD_HOSTNAME=Crave
export TZ="Asia/Kolkata"
export SKIP_ABI_CHECKS=true

# Build
source build/envsetup.sh
lunch voltage_nio-bp4a-userdebug
m bacon
