KERDIR=/home/diadust/gb1/kernel
export CROSS_COMPILER=/home/diadust/android/toolchain/arm-eabi-4.4.3/bin/arm-eabi-
export ARCH=arm
INITRAM_DIR=$KERDIR/initramfs
INITRAM_ORIG=$KERDIR/../initramfs/KRKPH
JOBN=16
export KBUILD_BUILD_VERSION="${VERSION}#Beta01"
export LOCALVERSION=""

if [[ -z $1 ]]
then
	echo "No configuration file defined"
	exit 1

else 
	if [[ ! -e "$KERDIR/arch/arm/configs/$1" ]]
	then
		echo "Configuration file $1 don't exists"
		exit 1
	fi
fi

echo "---------------------------------------------------------------------------------------CLEAN"
make distclean
rm -rf $INITRAM_DIR/*
echo "---------------------------------------------------------------------------------------CONFIG"
cp -R $INITRAM_ORIG/* $INITRAM_DIR/
make $1
make menuconfig
echo "---------------------------------------------------------------------------------------MAKE"
make -j$JOBN
echo "---------------------------------------------------------------------------------------COPY MODULES"
find . -name "*.ko" ! -path "*$INITRAM_DIR*" -exec echo {} \;
find . -name "*.ko" ! -path "*$INITRAM_DIR*" -exec cp {} $INITRAM_DIR/lib/modules/  \;
echo "---------------------------------------------------------------------------------------REMAKE"
make -j$JOBN
cp $KERDIR/arch/arm/boot/zImage $KERDIR/zImage

