#bin/#!/bin/bash

	pacman -Syu --noconfirm --needed git bc inetutils zip libxml2 python3 \
                                 jre-openjdk jdk-openjdk flex bison libc++ python-pip

	git clone -q --depth=1 https://github.com/mvaisakh/gcc-arm64 -b  gcc-master $HOME/gcc-arm64
	git clone -q --depth=1 https://github.com/mvaisakh/gcc-arm -b gcc-master $HOME/gcc-arm32
	git clone -q --depth=1 https://gitlab.com/ElectroPerf/atom-x-clang $HOME/clang
	git clone -q --depth=1 https://github.com/Divyanshu-Modi/AnyKernel3 $HOME/Repack
	git clone -q --depth=1 $SOURCE $HOME/Kernel
	pip3 -q install telegram-send

	mkdir $HOME/.config
	mv telegram-send.conf $HOME/.config/telegram-send.conf
	sed -i s/demo1/${BOT_API_KEY}/g .config/telegram-send.conf
	sed -i s/demo2/${CHAT_ID}/g .config/telegram-send.conf
	mv build.sh $HOME/Kernel/build.sh

	source builder-config
	cd $HOME/Kernel
	bash build.sh $COMPILER $BUILD_VARS
	if [[ "$CONTINUE_BUILD" == "yes" ]]; then
		bash build.sh $COMPILER2 $BUILD_VARS
	elif [[ "$CONTINUE_BUILD" == "no" ]]; then
		telegram-send "Not building GCC build as Clang build failed"
	fi

	exit
