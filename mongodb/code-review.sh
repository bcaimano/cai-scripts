#!/usr/bin/env bash

set -xe

if [[ -f ./buildscripts/clang_format.py ]]; then
true #    python2 ./buildscripts/clang_format.py format-my
fi

python2 `command -v upload.py` \
    --oauth2 \
    --no_oauth2_webbrowser \
    -H "mongodbcr.appspot.com" \
    \-y \
    --git_similarity=100 \
    "$@"
