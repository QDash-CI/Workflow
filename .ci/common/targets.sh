#!/bin/bash -e

# SPDX-FileCopyrightText: Copyright 2026 crueter
# SPDX-License-Identifier: GPL-3.0-or-later

# only clang and gcc support this
if [ -n "$SUPPORTS_TARGETS" ]; then
	case "$TARGET" in
		v3)
			echo "Making amd64-v3 optimized build of ${PROJECT_PRETTYNAME}"
			ARCH_FLAGS="-march=x86-64-v3 -mtune=generic"
			ARCH="amd64"
			;;
		steamdeck|zen2)
			echo "Making Steam Deck (Zen 2) optimized build of ${PROJECT_PRETTYNAME}"
			ARCH_FLAGS="-march=znver2 -mtune=znver2"
			ARCH="steamdeck"
			;;
		rog-ally|allyx|zen4)
			echo "Making ROG Ally X (Zen 4) optimized build of ${PROJECT_PRETTYNAME}"
			ARCH_FLAGS="-march=znver4 -mtune=znver4"
			ARCH="rog-ally-x"
			;;
		amd64|generic)
			echo "Making amd64 generic build of ${PROJECT_PRETTYNAME}"
			ARCH_FLAGS="-march=x86-64 -mtune=generic"
			ARCH=legacy
			;;
		aarch64|arm64)
			echo "Making armv8-a build of ${PROJECT_PRETTYNAME}"
			ARCH_FLAGS="-march=armv8-a -mtune=generic"
			ARCH=aarch64
			;;
		armv9)
			echo "Making armv9-a build of ${PROJECT_PRETTYNAME}"
			ARCH_FLAGS="-march=armv9-a -mtune=generic"
			ARCH=armv9
			;;
		native)
			echo "Making native build of ${PROJECT_PRETTYNAME}"
			ARCH_FLAGS="-march=native -mtune=native"
			;;
		*)
			echo "Invalid target $TARGET specified, must be one of: native, amd64, steamdeck, zen2, allyx, rog-ally, zen4, legacy, aarch64, armv9"
			exit 1
			;;
	esac

	ARCH_FLAGS="${ARCH_FLAGS} -O3"
	[ "$PLATFORM" = "linux" ] && ARCH_FLAGS="${ARCH_FLAGS} -pipe"
fi

[ -n "$ARCH_FLAGS" ] && ARCH_CMAKE+=(-DCMAKE_C_FLAGS="${ARCH_FLAGS}" -DCMAKE_CXX_FLAGS="${ARCH_FLAGS}")

export ARCH_CMAKE
export ARCH