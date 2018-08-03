#!/bin/bash

set -euo pipefail

# Evergreen expects your secret to be in the same file as all other configs.
# This is bad for sharing your config.
# So I keep the secret in the normal file and concatenate it with my true config
REAL_CONF="${HOME}/.evg.comp.yaml"
1>&2 echo "Using '${REAL_CONF}' as evergreen config..."
rm "${REAL_CONF}"

CONFS=()
IFS=":" read -ra CONFS <<< "${EVG_CONFS}"
for CONF in "${CONFS[@]}"; do
  cat "${CONF}" >> "${REAL_CONF}" 2>/dev/null || true
done

EVG_CMD=("evergreen" "-c" "${REAL_CONF}")

# An up-to-date evg cmd is a good thing
1>&2 echo "Checking for updates..."
"${EVG_CMD[@]}" get-update --install
"${EVG_CMD[@]}" "${@}"
