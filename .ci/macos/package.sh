#!/bin/sh -e

# SPDX-FileCopyrightText: Copyright 2026 crueter
# SPDX-License-Identifier: GPL-3.0-or-later

ROOTDIR="$PWD"

# shellcheck disable=SC1091
. "$ROOTDIR"/.ci/common/project.sh

BUILDDIR="${BUILDDIR:-build}"
ARTIFACTS_DIR="$ROOTDIR/artifacts"
APP="${PROJECT_REPO}.app"

cd "$BUILDDIR/bin"

"$ROOTDIR"/.ci/macos/deploy.sh "$APP" "${PROJECT_REPO}"

codesign --deep --force --verbose --sign - "$APP"

# test
otool -L "$APP"/Contents/MacOS/"${PROJECT_REPO}"

OUTPUT="${PROJECT_PRETTYNAME}-macOS-${FORGEJO_REF}.tar.gz"

mkdir -p "$ARTIFACTS_DIR"
tar czf "$ARTIFACTS_DIR/$OUTPUT" "$APP"

echo "MacOS package created at $ARTIFACTS_DIR/$OUTPUT"
