#!/bin/bash

MONGO_MODULES_DIR="${MONGO_MODULES_DIR:-./src/mongo/db/modules}"

MODULES=""
if [[ -d "${MONGO_MODULES_DIR}/enterprise" ]]; then
    MODULES="${MODULES},enterprise"
fi

./buildscripts/scons.py \
    --config=force \
    MONGO_VERSION="0.0.0" MONGO_GIT_HASH="unknown" \
    CC="${CC:-gcc}" CXX="${CXX:-g++}" \
    CPPPATH=/usr/local/opt/openssl/include:/usr/include LIBPATH=/usr/local/opt/openssl/lib:/usr/lib \
    VERBOSE=on \
    --disable-warnings-as-errors \
    --ssl \
    --modules="${MODULES}" \
    "${@}"
