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

# CCache/Icecream
export CCACHE_LOGFILE="${TMPDIR}/ccache.log"

# Scons
export SCONSFLAGS="-j16"
export SCONS_CACHE_SCOPE="shared"

# Githooks
export PUSH_THIS_BRANCH=yes

if [[ ${#EVG_CONFS[@]} -eq 0 ]]; then
    export EVG_CONFS="${HOME}/.evergreen.yml"
    EVG_CONFS="${EVG_CONFS}:${HOME}/.evergreen.yaml"
    EVG_CONFS="${EVG_CONFS}:${CAI_DIR}/mongodb.evergreen.yaml"
fi

ccache -o max_size=20G
