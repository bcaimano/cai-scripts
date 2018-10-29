#!/usr/bin/env bash

set -e

if [[ -f ./buildscripts/clang_format.py ]]; then
    python2 ./buildscripts/clang_format.py format-my
fi

python2 `which upload.py` \
    --oauth2 \
    -H "mongodbcr.appspot.com" \
    \-y \
    --jira_user ben.caimano \
    --git_similarity=100 \
    "$@"
