#!/usr/bin/env bash

set -o nounset -o errexit -o errtrace -o pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PACKAGE_DIR=$(realpath "${SCRIPT_DIR}/..")
APP_DIR=$(realpath "${PACKAGE_DIR}/..")
OUTPUT_FILE="${APP_DIR}/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png"

swift run \
    --package-path "${PACKAGE_DIR}" \
    --configuration release \
    "AppIcon" "${OUTPUT_FILE}"
