#!/bin/sh
PATH=/usr/local/bin:/usr/local/sbin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin
# come from https://github.com/lpikora/bing-wallpaper-daily-mac-multimonitor

readonly SCRIPT=$(basename "$0")
readonly VERSION='1.0.0'
readonly RESOLUTIONS=(1920x1080 UHD)

setCron() {
cat <<EOF
setCron:
crontab -e
59 7 * * * cd $HOME/Pictures/ && ./bing-wallpaper.sh >/tmp/stdout.log 2>/tmp/stderr.log
EOF
}

usage() {
cat <<EOF
Usage:
  $SCRIPT [options]
  $SCRIPT -h | --help
  $SCRIPT --version

Options:
  -f --force                     Force download of picture. This will overwrite
                                 the picture if the filename already exists.
  -s --ssl                       Communicate with bing.com over SSL.
  -q --quiet                     Do not display log messages.
  -n --filename <file name>      The name of the downloaded picture. Defaults to
                                 the upstream name.
  -p --picturedir <picture dir>  The full path to the picture download dir.
                                 Will be created if it does not exist.
                                 [default: $HOME/Pictures/bing-wallpapers/]
  -r --resolution <resolution>   The resolution of the image to retrieve.
                                 Supported resolutions: ${RESOLUTIONS[*]}
  -h --help                      Show this screen.
  --version                      Show version.
EOF
}

print_message() {
    if [ ! "$QUIET" ]; then
        printf "%s\n" "${1}"
    fi
}

# Defaults
PICTURE_DIR="$HOME/Pictures/bing-wallpapers/"
RESOLUTION="1920x1080"

# Option parsing
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -r|--resolution)
            RESOLUTION="$2"
            shift
            ;;
        -p|--picturedir)
            PICTURE_DIR="$2"
            shift
            ;;
        -n|--filename)
            FILENAME="$2"
            shift
            ;;
        -f|--force)
            FORCE=true
            ;;
        -s|--ssl)
            SSL=true
            ;;
        -q|--quiet)
            QUIET=true
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --version)
            printf "%s\n" $VERSION
            exit 0
            ;;
        *)
            (>&2 printf "Unknown parameter: %s\n" "$1")
            usage
            exit 1
            ;;
    esac
    shift
done

# Set options
[ $QUIET ] && CURL_QUIET='-s'
[ $SSL ]   && PROTO='https'   || PROTO='http'

# Create picture directory if it doesn't already exist
mkdir -p "${PICTURE_DIR}"

# Parse bing.com and acquire picture URL(s)
FILEURL=( $(curl -sL https://cn.bing.com | \
    grep -Eo "th\?id=.*?.jpg" | \
    sed -e "s/tmb/$RESOLUTION/"))

FILENAME=${FILEURL/th\?id=/}

FILEWHOLEURL="$PROTO://cn.bing.com/$FILEURL"

if [ $FORCE ] || [ ! -f "$PICTURE_DIR/$FILENAME" ]; then
    find $PICTURE_DIR -type f -iname \*.jpg -delete
    print_message "Downloading: $FILENAME..."
    curl -Lo "$PICTURE_DIR/$FILENAME" "$FILEWHOLEURL"
else
    print_message "Skipping download: $FILENAME..."
fi
osascript -e 'tell application "System Events" to tell every desktop to set picture to "'$PICTURE_DIR/$FILENAME'"'
