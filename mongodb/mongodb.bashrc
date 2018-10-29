export PS1='\u@\h:$PWD [$?]\$ '

export EDITOR=${EDITOR:-vim}

export CAI_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

export CC=/opt/mongodbtoolchain/v2/bin/gcc

export CXX=/opt/mongodbtoolchain/v2/bin/g++
export CXXFLAGS="-Werror=noexcept-type"

#export LD_LIBRARY_PATH="/opt/mongodbtoolchain/v2/lib"

export WORKSPACE=${WORKSPACE:-/workspace}
export GOROOT=${WORKSPACE}/goroot
export GITROOT=${WORKSPACE}/git
export PATH="/usr/local/sbin:$PATH"

# Local bin
export PATH="${HOME}/bin:$PATH"
export PKG_CONFIG_PATH="${HOME}/pkgconfig"

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

followCmd(){
  "${@}" || return $?
  for ARG; do true; done
  cd "$ARG"
}

# CCache/Icecream
export CCACHE_LOGFILE="${TMPDIR}/ccache.log"

# Scons
export SCONSFLAGS=""
SCONSFLAGS+="-j16 "
SCONSFLAGS+="ICECC=/usr/lib/icecream/bin/icecc "
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
