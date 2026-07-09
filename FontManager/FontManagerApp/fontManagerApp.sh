#!/bin/bash -e

# Usage description if invalid arguments provided
usage() { echo "Usage: $ [-p <font directory path>]" 1>&2; exit 1; }

# Font file extension
EXTENSION=ttf

# URL to clone
CLONE_URL=https://github.com/BenCShutt/FontManager.git

# Name of the app to run
APP_NAME=FontManagerApp

# Base directory
BASE_DIRECTORY="$(pwd)"

# Directory to download into and work in, this will be removed in the clean
RUN_DIRECTORY_NAME=FMFiles

# Directory to clone into
CLONE_DIRECTORY=${BASE_DIRECTORY}/${RUN_DIRECTORY_NAME}

# Handle cases when there are no matching files
shopt -s nullglob

# Directory where the font files are locacted, by default use base directory.
# User may override with optional command line argument
FONT_DIRECTORY=${BASE_DIRECTORY}

# Handle any arguments provided
while getopts "p:" o; do
    case "${o}" in
        p)
            FONT_DIRECTORY=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1)) # Shift off the options and optional --.

# Check directory exists
if [ ! -d "${FONT_DIRECTORY}" ]; then
    echo "'${FONT_DIRECTORY}' directory does not exist" 1>&2;
    exit 1
fi

# Get the files of the valid extension type
FONT_FILES=( ${FONT_DIRECTORY}/*.${EXTENSION} )
if [ ${#FONT_FILES[@]} -eq 0 ]; then
    echo "No files matching extension: '${EXTENSION}' in directory: '${FONT_DIRECTORY}'" 1>&2;
    exit 1
fi

# Echo files
echo "Found the following '${EXTENSION}' files in '${FONT_DIRECTORY}':"
for file in "${FONT_FILES[@]}"; do
    echo "$file"
done

# Prepare clean up
function cleanup {
    echo "Cleaning process"
    rm -rf ${CLONE_DIRECTORY}
}

trap cleanup EXIT

# Clean and recreate
cleanup

# Download the files needed
git clone ${CLONE_URL} ${CLONE_DIRECTORY}
cd ${CLONE_DIRECTORY}/${APP_NAME}

# Run the app now it's downloaded! This will handle the rest
swift run ${APP_NAME} ${FONT_DIRECTORY}
