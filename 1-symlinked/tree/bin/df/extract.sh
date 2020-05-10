#!/bin/sh
# (xkcd link: https://xkcd.com/1168/)

FILE="$1"
POSTFIX="-archive-contents"

mime_type=$(file --mime-type "$FILE" -bLE) || mime_type=""
case $mime_type in
    application/*)
        case $(echo $mime_type | tail -c +13) in
            x-tar|x-bzip|x-bzip2|gzip|x-xz|zstd|zip|x-zip-compressed|x-7z-compressed|x-iso9660-image|vnd.rar) ;;
            *) continue
        esac
        ;;
    *) continue
esac

contents_dir="$(basename "$FILE")$POSTFIX"
mkdir "$contents_dir" || continue
cd "$contents_dir"
FILE="$(realpath "$FILE")"

case $(echo $mime_type | tail -c +13) in
    x-tar)
        tar xvf "$FILE" ;;
    x-bzip|x-bzip2)
        tar xvf "$FILE" -j ;;
    gzip)
        tar xvf "$FILE" -z ;;
    x-xz)
        tar xvf "$FILE" -J ;;
    zstd)
        tar xvf "$FILE" --zstd ;;
    zip|x-zip-compressed)
        unzip "$FILE" ;;
    x-7z-compressed|x-iso9660-image)
        7z x "$FILE" ;;
    vnd.rar)
        unrar x "$FILE" ;;
esac
cd ..

