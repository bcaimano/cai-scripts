#!/bin/bash

MONGO_MODULES_DIR="${MONGO_MODULES_DIR:-./src/mongo/db/modules}"

MODULES="ninja"
if [[ -d "${MONGO_MODULES_DIR}/enterprise" ]]; then
    MODULES="${MODULES},enterprise"
fi

scons \
    MONGO_VERSION="0.0.0" MONGO_GIT_HASH="unknown" \
    VARIANT_DIR=ninja \
    CPPPATH=/usr/local/opt/openssl/include LIBPATH=/usr/local/opt/openssl/lib --ssl \
    --modules="${MODULES}" \
    build.ninja
