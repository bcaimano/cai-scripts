#!/bin/bash

MONGO_MODULES_DIR="${MONGO_MODULES_DIR:-./src/mongo/db/modules}"

MODULES="ninja"
if [[ -d "${MONGO_MODULES_DIR}/enterprise" ]]; then
    MODULES="${MODULES},enterprise"
fi

./buildscripts/scons.py \
    MONGO_VERSION="0.0.0" MONGO_GIT_HASH="unknown" \
    CC="${CC:-gcc}" CXX="${CXX:-g++}" \
    CXXFLAGS="-Wno-class-memaccess" \
    VARIANT_DIR=ninja \
    CPPPATH=/usr/local/opt/openssl/include LIBPATH=/usr/local/opt/openssl/lib --ssl \
    --link-model=dynamic \
    --icecream \
    --disable-warnings-as-errors \
    --modules="${MODULES}" \
    "${@}" \
    build.ninja
