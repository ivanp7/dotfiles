#!/bin/sh

[ "$#" -lt 3 ] && { echo "Too few arguments supplied."; exit 1; }

ARCHIVE_TYPE="$1"
ARCHIVE_NAME="$2"
shift 2

case "$ARCHIVE_TYPE" in
    tar|gz|xz|zstd|zip|7z) ;;
    *) echo "Unsupported archive type '$ARCHIVE_TYPE'."; exit 1 ;;
esac

tmpdir="$(mktemp -d -p .)"
cp -a -t "$tmpdir/" -- "$@"
cd "$tmpdir"

case "$ARCHIVE_TYPE" in
    tar|gz|xz|zstd)
        case "$ARCHIVE_TYPE" in
            tar) flag=""; ext="tar" ;;
            gz) flag="-z"; ext="tar.gz" ;;
            xz) flag="-J"; ext="tar.xz" ;;
            zstd) flag="--zstd"; ext="tar.zst" ;;
        esac
        tar cf "$ARCHIVE_NAME.$ext" $flag ./*
        ;;
    zip)
        ext="zip"
        zip -r "$ARCHIVE_NAME.$ext" ./*
        ;;
    7z)
        ext="7z"
        7z a "$ARCHIVE_NAME.$ext" ./*
        ;;
esac

mv -t ../ -- "$ARCHIVE_NAME.$ext"
cd ..
rm -rf "$tmpdir"

