#!/bin/sh -e

# Test script to deploy macOS deps.

APP="$1"
EXE="$2"

[ $# -ge 2 ] || {
	echo "usage: deploy.sh /path/to/app ExecutableName"
	exit 1
}

_frameworks="$APP"/Contents/Frameworks
mkdir -p "$_frameworks"

# Exclude system frameworks and libraries
libs() {
	grep -v "/usr/lib" | grep -v "/System/Library/Frameworks" | tr -d '\t' | cut -d' ' -f1 | grep dylib | grep -v ':' | grep -v 'executable_path' || :
}

deploy() {
	_app="$1"
	LIBS="$(otool -L "$_app" | libs)"

	echo "-- Walking $_app"

	# TODO(crueter): Handle Frameworks and such
	# walk thru deps...
	for lib in $LIBS; do
		echo "-- * $lib"

		# ignore otool's stupid id rules
		_name="${lib##*/}"
		_appname="${_app##*/}"
		if [ "$_name" = "$_appname" ]; then
			continue
		fi

		# then reset the dylib's path
		_path="@executable_path/../Frameworks/$_name"
		install_name_tool -change "$lib" "$_path" "$_app" 2>/dev/null

		[ -f "$_frameworks/$_name" ] || cp "$lib" "$_frameworks/$_name"

		# and change its internal structure
		install_name_tool -id "$_path" "$_frameworks/$_name" 2>/dev/null
	done

	for lib in $LIBS; do
		_name="${lib##*/}"
		_appname="${_app##*/}"
		if [ "$_name" = "$_appname" ]; then
			continue
		fi

		deploy "$_frameworks/$_name"
	done
}

deploy "$APP/Contents/MacOS/$EXE"

# Now strip if llvm is available
if brew --prefix llvm >/dev/null 2>&1; then
	echo "-- Stripping $APP data"

	_strip="$(brew --prefix llvm)/bin/llvm-strip"
	find "$APP" -type f | while read -r file; do
		set +e
		"${_strip}" "${file}" 2>/dev/null && echo "-- Stripped $file"
		set -e
	done
fi

codesign --deep --force --verbose --sign - "$APP"
