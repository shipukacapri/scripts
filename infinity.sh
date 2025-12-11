#!/bin/bash

# =================================================================
#                     Axion Build Script
# =================================================================
#
# Stop the script immediately if any command fails


# =======================
#   SETUP & PRE-CHECKS
# =======================

# Load environment variables from .env file


# Check for required secrets


# Telegram notification function


# Trap to send a notification on script failure



# Send "Build Started" notification


# === Exports ===


# =======================
#   1. CLEANUP SECTION
# =======================

echo "===> Cleanup"
if [ "$CLEAN_ALL_REPO" = true ]; then
  echo "Removing entire .repo (full clean)"
  rm -rf .repo
else
  echo "Selective cleanup of device/kernel/vendor and out paths"
  rm -rf device/motorola/capri \
         device/motorola/sm6225-common \
         kernel/motorola/sm6225 \
         vendor/motorola/capri || true

  rm -rf out/target/product/capri/system \
         out/target/product/capri/product || true
fi

# =======================
#   2. REPO INITIALIZATION & SYNC
# =======================
echo "Initializing infinity repository..."
repo init --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 16 -g default,-mips,-darwin,-notdefault


echo "Syncing sources..."
if [ -f "/opt/crave/resync.sh" ]; then
    /opt/crave/resync.sh
else
    repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)
fi


# =======================
#   4. CLONING ADDITIONAL REPOSITORIES
# =======================
echo "Cloning additional repositories..."
git clone https://github.com/LineageOS/android_device_motorola_capri.git -b lineage-23.0 device/motorola/capri --depth=1
git clone https://github.com/LineageOS/android_device_motorola_sm6225-common.git -b lineage-23.0 device/motorola/sm6225-common --depth=1
git clone https://github.com/LineageOS/android_kernel_motorola_sm6225.git -b lineage-23.0 kernel/motorola/sm6225 --depth=1
git clone https://github.com/TheMuppets/proprietary_vendor_motorola_capri.git -b lineage-23.0 vendor/motorola/capri --depth=1
git clone https://github.com/TheMuppets/proprietary_vendor_motorola_sm6225-common.git -b lineage-23.0 vendor/motorola/sm6225-common --depth=1

# =======================
#   6. BUILD THE ROM
# =======================
echo "Starting the build process..."
. build/envsetup.sh
lunch infinity_capri-userdebug

echo "Starting the main build..."
m bacon

# =======================
#   7. UPLOAD THE BUILD
# =======================


# === Stop Build Timer and Calculate Duration ===




# Unset the trap explicitly for a clean successful exit

