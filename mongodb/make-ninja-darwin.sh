#!/bin/bash

MONGO_MODULES_DIR="${MONGO_MODULES_DIR:-./src/mongo/db/modules}"

MODULES="ninja"
if [[ -d "${MONGO_MODULES_DIR}/enterprise" ]]; then
    MODULES="${MODULES},enterprise"
fi

./buildscripts/scons.py \
    MONGO_VERSION="0.0.0" MONGO_GIT_HASH="unknown" \
    CC="/opt/mongodbtoolchain-darwin/v2/bin/clang" \
    CXX="/opt/mongodbtoolchain-darwin/v2/bin/clang++" \
    CCFLAGS="-mmacosx-version-min=10.11 -target x86_64-apple-darwin16.6.0" \
    LINKFLAGS="-mmacosx-version-min=10.11" \
    VARIANT_DIR=ninja \
    CPPPATH=/usr/local/opt/openssl/include \
    LIBPATH=/usr/local/opt/openssl/lib \
    --dbg=on \
    --icecream-env-dir=/Users/bencaimano/icecc-envs/ \
    --ssl \
    --link-model=object  \
    --icecream \
    --disable-warnings-as-errors \
    --modules="${MODULES}" \
    "${@}" \
    build.ninja
