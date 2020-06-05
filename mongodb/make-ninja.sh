#!/bin/bash

set -x

MONGO_CUSTOM_VARS="${HOME}/.scons/site_scons/mongo_custom_variables.py"
ADD_CUSTOM_VARS=${ADD_CUSTOM_VARS:-no}

USE_V3_TOOLCHAIN=${USE_V3_TOOLCHAIN:-yes}
INCLUDE_DIR="/opt/mongodbtoolchain/v3/include"
TOOLCHAIN_STEM="etc/scons/mongodbtoolchain_v3"
if [[ $USE_V3_TOOLCHAIN != yes ]]; then 
    INCLUDE_DIR="/opt/mongodbtoolchain/v2/include"
    TOOLCHAIN_STEM="etc/scons/mongodbtoolchain_stable"
fi

BRANCH_NAME="$(git rev-parse --abbrev-ref HEAD)"
ROOT_DIR="$(cd "$(git rev-parse --git-common-dir)"; cd ..; pwd)"

USE_GCC="${USE_GCC:-yes}"
if [[ $USE_GCC == yes ]]; then
    #CXXFLAGS+=" -Wno-class-memaccess"
#    CXXFLAGS+=" -Wno-redundant-move"
    CXXFLAGS+=" -I${INCLUDE_DIR}"
    if [[ $USE_V3_TOOLCHAIN == yes ]]; then
        CXXFLAGS+=" -Wno-noexcept-type"
#        CXXFLAGS+=" -Wno-redundant-move"
    fi
#    CXXFLAGS+=" -fno-var-tracking"
    VAR_FILE="${TOOLCHAIN_STEM}_gcc.vars"
else
    VAR_FILE="${TOOLCHAIN_STEM}_clang.vars"
fi
CXXFLAGS+=" -fstack-check"

if [[ $ADD_CUSTOM_VARS == yes ]]; then
    VAR_FILE="${MONGO_CUSTOM_VARS} ${VAR_FILE}"
fi

ARGS=()
USE_VAR_FILE="${USE_VAR_FILE:-yes}"
if [[ $USE_VAR_FILE == yes && -n $VAR_FILE ]]; then
    ARGS+=(
        "--variables-files=${VAR_FILE}"
    )
fi

ARGS+=(
    #CXXFLAGS="${CXXFLAGS}"
    #LINKFLAGS="${LDFLAGS}"
    #VERBOSE=on
)

BUILD_ROOT=/workspace/build
ARGS+=(
    --ssl
    --disable-warnings-as-errors
    # --build-dir="${BUILD_ROOT}"
    # --implicit-cache
    --cache
    --cache-dir="${BUILD_ROOT}/cache"
)

USE_HYGIENIC="${USE_HYGIENIC:-${USE_V3_TOOLCHAIN}}"
if [[ $USE_NINJA == yes ]]; then
    ARGS+=(
        --icecream
         MONGO_VERSION=0.0.0 MONGO_GIT_HASH=unknown
    )
else
    #ICECC="$(command -v icecc)"
    #ARGS+=(
    #    "ICECC=$ICECC"
    #)

    if [[ $USE_HYGIENIC == yes ]]; then
        ARGS+=(
            --install-mode=hygienic
            --jlink=4
        )
    fi
fi

ARGS+=(
    "${@}"
)

echo "Started: $(date +'%T')"
RC=0
function runScons() {
    PYTHON_CMD=(
        python
    )

    if [[ ${PROFILE_PYTHON:-no} == yes ]]; then
        PYTHON_CMD+=(
            -m cProfile -o profile.out
        )
    fi

    PYTHON_CMD+=(
        ./buildscripts/scons.py
    )
    1>build.out 2>build.err "${PYTHON_CMD[@]}" "${ARGS[@]}"
    RC=$?
    return $RC
}

if !(runScons); then
    less build.err
fi

echo "Finished: $(date +'%T')"

exit $RC 
