#!/bin/sh
# (xkcd link: https://xkcd.com/1168/)

POSTFIX="-archive-contents"

for file in "$@"
do
    mime_type=$(file --mime-type "$file" -bLE) || mime_type=""
    case $mime_type in
        application/*)
            case $(echo $mime_type | tail -c +13) in
                x-tar|x-bzip|x-bzip2|gzip|x-xz|zstd|zip|x-zip-compressed|x-7z-compressed|x-iso9660-image|vnd.rar) ;;
                *) continue
            esac
            ;;
        *) continue
    esac

    contents_dir="$(basename "$file")$POSTFIX"
    mkdir "$contents_dir" || continue
    cd "$contents_dir"
    file="$(realpath "$file")"

    case $(echo $mime_type | tail -c +13) in
        x-tar)
            tar xvf "$file" ;;
        x-bzip|x-bzip2)
            tar xvf "$file" -j ;;
        gzip)
            tar xvf "$file" -z ;;
        x-xz)
            tar xvf "$file" -J ;;
        zstd)
            tar xvf "$file" --zstd ;;
        zip|x-zip-compressed)
            unzip "$file" ;;
        x-7z-compressed|x-iso9660-image)
            7z x "$file" ;;
        vnd.rar)
            unrar x "$file" ;;
    esac
    cd ..
done

