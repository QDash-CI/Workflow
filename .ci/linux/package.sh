#!/bin/sh -e

# SPDX-FileCopyrightText: Copyright 2026 crueter
# SPDX-License-Identifier: GPL-3.0-or-later

# This script assumes you're in the source directory

# shellcheck disable=SC1091

ROOTDIR="$PWD"
BUILDDIR="${BUILDDIR:-build}"
. "$ROOTDIR"/.ci/common/project.sh
. "$ROOTDIR"/.ci/common/platform.sh

download() {
    url="$1"; out="$2"
    if command -v wget >/dev/null 2>&1; then
        wget --retry-connrefused --tries=30 "$url" -O "$out"
    elif command -v curl >/dev/null 2>&1; then
        curl -L --retry 30 -o "$out" "$url"
    elif command -v fetch >/dev/null 2>&1; then
        fetch -o "$out" "$url"
    else
        echo "Error: no downloader found." >&2
        exit 1
    fi
}

URUNTIME="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/uruntime2appimage.sh"
SHARUN="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh"

export ICON="$ROOTDIR/dist/org.Q-FRC.QDash.svg"
export DESKTOP="$ROOTDIR/dist/org.Q-FRC.QDash.desktop"
export OPTIMIZE_LAUNCH=1
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=0

if [ "$QT" = "ON" ]; then
	export DEPLOY_QML=0
fi

if [ -d "${BUILDDIR}/bin/Release" ]; then
    strip -s "${BUILDDIR}/bin/Release/"*
else
    strip -s "${BUILDDIR}/bin/"*
fi

VERSION=$(cat "$ROOTDIR/GIT-TAG" 2>/dev/null || echo 'v0.0.4-Workflow')
echo "Making \"$VERSION\" build"

export OUTNAME="$PROJECT_PRETTYNAME-Linux-$VERSION-$FULL_ARCH.AppImage"
UPINFO="gh-releases-zsync|QDash-CI|Releases|latest|*-$FULL_ARCH.AppImage.zsync"

if [ "$DEVEL" = 'true' ]; then
    case "$(uname)" in
        FreeBSD|Darwin) sed -i '' "s|Name=${PROJECT_PRETTYNAME}|Name=${PROJECT_PRETTYNAME} Nightly|" "$DESKTOP" ;;
        *) sed -i "s|Name=${PROJECT_PRETTYNAME}|Name=${PROJECT_PRETTYNAME} Nightly|" "$DESKTOP" ;;
    esac
    UPINFO="$(echo "$UPINFO" | sed 's|Releases|nightly|')"
fi

export UPINFO

# deploy
download "$SHARUN" "$ROOTDIR/quick-sharun"
chmod +x "$ROOTDIR/quick-sharun"
env LC_ALL=C "$ROOTDIR/quick-sharun" "$BUILDDIR/bin/${PROJECT_REPO}"

# Wayland is mankind's worst invention, perhaps only behind war
mkdir -p "$ROOTDIR/AppDir"
echo 'QT_QPA_PLATFORM=xcb' >> "$ROOTDIR/AppDir/.env"

# manually copy qmldir
if [ "$QT" = "ON" ]; then
	qmldir=$(find "$ROOTDIR/.cache/cpm/qt6" -maxdepth 1 -type d)

	if [ -z "$qmldir" ]; then
		echo "-- No bundled Qt found at $ROOTDIR/.cache/cpm/qt6"
		exit 1
	fi

	qmldir="$qmldir/qml"

	if [ ! -d "$qmldir" ]; then
		echo "-- No QML files found at $qmldir"
		exit 1
	fi

	cp -r "$qmldir" "$ROOTDIR"/AppDir/shared/lib/qt6
fi

# fluent is unneeded and kind of fat
rm -rf "$ROOTDIR"/AppDir/shared/lib/qt6/qml/QtQuick/Controls/FluentWinUI3

# MAKE APPIMAGE WITH URUNTIME
echo "Generating AppImage..."
download "$URUNTIME" "$ROOTDIR/uruntime2appimage"
chmod +x "$ROOTDIR/uruntime2appimage"
"$ROOTDIR/uruntime2appimage"

if [ "$DEVEL" = 'true' ]; then
    rm -f "$ROOTDIR"/*.AppImage.zsync
fi

echo "Linux package created!"
