#!/bin/sh -e

# SPDX-FileCopyrightText: Copyright 2026 crueter
# SPDX-License-Identifier: GPL-3.0-or-later

# shellcheck disable=SC2043

ROOTDIR="$PWD"
ARTIFACTS_DIR="artifacts"

# shellcheck disable=SC1091
. "$ROOTDIR"/.ci/common/project.sh

mkdir -p "$ARTIFACTS_DIR"

tagged() {
	falsy "$DEVEL"
}

opts() {
	falsy "$DISABLE_OPTS"
}

## AppImage ##
ARCHES="amd64"
opts && ARCHES="$ARCHES steamdeck"
[ "$DISABLE_ARM" != "true" ] && ARCHES="$ARCHES aarch64"
COMPILERS=gcc-standard

opts && tagged && ARCHES="$ARCHES legacy rog-ally" && COMPILERS="$COMPILERS clang-pgo"

for arch in $ARCHES; do
	for compiler in $COMPILERS; do
		ARTIFACT="${PROJECT_PRETTYNAME}-Linux-${ID}-${arch}-${compiler}"

		cp "$ROOTDIR/linux-$arch-$compiler"/*.AppImage "$ARTIFACTS_DIR/$ARTIFACT.AppImage"
		tagged && cp "$ROOTDIR/linux-$arch-$compiler"/*.AppImage.zsync "$ARTIFACTS_DIR/$ARTIFACT.AppImage.zsync"
	done
done

## Android ##
if falsy "$DISABLE_ANDROID"; then
	FLAVORS="standard chromeos"
	opts && tagged && FLAVORS="$FLAVORS legacy optimized"

	for flavor in $FLAVORS; do
		cp "$ROOTDIR/android-$flavor"/*.apk "$ARTIFACTS_DIR/${PROJECT_PRETTYNAME}-Android-${ID}-${flavor}.apk"
	done
fi

## Windows ##
COMPILERS="msvc-standard"

ARCHES=amd64
falsy "$DISABLE_MSVC_ARM" && ARCHES="$ARCHES arm64"

for arch in $ARCHES; do
	for compiler in $COMPILERS; do
		cp "$ROOTDIR/windows-$arch-$compiler"/*.zip "$ARTIFACTS_DIR/${PROJECT_PRETTYNAME}-Windows-${ID}-${arch}-${compiler}.zip"
	done
done

## MinGW ##
if falsy "$DISABLE_MINGW"; then
	COMPILERS="amd64-gcc-standard arm64-clang-standard"
	opts && tagged && COMPILERS="$COMPILERS amd64-clang-pgo arm64-clang-pgo"

	for compiler in $COMPILERS; do
		cp "$ROOTDIR/mingw-$compiler"/*.zip "$ARTIFACTS_DIR/${PROJECT_PRETTYNAME}-Windows-${ID}-mingw-${compiler}.zip"
	done
fi

## Source Pack ##
if [ -d "source" ]; then
	cp "$ROOTDIR/source/source.tar.zst" "$ARTIFACTS_DIR/${PROJECT_PRETTYNAME}-Source-${ID}.tar.zst"
fi

## MacOS ##
cp "$ROOTDIR/macos"/*.tar.gz "$ARTIFACTS_DIR/${PROJECT_PRETTYNAME}-macOS-${ID}.tar.gz"

## FreeBSD and other stuff ##
ls "$ARTIFACTS_DIR"
