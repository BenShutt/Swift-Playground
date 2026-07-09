#!/usr/bin/env bash

set -o nounset -o errexit -o errtrace -o pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PACKAGE_DIR=$(realpath "${SCRIPT_DIR}/..")
OUTPUT_FILE="${PACKAGE_DIR}/AppIcon.png"

swift run \
    --package-path "${PACKAGE_DIR}" \
    --configuration release \
    "AppIcon" "${OUTPUT_FILE}"
