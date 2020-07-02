#!/bin/sh

FILE="$1"

mime_type=$(file --mime-type "$FILE" -bLE) || mime_type=""
case $mime_type in
    application/*)
        case $(echo $mime_type | tail -c +13) in
            x-tar|x-bzip|x-bzip2|gzip|x-xz|zstd|zip|x-zip-compressed|x-7z-compressed|x-iso9660-image|x-rar|vnd.rar) ;;
            *) continue
        esac
        ;;
    *) continue
esac

case $(echo $mime_type | tail -c +13) in
    x-tar)
        tar tvf "$FILE" ;;
    x-bzip|x-bzip2)
        tar tvf "$FILE" -j ;;
    gzip)
        tar tvf "$FILE" -z ;;
    x-xz)
        tar tvf "$FILE" -J ;;
    zstd)
        tar tvf "$FILE" --zstd ;;
    zip|x-zip-compressed)
        unzip -l "$FILE" ;;
    x-7z-compressed|x-iso9660-image)
        7z l "$FILE" ;;
    x-rar|vnd.rar)
        unrar l "$FILE" ;;
    x-cpio)
        bsdcpio -i -t -I "$FILE" ;;
esac

