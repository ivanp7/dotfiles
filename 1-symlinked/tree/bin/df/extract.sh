#!/bin/sh
# (xkcd link: https://xkcd.com/1168/)

POSTFIX="-archive-contents"

for file in "$@"
do
    mime_type=$(file --mime-type "$file" -bLE) || mime_type=""
    [ -z "$mime_type" ] && continue

    contents_dir="$(basename "$file")$POSTFIX"
    file="$(realpath "$file")"
    mkdir "$contents_dir" &&
    cd "$contents_dir" &&
    case $mime_type in
        application/x-tar)
            tar xvf "$file" ;;
        application/x-bzip|application/x-bzip2)
            tar xvf "$file" -j ;;
        application/gzip)
            tar xvf "$file" -z ;;
        application/x-xz)
            tar xvf "$file" -J ;;
        application/zstd)
            tar xvf "$file" --zstd ;;
        application/zip|application/x-zip-compressed)
            unzip "$file" ;;
        application/x-7z-compressed|application/x-iso9660-image)
            7z x "$file" ;;
        application/vnd.rar)
            unrar x "$file" ;;
    esac &&
    cd ..
done

