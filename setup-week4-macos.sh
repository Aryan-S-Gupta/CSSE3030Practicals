#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
tools_dir="$repo_dir/.week4-tools"
mkdir -p "$tools_dir"

if [ ! -x "$tools_dir/amazon-corretto-8.jdk/Contents/Home/bin/java" ]; then
    curl -fL --retry 3 \
        https://corretto.aws/downloads/latest/amazon-corretto-8-aarch64-macos-jdk.tar.gz \
        -o "$tools_dir/corretto8.tar.gz"
    tar -xzf "$tools_dir/corretto8.tar.gz" -C "$tools_dir"
fi

if [ ! -f "$tools_dir/z3-5.1.0-arm64-osx-13.3/bin/libz3java.dylib" ]; then
    curl -fL --retry 3 \
        https://github.com/Z3Prover/z3/releases/download/z3-5.1.0/z3-5.1.0-arm64-osx-13.3.zip \
        -o "$tools_dir/z3.zip"
    unzip -q -o "$tools_dir/z3.zip" -d "$tools_dir"
fi

if [ ! -f "$tools_dir/randoop-all-4.3.4.jar" ]; then
    curl -fL --retry 3 \
        https://github.com/randoop/randoop/releases/download/v4.3.4/randoop-all-4.3.4.jar \
        -o "$tools_dir/randoop-all-4.3.4.jar"
fi

"$tools_dir/amazon-corretto-8.jdk/Contents/Home/bin/java" -version
printf 'Week 4 tools are ready in %s\n' "$tools_dir"
