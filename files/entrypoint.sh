#!/usr/bin/env bash
set -e -o pipefail

echo "$CRON root bash --login -c 'ORGANIZATIONS=\"${ORGANIZATIONS}\" \
    REPOSITORIES=\"${REPOSITORIES}\" TOKEN=\"${TOKEN}\" github-actions-keep-alive.py \
    > /proc/1/fd/1 2>&1'" \
    > /media/cron/github-actions-keep-alive

/entrypoint.sh "$@"
