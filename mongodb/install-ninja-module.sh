#!/bin/bash

set -e

MONGO_MODULES_DIR="${MONGO_MODULES_DIR:-./src/mongo/db/modules}"
NINJA_MODULE_DIR="${NINJA_MODULE_DIR:-${HOME}/git/bcaimano/mongo_module_ninja}"
NINJA_MODULE_URL="${NINJA_MODULE_URL:-git@github.com:bcaimano/mongo_module_ninja.git}"

if [[ ! -d "${NINJA_MODULE_DIR}" ]]; then
    git clone "${NINJA_MODULE_URL}" "${NINJA_MODULE_DIR}/"
fi

mkdir -vp "${MONGO_MODULES_DIR}"
ln -vsf "${NINJA_MODULE_DIR}" "${MONGO_MODULES_DIR}/ninja"
