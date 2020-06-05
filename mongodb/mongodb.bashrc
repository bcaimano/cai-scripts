export PS1='- {ec:"$?",u:"\u",h:"\h",d:"\W",} $ '

export EDITOR=${EDITOR:-vim}

export CAI_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

export CFLAGS="-fPIC"
export CXXFLAGS="-fPIC"

export MAKEFLAGS="-j16"

export WORKSPACE=${WORKSPACE:-/workspace}
export GOPATH="${WORKSPACE}/goroot:${GOPATH:-}"
export GITROOT=${WORKSPACE}/git
export PATH="/usr/local/sbin:$PATH"

# Local bin
export PATH="${HOME}/bin:$PATH"
export PKG_CONFIG_PATH="${HOME}/pkgconfig"

# Node Global
export PATH="${HOME}/.npm-global/bin:$PATH"

# Icecream
if [[ -n ${ICECC_DIR} ]]; then
    export PATH="${ICECC_DIR}/bin:$PATH"
fi

# Maven
export PATH="/opt/apache-maven/bin:$PATH"
# Local dir
export PATH=":$PATH"

alias ll='ls -lah'
alias cf='./buildscripts/clang_format.py format'

STRANGER_DIR="$HOME/.stranger-dir"
function stranger(){
    ranger --choosedir=$STRANGER_DIR "$@" && EC=$?
    if [[ $EC -ne 0 ]]; then
        return $EC
    fi
    cd "$(cat $STRANGER_DIR)"
}

followCmd(){
  "${@}" || return $?
  for ARG; do true; done
  cd "$ARG"
}

# CCache/Icecream
export CCACHE_LOGFILE="${TMPDIR}/ccache.log"

# Scons
export SCONS_CACHE_SCOPE="shared"

# Githooks
export PUSH_THIS_BRANCH=yes

if [[ ${#EVG_CONFS[@]} -eq 0 ]]; then
    export EVG_CONFS="${HOME}/.evergreen.yml"
    EVG_CONFS="${EVG_CONFS}:${HOME}/.evergreen.yaml"
    EVG_CONFS="${EVG_CONFS}:${CAI_DIR}/mongodb.evergreen.yaml"
fi

ccache -o max_size=20G

if command -V pyenv >/dev/null; then
    eval "$(pyenv init -)"
fi

tailLess() {
    FILE="$1"
    shift
    >"${FILE}" 2>&1 "${@}"
    RC=$?
    less "${FILE}"
    return $RC
}

addLink() {
    ln -s "$(realpath $1)" ~/.sigil/
}

followLink() {
    cd "${HOME}/.sigil/$1"
}

_followLink() {
    OPTIONS=$(cd ~/.sigil; ls | grep "^$2" )
    COMPREPLY=($(compgen -W $OPTIONS))
}

complete -F _followLink followLink
