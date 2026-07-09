#!/usr/bin/env bash

#
# 1. Copies a (source) project into this (destination) repository
# 2. Removes git from the (source) project
# 3. Optionally, deletes the (source) project
#
# Usage:
# ./copy-to-project.sh <path/to/project>
#

# Set defaults
set -o nounset -o errexit -o errtrace -o pipefail

# Directory of this script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Directory (root) of this repository
ROOT_DIR=$(realpath "${SCRIPT_DIR}/..")

# Check exactly 1 path was provided
if [[ "$#" -ne 1 ]]; then
  echo "Usage: $0 <path/to/project>" >&2
  exit 1
fi

# Check the source project exists
src=$(realpath -- "$1")
if [[ ! -e "${src}" ]]; then
  echo "Error: source does not exist: ${src}" >&2
  exit 1
fi

# Refuse a source that lives inside this repository
if [[ "${src}/" == "${ROOT_DIR}/"* ]]; then
  echo "Error: source is inside the repository: ${src}" >&2
  exit 1
fi

last_path_component=$(basename -- "${src}")
dst="${ROOT_DIR}/${last_path_component}"

# Refuse to overwrite an existing destination
if [[ -e "${dst}" ]]; then
  echo "Error: destination already exists: ${dst}" >&2
  exit 1
fi

# Copy the source project into this repository
echo "Copying ${src} -> ${dst}"
cp -R -- "${src}" "${dst}"

# Remove git from the copied project
find "${dst}" -name ".git" -prune -exec rm -rf -- {} +
find "${dst}" -type f -name ".gitmodules" -delete

# Prompt to delete the source project
read -rp "Delete (source) ${src}? [y/N] " answer
if [[ "${answer:-N}" =~ ^[Yy]$ ]]; then
  rm -rf -- "${src}"
  echo "Deleted ${src}"
else
  echo "Kept ${src}"
fi

echo "Done: ${dst}"
