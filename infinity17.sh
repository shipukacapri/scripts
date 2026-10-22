#!/bin/bash
echo "======= Remove Project ========="

rm -rf .repo/local_manifests

echo "======= Remove Done ======"

# Rom source repo
        repo init --depth=1 --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 17 -g default,-mips,-darwin,-notdefault
        
echo "Repo init success"
echo "=================="


git clone https://github.com/shipukacapri/hotdogb_local_manifest --depth 1 -b infinity-17 .repo/local_manifests 


echo "===== Sync the repositories ========"

/opt/crave/resync.sh
repo sync -c -j$(nproc --all) --force-sync --force-remove-dirty --no-clone-bundle --no-tags
/opt/crave/resync.sh
repo sync -c -j$(nproc --all) --force-sync --force-remove-dirty --no-clone-bundle --no-tags
/opt/crave/resync.sh

echo "======== Syncing Done =========="
