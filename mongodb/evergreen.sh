#!/bin/bash

set -euo pipefail

REAL_CONF="${HOME}/.evg.comp.yaml"
1>&2 echo "Using '${REAL_CONF}' as evergreen config..."
rm "${REAL_CONF}"

CONFS=()
IFS=":" read -ra CONFS <<< "${EVG_CONFS}"
for CONF in "${CONFS[@]}"; do
  cat "${CONF}" >> "${REAL_CONF}" || true
done

evergreen -c "${REAL_CONF}" "${@}"
