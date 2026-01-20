#!/bin/sh -e

# SPDX-FileCopyrightText: Copyright 2026 crueter
# SPDX-License-Identifier: GPL-3.0-or-later

# platform handling

uname -s

LTO=ON
QT=OFF

# special case for Windows (FU microsoft)
if [ -n "$VCINSTALLDIR" ]; then
	PLATFORM=win
	QT=ON
	STATIC=ON
	[ "$COMPILER" = "clang" ] && SUPPORTS_TARGETS=ON

	# LTO is completely broken on MSVC
	LTO=off
else
	case "$(uname -s)" in
	Linux*)
		PLATFORM=linux
		SUPPORTS_TARGETS=ON
		QT=ON
		;;
	Darwin*)
		PLATFORM=macos
		STATIC=ON
		QT=ON
		export LIBVULKAN_PATH="/opt/homebrew/lib/libvulkan.1.dylib"
		;;
	CYGWIN* | MINGW* | MSYS*)
		PLATFORM=msys
		STATIC=ON
		SUPPORTS_TARGETS=ON
		QT=ON

		export PATH="$PATH:/mingw64/bin"

		# TODO: wtf is LTO doing
		LTO=off
		;;
	*)
		echo "Unknown platform $(uname -s)"
		exit 1
		;;
	esac
fi

export PLATFORM
export LTO
export SUPPORTS_TARGETS
export STATIC
export QT

# TODO(crueter): document outputs n such
