#!/bin/sh -ex

mkdir -p artifacts

ARCHES="amd64 aarch64"

for arch in $ARCHES
do
  cp linux-appimage-$arch/*.AppImage "artifacts/QDash-${ID}-${arch}.AppImage"
  if [ "$DEVEL" = "false" ]; then
    cp linux-appimage-$arch/*.AppImage.zsync "artifacts/QDash-${ID}-${arch}.AppImage.zsync"
  fi
done

for arch in amd64 arm64
do
  cp windows-$arch/*.zip artifacts/QDash-Windows-${ID}-${arch}.zip
  cp windows-setup-$arch.exe artifacts/QDash-Windows-${ID}-${arch}.exe
done

cp macos-universal/*.tar.gz artifacts/QDash-macOS-${ID}.tar.gz