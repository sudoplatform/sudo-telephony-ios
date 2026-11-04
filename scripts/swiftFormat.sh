#!/usr/bin/env bash
#
# Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
# Run SwiftFormat over the SDK sources using the repo's .swiftformat config.

set -euo pipefail

cd "$(dirname "$0")/.."

if ! command -v swiftformat >/dev/null 2>&1; then
  echo "swiftformat not found on PATH. Install via 'brew install swiftformat'." >&2
  exit 1
fi

swiftformat . --config .swiftformat
