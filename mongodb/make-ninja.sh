#!/bin/bash

unset SCONSFLAGS

MONGO_MODULES_DIR="${MONGO_MODULES_DIR:-./src/mongo/db/modules}"

MODULES="ninja"
if [[ -d "${MONGO_MODULES_DIR}/enterprise" ]]; then
    MODULES="${MODULES},enterprise"
fi

set -x
./buildscripts/scons.py \
    MONGO_VERSION="0.0.0" MONGO_GIT_HASH="unknown" \
    CC="${CC:-gcc}" CXX="${CXX:-g++}" \
    CXXFLAGS="-Wno-class-memaccess -gsplit-dwarf -fstack-check" \
    CPPPATH=/usr/local/opt/openssl/include:/usr/include/openssl-1.0/ \
    LIBPATH=/usr/local/opt/openssl/lib:/usr/lib/openssl-1.0/ \
    --ssl \
    VERBOSE=on \
    --link-model=dynamic \
    --icecream \
    --disable-warnings-as-errors \
    --modules="${MODULES}" \
    VARIANT_DIR=ninja \
    "${@}" \
    build.ninja
