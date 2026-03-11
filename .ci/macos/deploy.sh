#!/bin/sh -e

# Test script to deploy macOS deps.

APP="$1"
EXE="$2"

_frameworks="$APP"/Contents/Frameworks
mkdir -p "$_frameworks"

[ $# -ge 2 ] || { echo "usage: deploy.sh /path/to/app ExecutableName"; exit 1; }

# Exclude system frameworks and libraries
libs() {
	grep -v "/usr/lib" | grep -v "/System/Library/Frameworks" | tr -d '\t' | cut -d' ' -f1 | grep dylib
}

deploy() {
	_app="$1"
	LIBS="$(otool -L "$_app" | libs)"

	# TODO(crueter): Handle Frameworks and such
	for lib in $LIBS; do
		[ ! -f "$_frameworks/$lib" ] || continue

		_name="${lib##*/}"
		_path="@executable_path/../Frameworks/$_name"
		install_name_tool -id "$_path" "$_app"

		cp "$lib" "$_frameworks/$_name"

		deploy "$lib"
	done
}

deploy "$APP/Contents/MacOS/$EXE"