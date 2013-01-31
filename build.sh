export ARCH=arm
export CROSS_COMPILE=/home/diadust/android/toolchain/arm-eabi-4.4.3/bin/arm-eabi-
KERNDIR=/home/diadust/gb1/kernel
JOBN=16
export KBUILD_BUILD_VERSION="${VERSION}#v1.0"
INITRAM_DIR=$KERNDIR/initramfs
INITRAM_ORIG=$KERNDIR/../initramfs/KRKPH


if [[ -z $1 ]]
then
	echo "No configuration file defined"
	exit 1

else 
	if [[ ! -e "$KERNDIR/arch/arm/configs/$1" ]]
	then
		echo "Configuration file $1 don't exists"
		exit 1
	fi
fi

echo "----------------------------------------------------------------------------------------------------------CLEAN"
rm $KERNDIR/zImage
make distclean
rm -rf $INITRAM_DIR/*
echo "----------------------------------------------------------------------------------------------------------CONFIG"
cp -R $INITRAM_ORIG/* $INITRAM_DIR/
find $INITRAM_DIR -name "*~" -exec rm -f {} \;
make $1
make menuconfig
echo "----------------------------------------------------------------------------------------------------------BUILD"
make -j$JOBN
echo "----------------------------------------------------------------------------------------------------------MODULES"
find . -name "*.ko" ! -path "*$INITRAM_DIR*" -exec echo {} \;
find . -name "*.ko" ! -path "*$INITRAM_DIR*" -exec cp {} $INITRAM_DIR/lib/modules/  \;
echo "----------------------------------------------------------------------------------------------------------REBUILD"
make -j$JOBN
cp $KERNDIR/arch/arm/boot/zImage $KERNDIR/zImage


