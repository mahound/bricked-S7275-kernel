#!/bin/bash
export CROSS_COMPILE=~/arm-cortex-a15-linaro-4.7.4/bin/arm-cortex_a15-linux-gnueabihf-
export ARCH=arm
export KBUILD_BUILD_USER=mahound
export KBUILD_BUILD_HOST="CleanROM"
VERSION=S7275R
KERN_NAME_DIR=mahSARA-S7275-kernel
echo 
echo "Cleaning previous build..."
make clean
rm ~/$KERN_NAME_DIR/build/kernel.zip
rm ~/$KERN_NAME_DIR/build/kernel-$VERSION.zip
rm ~/$KERN_NAME_DIR/build/boot.img
rm ~/$KERN_NAME_DIR/build/zImage
rm ~/$KERN_NAME_DIR/build/zip/boot.img
rm ~/$KERN_NAME_DIR/OUT/kernel-$VERSION.zip
rm -rf ~/$KERN_NAME_DIR/build/zip/system/

echo 
echo "Done!"
