#!/usr/bin/env bash

#
# Script: mocks.sh
# Usage: ./mocks.sh
#
# Description:
# Generates mock files using SwiftyMocky.
#
# Installation:
# Install mint using the steps defined in the SwiftyMocky README:
# https://github.com/MakeAWishFoundation/SwiftyMocky
#

# Set defaults
set -o nounset -o errexit -o errtrace -o pipefail

# Directory of this script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Command that runs the swiftymocky binary
EXE="mint"

# Repository name for SwiftyMocky
SWIFTY_MOCKY="MakeAWishFoundation/SwiftyMocky"

# Check the executable exists
if ! [[ -x "$(command -v "${EXE}")" ]]; then
    echo "Command not found '${EXE}'." 1>&2
    echo "Please see the docs of $0 for installation steps." 1>&2
    exit 1
fi

# Update template file
"${SCRIPT_DIR}/update-mock-template.sh"

# Validate the setup 
"${EXE}" run "${SWIFTY_MOCKY}" doctor

# Generate the mocks
"${EXE}" run "${SWIFTY_MOCKY}" generate

# Print success
echo "Mocks generated successfully"
