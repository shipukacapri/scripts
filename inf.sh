#Clean Up Old Repos

rm -rf device/oneplus/aston
rm -rf device/oneplus/sm8550-common
rm -rf kernel/oneplus/sm8550
rm -rf kernel/oneplus/sm8550-modules
rm -rf kernel/oneplus/sm8550-devicetrees
rm -rf hardware/oplus
rm -rf hardware/dolby
rm -rf vendor/oneplus/aston
rm -rf vendor/oneplus/sm8550-common
rm -rf packages/apps/GameBar
rm -rf .repo
rm -rf prebuilts/clang/host/linux-x86
rm -rf out/target/product/aston/system
rm -rf out/target/product/aston/product

#Repo Init and Sync

repo init --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 16 -g default,-mips,-darwin,-notdefault

if [ -f "/opt/crave/resync.sh" ]; then
    /opt/crave/resync.sh
else
    repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)
fi


#Cloning additional repositories

git clone https://github.com/gaurav-paul9/android_device_oneplus_aston.git -b infclean device/oneplus/aston --depth=1
git clone https://github.com/gaurav-paul9/android_device_oneplus_sm8550-common.git -b infclean device/oneplus/sm8550-common --depth=1
git clone https://github.com/gaurav-paul9/android_kernel_oneplus_sm8550.git -b newroot kernel/oneplus/sm8550 --depth=1
git clone https://github.com/LineageOS/android_kernel_oneplus_sm8550-modules.git -b lineage-23.0 kernel/oneplus/sm8550-modules --depth=1
git clone https://github.com/gaurav-paul9/android_kernel_oneplus_sm8550-devicetrees.git -b lineage-23.0 kernel/oneplus/sm8550-devicetrees --depth=1
git clone https://github.com/LineageOS/android_hardware_oplus.git -b lineage-23.0 hardware/oplus --depth=1
git clone https://github.com/TheMuppets/proprietary_vendor_oneplus_aston.git -b lineage-23.0 vendor/oneplus/aston --depth=1
git clone https://gitlab.com/NoPrincessHere/proprietary_vendor_oneplus_sm8550-common.git -b sixteen vendor/oneplus/sm8550-common --depth=1

#Build Starting

. build/envsetup.sh
lunch infinity_aston-userdebug
m bacon


