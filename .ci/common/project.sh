#!/bin/sh -e

# Common project variables

# Acceptable truthy values (any case): 1, true, yes, y, t, on
# Acceptable falsy values: anything else

# names
PROJECT_PRETTYNAME=QDash
PROJECT_REPO=QDash

# Is your project desktop only?
DISABLE_ANDROID=ON

# Does your project need optimized (e.g. PGO, Zen 2, etc) builds?
DISABLE_OPTS=ON

# Does your project need MinGW builds?
DISABLE_MINGW=ON

# Does your project need Debian builds?
DISABLE_DEBIAN=ON

# Does your project need MSVC/arm64 builds?
DISABLE_MSVC_ARM=OFF

# Does your project need to explain targets?
EXPLAIN_TARGETS=OFF

export PROJECT_PRETTYNAME
export PROJECT_REPO

export DISABLE_ANDROID
export DISABLE_OPTS
export DISABLE_DEBIAN
export DISABLE_MINGW
export DISABLE_MSVC_ARM

export EXPLAIN_TARGETS

truthy() {
	LOWER=$(echo "$1" | tr '[:upper:]' '[:lower:]')
	[ "$LOWER" = "true" ] || [ "$LOWER" = "on" ] || [ "$LOWER" = "1" ] || [ "$LOWER" = "t" ] || [ "$LOWER" = "yes" ] || [ "$LOWER" = "y" ]
}

falsy() {
	! truthy "$1"
}