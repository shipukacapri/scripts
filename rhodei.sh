#!/bin/bash

set -e

# Clean old manifest
rm -rf .repo/local_manifests

# Init VoltageOS 17
repo init --depth=1 --no-repo-verify --git-lfs -u https://github.com/VoltageOS/manifest.git -b 17

# Add local manifest
mkdir -p .repo/local_manifests

git clone https://github.com/shipukacapri/rhodei_local_manifest --depth 1 -b voltage-17 .repo/local_manifests

# Remove old device-specific sources
rm -rf device/motorola/rhodei
rm -rf device/motorola/sm6375-common
rm -rf kernel/motorola/sm6375
rm -rf vendor/motorola/rhodei
rm -rf vendor/motorola/sm6375-common
rm -rf hardware/motorola
rm -rf hardware/dolby

# Sync VoltageOS
/opt/crave/resync.sh

# ==========================================================
# Soong memory optimization
# ==========================================================

sed -i '/^[[:space:]]*"runtime"$/a\
	"runtime/debug"' cmd/soong_build/main.go

sed -i '/^func main() {/a\
	debug.SetMemoryLimit(40 * 1024 * 1024 * 1024)\
	debug.SetGCPercent(25)\
' cmd/soong_build/main.go

# Show that the patch was applied
echo "===== Soong memory patch ====="
grep -n -A3 -B2 "SetMemoryLimit\|SetGCPercent" cmd/soong_build/main.go
echo "=============================="

# Build environment
export BUILD_USERNAME=Shipu
export BUILD_HOSTNAME=Crave
export TZ="Asia/Kolkata"
export SKIP_ABI_CHECKS=true

# Build
source build/envsetup.sh

lunch voltage_rhodei-cp2a-userdebug

m bacon
