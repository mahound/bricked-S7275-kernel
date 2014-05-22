#!/bin/bash
cp mahound_defconfig .config
export CROSS_COMPILE=~/arm-cortex-a15-linaro-4.7.4/bin/arm-cortex_a15-linux-gnueabihf-
export ARCH=arm
export KBUILD_BUILD_USER=mahound
export KBUILD_BUILD_HOST="CleanROM"
VERSION=S7275R
KERN_NAME_DIR=mahSARA-S7275-kernel
date_str=`date '+%m%d%y_%H%M%S'`
echo 
echo "Cleaning previous build..."
make clean
rm ~/$KERN_NAME_DIR/build/kernel.zip
rm ~/$KERN_NAME_DIR/build/kernel-$VERSION.zip
rm ~/$KERN_NAME_DIR/build/boot.img
rm ~/$KERN_NAME_DIR/build/zImage
rm ~/$KERN_NAME_DIR/build/zip/boot.img
rm -rf ~/$KERN_NAME_DIR/build/zip/system/
mkdir ~/$KERN_NAME_DIR/build/zip/system
mkdir ~/$KERN_NAME_DIR/build/zip/system/lib
mkdir ~/$KERN_NAME_DIR/build/zip/system/lib/modules
mkdir ~/$KERN_NAME_DIR/build/zip/system/lib/modules/prima

echo 
echo "Done!"

DATE_START=$(date +"%s")
echo
echo "CROSS_COMPILE="$CROSS_COMPILE
echo "ARCH="$ARCH
MODULES_DIR=~/$KERN_NAME_DIR/build/zip/system/lib/modules
echo
echo "Building kernel..."
make -j2
echo
echo "Copy kernel modules to working dir..."
echo "MODULES_DIR="$MODULES_DIR
echo
find -name '*.ko' -exec cp -v {} $MODULES_DIR \;
cp -v ~/$KERN_NAME_DIR/build/zip/system/lib/modules/wlan.ko ~/$KERN_NAME_DIR/build/zip/system/lib/modules/prima/prima_wlan.ko
rm ~/$KERN_NAME_DIR/build/zip/system/lib/modules/wlan.ko
echo
echo "Copy kernel to working dir..."
find -name 'zImage' -exec cp -v {} ~/$KERN_NAME_DIR/build/ \;
echo
echo "Making boot.img..."
cd ~/$KERN_NAME_DIR/build/
./mkbootimg --kernel zImage --ramdisk ramdisk.gz --cmdline "console=null androidboot.hardware=qcom user_debug=31" -o boot.img --base 0x80200000 --ramdiskaddr 0x82200000
echo
echo "Making update.zip"
cp -v ~/$KERN_NAME_DIR/build/boot.img ~/$KERN_NAME_DIR/build/zip/boot.img
cd ~/$KERN_NAME_DIR/build/zip/
zip -r ../kernel.zip .
cd ~/$KERN_NAME_DIR/build/
java -jar signapk.jar testkey.x509.pem testkey.pk8 kernel.zip kernel-$VERSION.zip
echo
echo "Copy zip file to OUT folder"
cp -v ~/$KERN_NAME_DIR/build/kernel-$VERSION.zip ~/$KERN_NAME_DIR/OUT/kernel-$VERSION-$date_str.zip
DATE_END=$(date +"%s")
echo
DIFF=$(($DATE_END - $DATE_START))
echo "Done in $(($DIFF / 60)) m i $(($DIFF % 60)) s."

