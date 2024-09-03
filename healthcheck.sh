#!/usr/bin/env bash
set -e -o pipefail

curl --fail http://localhost/ || exit 1
