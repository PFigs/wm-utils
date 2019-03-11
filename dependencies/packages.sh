#!/usr/bin/env bash

apt-get -y update
apt-get install -y whiptail \
				   wget \
				   libc6:i386 \
				   libstdc++5:i386 \
				   libstdc++6:i386  \
				   libc6-i386  \
				   lib32z1  \
				   lib32stdc++6 \
				   build-essential \
				   srecord  \
				   python3 \
				   python3-dev \
				   libtool \
				   automake \
				   autoconf \
				   tcpdump \
				   net-tools

