#!/usr/bin/env bash
#
# Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
# Run SwiftLint over the SDK sources using the repo's .swiftlint.yml config.

set -euo pipefail

cd "$(dirname "$0")/.."

if ! command -v swiftlint >/dev/null 2>&1; then
  echo "swiftlint not found on PATH. Install via 'brew install swiftlint'." >&2
  exit 1
fi

swiftlint lint --config .swiftlint.yml
