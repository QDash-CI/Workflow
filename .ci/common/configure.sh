#!/bin/bash -e

# SPDX-FileCopyrightText: Copyright 2026 crueter
# SPDX-License-Identifier: GPL-3.0-or-later

# The master CMake configurator.
# Environment variables:
# - BUILDDIR: build directory (default build)
# - DEVEL: set to true to disable update checker and add "nightly" to app name
# - LTO: Turn LTO on/off (forced OFF on Windows)
# - TARGET: Change the build target (see targets.sh) -- Linux/clang-cl only

# - BUILD_TYPE: build type (default Release)
# - BUNDLE_QT: Use bundled Qt (default OFF)
# - USE_MULTIMEDIA: Enable Qt Multimedia (default OFF)
# - USE_WEBENGINE: Enable Qt WebEngine (default OFF)
# - CCACHE: Enable CCache (default OFF)

# shellcheck disable=SC1091

ROOTDIR="$PWD"
BUILDDIR="${BUILDDIR:-build}"
WORKFLOW_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# check if it's called eden dir
if [ ! -f "$ROOTDIR/CMakeLists.txt" ]; then
	echo "error: no CMakeLists.txt found in ROOTDIR ($ROOTDIR)."
	echo "Make sure you are running this script from the root of the QDash repository."
	exit 1
fi

# check if common script folder is on Workflow
if [ ! -d "$WORKFLOW_DIR/.ci/common" ]; then
	echo "error: could not find .ci/common in Workflow at $WORKFLOW_DIR"
	exit 1
fi

. "$WORKFLOW_DIR"/.ci/common/project.sh

# platform handling
. "$WORKFLOW_DIR"/.ci/common/platform.sh

# sdl/arch handling (targets)
. "$WORKFLOW_DIR"/.ci/common/targets.sh

# Flags all targets use
COMMON_FLAGS=(
	# build type
	-DCMAKE_BUILD_TYPE="${BUILD_TYPE:-Release}"

	# misc
	-DUSE_CCACHE="${CCACHE:-OFF}"

	# Static Linking
	-DQDASH_STATIC="${STATIC:-OFF}"

	# packaging stuff
	-DCMAKE_INSTALL_PREFIX=/usr

	# LTO
	-DENABLE_LTO="${LTO:-OFF}"
)

# cmd line stuff
EXTRA_ARGS=("$@")

if [ "$PLATFORM" = macos ]; then
	EXTRA_ARGS+=(-DMbedTLS_FORCE_BUNDLED=ON)
fi

# aggregate
CMAKE_FLAGS=(
	"${COMMON_FLAGS[@]}"
	"${SDL_FLAGS[@]}"
	"${ARCH_CMAKE[@]}"
	"${COMPILER_FLAGS[@]}"
	"${PLATFORM_FLAGS[@]}"
	"${EXTRA_ARGS[@]}"
)

echo "-- Configure flags: ${CMAKE_FLAGS[*]}"

cmake -S "$ROOTDIR" -B "$BUILDDIR" -G "Ninja" "${CMAKE_FLAGS[@]}"
