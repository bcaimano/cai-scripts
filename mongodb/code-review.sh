#!/usr/bin/env bash

upload.py \
    --oauth2 \
    -H "mongodbcr.appspot.com" \
    \-y \
    --check-clang-format \
    --jira_user ben.caimano \
    --git_similarity=100 \
    "$@"
