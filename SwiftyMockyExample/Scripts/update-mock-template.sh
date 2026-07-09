#!/usr/bin/env bash

#
# Script: update-mock-template.sh
# Usage: ./update-mock-template.sh
#
# Description:
# 1) Downloads Mock.swifttemplate from the remote.
# 2) Prefix @preconcurrency to import SwiftyMocky
#

# Set defaults
set -o nounset -o errexit -o errtrace -o pipefail

# Directory of this script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Remote URL to download file from
FROM_URL="https://raw.githubusercontent.com/MakeAWishFoundation/SwiftyMocky/master/Sources/SwiftyMocky/Mock.swifttemplate"

# Local URL to write file to
TO_URL="${SCRIPT_DIR}/../Tests/Mocks/Mock.swifttemplate"

# Download file from remote to local
curl -H 'Cache-Control: no-cache' "${FROM_URL}" -o "${TO_URL}"

# Since SwiftyMocky is not (yet) compatible with Swift 6,
# prefix @preconcurrency to import SwiftyMocky
sed -i '' 's/import SwiftyMocky/@preconcurrency import SwiftyMocky/g' "${TO_URL}"

# Print success
echo "$(basename "${TO_URL}") downloaded"
