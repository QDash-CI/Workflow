#!/bin/sh -ex

BASE_DOWNLOAD_URL="https://github.com/QDash-CI/Master/releases/download"
TAG=${ID}

linux() {
  ARCH="$1"
  PRETTY_ARCH="$2"
  DESCRIPTION="$3"

  echo -n "| "
  echo -n "[$PRETTY_ARCH](${BASE_DOWNLOAD_URL}/${FORGEJO_REF}/QDash-${TAG}-${ARCH}.AppImage) | "
  echo -n "$DESCRIPTION |"
  echo
}

win() {
  ARCH="$1"
  PRETTY_ARCH="$2"
  DESCRIPTION="$3"

  echo -n "| "
  echo -n "[$PRETTY_ARCH (binary)](${BASE_DOWNLOAD_URL}/${FORGEJO_REF}/QDash-Windows-${TAG}-${ARCH}.zip) | "
  echo -n "[$PRETTY_ARCH (setup)](${BASE_DOWNLOAD_URL}/${FORGEJO_REF}/QDash-Setup-${TAG}-${ARCH}.exe) | "
  echo -n "$DESCRIPTION |"
  echo
}

changelog() {
  echo "## Changelog"
  echo
}

echo "This is ref [\`$FORGEJO_REF\`](https://git.crueter.xyz/QFRC/QDash/commit/$FORGEJO_REF) of QDash's master branch."
echo
changelog
echo "## Packages"
echo
echo "### Linux"
echo
echo "Linux packages are distributed via AppImage."
echo
echo "| Build | Description |"
echo "| ----- | ----------- |"
linux amd64 amd64 "For Intel and AMD CPUs"
linux aarch64 aarch64 "For ARM CPUs (Qualcomm, PowerVR, Rockchip, Apple...)"
echo
echo "### Windows"
echo
echo "Windows packages are portable zip files, or NSIS setup executables."
echo
echo "| Portable | Setup | Description |"
echo "| ----- | ----- | ----------- |"
win amd64 amd64 "For Intel and AMD CPUs"
win arm64 aarch64 "For ARM CPUs (Qualcomm, PowerVR, Rockchip...)"
echo
echo "### macOS"
echo
echo "macOS comes in a universal binary."
echo
echo "[macOS Universal Binary](${BASE_DOWNLOAD_URL}/${TAG}/QDash-macOS-${TAG}.tar.gz)"
echo