#!/usr/bin/env bash

set -e

python2 ./buildscripts/clang_format.py format-my

python2 `which upload.py` \
    --oauth2 \
    -H "mongodbcr.appspot.com" \
    \-y \
    --jira_user ben.caimano \
    --git_similarity=100 \
    "$@"
