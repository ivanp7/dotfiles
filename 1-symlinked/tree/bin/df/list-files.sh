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
        tar tvf "$f" ;;
    x-bzip|x-bzip2)
        tar tvf "$f" -j ;;
    gzip)
        tar tvf "$f" -z ;;
    x-xz)
        tar tvf "$f" -J ;;
    zstd)
        tar tvf "$f" --zstd ;;
    zip|x-zip-compressed)
        unzip -l "$f" ;;
    x-7z-compressed|x-iso9660-image)
        7z l "$f" ;;
    x-rar|vnd.rar)
        unrar l "$f" ;;
    x-cpio)
        bsdcpio -i -t -I "$f" ;;
esac

