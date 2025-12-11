#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

echo "==> Starting InfinityX build script for device: capri"

# 0) Optional: print working directory and user
echo "PWD: $(pwd)"
echo "User: $(whoami)"

# 1) Clean old local manifests (safe)
if [ -d .repo/local_manifests ]; then
  echo "Removing old .repo/local_manifests..."
  rm -rf .repo/local_manifests
fi

# 2) Local TimeZone (adjusted for your location)
if [ -w /etc/localtime ] || [ -w /etc ]; then
  sudo rm -f /etc/localtime || true
  sudo ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime || true
  echo "Timezone set to Asia/Kolkata"
else
  echo "Warning: cannot change /etc/localtime (permission). Skipping timezone change."
fi

# 3) Repo init for InfinityX (Android 16 manifest)
echo "Initializing repo (manifest: ProjectInfinity-X/manifest branch 16)..."
repo init --depth=1 --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 16 -g default,-mips,-darwin,-notdefault
echo "Repo init complete."

# 4) Clone your local manifest (the one you created on GitHub)
echo "Cloning local manifests from shipukacapri..."
git clone https://github.com/shipukacapri/infinity_local_manifests .repo/local_manifests --depth 1 || {
  echo "ERROR: failed to clone your local_manifests repo. Exiting."
  exit 1
}
echo "Local manifests cloned."

# 5) Sync repos on Crave (use their helper)
echo "Running Crave resync..."
/opt/crave/resync.sh
echo "Sync finished."

# 6) Export build identity
export BUILD_USERNAME=shipukacapri
export BUILD_HOSTNAME=crave
echo "Exports set: BUILD_USERNAME=${BUILD_USERNAME}, BUILD_HOSTNAME=${BUILD_HOSTNAME}"

# 7) Small automatic frameworks/base DT2W patch step (keeps your original)
echo "Applying optional framework patch if needed..."
if [ -d frameworks/base ]; then
  (cd frameworks/base && (git log --oneline | grep -q "dt2w\\|DT2W\\|double.*tap" || (wget -O temp.patch "https://github.com/ij-project/frameworks_base_evox/commit/c49d293.patch" && (git apply temp.patch && git add . && git commit -m "Apply DT2W patch" || echo "Patch conflict or no commit; continuing...") && rm -f temp.patch)) ) || true
fi

# 8) Setup build env
echo "Sourcing build environment..."
# shellcheck source=/dev/null
source build/envsetup.sh
echo "Envsetup done."

# 9) Try a set of lunch/brunch commands until one succeeds.
# Common possibilities for target names depend on manifest: try them in order.
echo "Selecting lunch/brunch target for capri..."
if breakfast capri-userdebug 2>/dev/null; then
  echo "Used: breakfast capri-userdebug"
elif lunch infinity_capri-userdebug 2>/dev/null; then
  echo "Used: lunch infinity_capri-userdebug"
elif lunch capri-userdebug 2>/dev/null; then
  echo "Used: lunch capri-userdebug"
elif brunch capri 2>/dev/null; then
  echo "Used: brunch capri"
elif lunch capri-user 2>/dev/null; then
  echo "Used: lunch capri-user"
else
  echo "WARNING: could not find a standard lunch/brunch target for 'capri'."
  echo "Listing available lunch combos for debugging:"
  lunch || true
  echo "Exiting with failure; adjust the device lunch name in the script if needed."
  exit 2
fi

# 10) Clean steps (safe)
echo "Running make installclean..."
make installclean || true

# 11) Build
echo "Starting build: m bacon"
m bacon

echo "Build script finished."
