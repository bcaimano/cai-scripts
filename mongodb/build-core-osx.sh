#!/bin/bash
set -xeuo pipefail

VENV_DIR="${HOME}/mongo_venv"
WORKSPACE="${HOME}/git-test"
MONGO_DIR="${WORKSPACE}/mongodb/mongo"
MODULES_DIR="${MONGO_DIR}/src/mongo/db/modules"
ENTERPRISE_DIR="${WORKSPACE}/10gen/mongo-enterprise-module"

if [[ $# -eq 0 ]]; then
    1>&2 echo "You really should provide at least one argument."
    exit 2
fi

# Get our dependencies via homebrew
brew install curl
brew install openssl

# Get the mongo repo
if [[ ! -d "${MONGO_DIR}" ]]; then
    mkdir -p "${MONGO_DIR}"
    git clone "git@github.com:mongodb/mongo" "${MONGO_DIR}"
fi
mkdir -p "${MODULES_DIR}"

# Get the enterprise module repo
if [[ ! -d "${ENTERPRISE_DIR}" ]]; then
    mkdir -p "${ENTERPRISE_DIR}"
    git clone "git@github.com:10gen/mongo-enterprise-modules" "${ENTERPRISE_DIR}"
fi

ln -snf "${ENTERPRISE_DIR}" "${MODULES_DIR}/enterprise"

# Make and activate a Python2 virtualenv
export VIRTUAL_ENV_DISABLE_PROMPT=1
if [[ ! -d ${VENV_DIR} ]]; then
    virtualenv --python python2 "${VENV_DIR}"
fi

. "${VENV_DIR}/bin/activate"
python2 -m pip install -r ${MONGO_DIR}/etc/pip/dev-requirements.txt

# Use scons in verbose mode with warnings allowed and 8 cpus
CMD=(
    python2
    "${MONGO_DIR}/buildscripts/scons.py"
    VERBOSE=on
    --disable-warnings-as-errors
    -j8
)

# Set the git hash and version to be obviously a devel build
CMD+=(
    MONGO_VERSION=0.0.0
    MONGO_GIT_HASH=unknown
)

# Use an optimized debug build
CMD+=(
    --opt=on
    --dbg=on
)

# Use homebrew clang and our extra include and lib paths for curl and openssl
CURL_DIR="$(brew --prefix curl)"
OPENSSL_DIR="$(brew --prefix openssl)"
CMD+=(
    CC="/usr/bin/clang"
    CXX="/usr/bin/clang++"
    CPPPATH="${OPENSSL_DIR}/include ${CURL_DIR}/include"
    LIBPATH="${OPENSSL_DIR}/lib ${CURL_DIR}/lib"
)

# Include tls/ssl and enterprise
CMD+=(
    --modules=enterprise
    --ssl
)

# Finally run the command with everything we've set up and our extra args
(
    cd "${MONGO_DIR}"
    "${CMD[@]}" "${@}"
)
