
  # ================================
  # Clean old manifests
  # ================================
  rm -rf .repo/local_manifests
  # ================================
  # Initialize EVO repo
  # ================================
  echo '>>> Initializing Evolution X repo'
  repo init -u https://github.com/Evolution-X/manifest -b cnb --git-lfs --depth=1

  # ================================
  # Clone local manifests
  # ================================
  echo '>>> Cloning local manifests'
  git clone https://github.com/shipukacapri/cebu_local_manifest.git -b evo-17 .repo/local_manifests/

  # ================================
  # Sync sources
  # ================================
echo '>>> Syncing sources'

if [ -f /opt/crave/resync.sh ]
 then
    /opt/crave/resync.sh
else
    repo sync -c --force-sync --no-tags --no-clone-bundle --force-remove-dirty
fi

  # ================================
  # Setup build environment
  # ================================
  . build/envsetup.sh

  # ================================
  # Build
  # ================================
  echo '>>> Starting build'
  lunch lineage_cebu-cp2a-userdebug
  m evolution
