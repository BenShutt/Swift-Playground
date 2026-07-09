#!/usr/bin/env bash

#
# Compiles and runs SwiftTime.swift with optimisation (-O)
#
# Usage:
# ./run.sh
#

set -o nounset -o errexit -o errtrace -o pipefail

# Directory of this script, so it can be invoked from anywhere
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

name="SwiftTime"
src="${SCRIPT_DIR}/${name}.swift"
build_dir="${SCRIPT_DIR}/.build"
bin="${build_dir}/${name}"

# Remove build output on exit (success or failure)
trap 'rm -rf -- "${build_dir}"' EXIT

# Compile with optimisation, then run
mkdir -p "${build_dir}"
swiftc -O "${src}" -o "${bin}"
"${bin}"
