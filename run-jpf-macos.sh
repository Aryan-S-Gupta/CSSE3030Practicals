#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
java8_home=${JAVA8_HOME:-"$repo_dir/.week4-tools/amazon-corretto-8.jdk/Contents/Home"}
z3_home=${Z3_HOME:-"$repo_dir/.week4-tools/z3-5.1.0-arm64-osx-13.3/bin"}

if [ ! -x "$java8_home/bin/java" ]; then
    java8_home=$(/usr/libexec/java_home -v 1.8 2>/dev/null || true)
fi
if [ ! -x "$java8_home/bin/java" ] || ! "$java8_home/bin/java" -version 2>&1 | grep -q '1\.8\.0'; then
    echo "JDK 8 not found. Run ./setup-week4-macos.sh first." >&2
    exit 1
fi
if [ ! -f "$z3_home/libz3java.dylib" ] || [ ! -f "$z3_home/libz3.dylib" ]; then
    echo "Z3 not found. Run ./setup-week4-macos.sh first." >&2
    exit 1
fi

# The official macOS archive refers to libz3.dylib without a search path.
if otool -L "$z3_home/libz3java.dylib" | grep -q '^[[:space:]]*libz3\.dylib'; then
    install_name_tool -change libz3.dylib @loader_path/libz3.dylib "$z3_home/libz3java.dylib"
fi

site_file=$(mktemp "${TMPDIR:-/tmp}/csse3030-jpf-site.XXXXXX")
trap 'rm -f "$site_file"' EXIT
printf 'jpf-core = %s\njpf-symbc = %s\nextensions = ${jpf-core},${jpf-symbc}\n' \
    "$repo_dir/jpf/jpf-core" "$repo_dir/jpf/jpf-symbc" > "$site_file"

cd "$repo_dir"
"$java8_home/bin/javac" -g Roots.java RootsDriver.java
"$java8_home/bin/java" -Xmx1024m -ea \
    -Djava.library.path="$z3_home" \
    -jar "$repo_dir/jpf/jpf-core/build/RunJPF.jar" \
    "+site=$site_file" Roots.jpf
