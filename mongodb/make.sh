#!/bin/bash

MONGO_MODULES_DIR="${MONGO_MODULES_DIR:-./src/mongo/db/modules}"

MODULES=""
if [[ -d "${MONGO_MODULES_DIR}/enterprise" ]]; then
    MODULES="${MODULES},enterprise"
fi

set -x

#CXXFLAGS+=" -Wno-class-memaccess"
CXXFLAGS+=" -fstack-check"

./buildscripts/scons.py \
    CXXFLAGS="${CXXFLAGS}" \
    MONGO_VERSION="0.0.0" MONGO_GIT_HASH="unknown" \
    CPPPATH=/usr/local/opt/openssl/include:/usr/include/openssl-1.0/ \
    LIBPATH=/usr/local/opt/openssl/lib:/usr/lib/openssl-1.0/ \
    --variables-files=etc/scons/mongodbtoolchain_v3_clang.vars \
    --ssl \
    VERBOSE=on \
    --link-model=dynamic \
    --install-mode=hygienic \
    --disable-warnings-as-errors \
    --modules="${MODULES}" \
    "${@}"
