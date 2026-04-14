#!/bin/sh -ex

# SPDX-FileCopyrightText: Copyright 2026 crueter
# SPDX-License-Identifier: GPL-3.0-or-later

# This script assumes you're in the source directory

# shellcheck disable=SC1091

BUILDDIR="${BUILDDIR:-build}"
. .ci/common/project.sh

SHARUN="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh"

export ICON="$PWD/dist/org.Q-FRC.QDash.svg"
export DESKTOP="$PWD/dist/org.Q-FRC.QDash.desktop"
export OPTIMIZE_LAUNCH=1
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=0
export ADD_HOOKS="wayland-is-broken.hook"

VERSION=$(cat "$PWD/GIT-TAG" 2>/dev/null || echo 'v0.0.4-Workflow')
echo "Making \"$VERSION\" build"

export OUTNAME="$PROJECT_PRETTYNAME-Linux-$VERSION-$FULL_ARCH.AppImage"
UPINFO="gh-releases-zsync|QDash-CI|Releases|latest|*-$FULL_ARCH.AppImage.zsync"

if [ "$DEVEL" = 'true' ]; then
	sed -i "s|Name=${PROJECT_PRETTYNAME}|Name=${PROJECT_PRETTYNAME} Nightly|" "$DESKTOP"
    UPINFO="$(echo "$UPINFO" | sed 's|Releases|Nightly|')"
fi

export UPINFO

# deploy
curl -L --retry 30 "$SHARUN" -o quick-sharun
chmod +x quick-sharun
./quick-sharun "$BUILDDIR/bin/${PROJECT_REPO}"

# fluent is unneeded and kind of fat
rm -rf AppDir/shared/lib/qt6/qml/QtQuick/Controls/FluentWinUI3

# MAKE APPIMAGE WITH URUNTIME
./quick-sharun --make-appimage

if [ "$DEVEL" = 'true' ]; then
    rm -f ./*.AppImage.zsync
fi

echo "Linux package created!"
