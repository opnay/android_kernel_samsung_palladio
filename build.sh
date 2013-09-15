export ARCH=arm
export CROSS_COMPILE=/home/diadust/toolchain/android-toolchain-eabi-4.8/bin/arm-eabi-
KERNDIR=/home/diadust/project/palladio
INITRAM_DIR=$KERNDIR/initramfs/initramfs
INITRAM_ORIG=$KERNDIR/initramfs/KPH
JOBN=16

export KBUILD_BUILD_VERSION="${VERSION}#Immortal+_Init"
export LOCALVERSION=""

DEFCONFIGS=$1
if [[ ! -e "$KERNDIR/arch/arm/configs/$DEFCONFIGS" ]]
then
	echo "Configuration file $DEFCONFIGS don't exists"
	echo "Usage :"
	echo "./build.sh [ Defconfig file name ]"
	exit 1
fi

echo "----------------------------------------------------------------------------------------------------------CLEAN"
rm -Rf $INITRAM_DIR && mkdir $INITRAM_DIR
cp -R $INITRAM_ORIG/* $INITRAM_DIR/
# 임시파일 삭제
# find $INITRAM_DIR -name "*~" -exec rm -f {} \;
make distclean
echo "----------------------------------------------------------------------------------------------------------CONFIG"
make $DEFCONFIGS
make menuconfig
echo "----------------------------------------------------------------------------------------------------------BUILD"
make -j$JOBN
echo "----------------------------------------------------------------------------------------------------------MODULES"
find . -name "*.ko" -exec echo {} \;
find . -name "*.ko" -exec cp {} $INITRAM_DIR/lib/modules/  \;
echo "----------------------------------------------------------------------------------------------------------REBUILD"
make -j$JOBN

cp $KERNDIR/arch/arm/boot/zImage $KERNDIR/zImage

echo " Build Complete "
