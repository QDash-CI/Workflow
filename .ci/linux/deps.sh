#!/bin/sh

# SPDX-FileCopyrightText: 2025 crueter
# SPDX-License-Identifier: GPL-3.0-or-later

set -eux

EXTRA_PACKAGES="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/get-debloated-pkgs.sh"

echo "Installing build dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
		base-devel \
		ccache \
		cmake \
		curl \
		jq \
		libxkbcommon-x11 \
		ninja \
		patchelf \
		python-pip \
		python-jinja \
		strace \
		unzip \
		wget \
		xcb-util-cursor \
		xcb-util-image \
		xcb-util-renderutil \
		xcb-util-wm \
		xorg-server-xvfb \
		zip \
		zsync

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
wget --retry-connrefused --tries=30 "$EXTRA_PACKAGES" -O ./get-debloated-pkgs.sh
chmod +x ./get-debloated-pkgs.sh
./get-debloated-pkgs.sh --add-mesa --prefer-nano libxml2-mini opus-mini
