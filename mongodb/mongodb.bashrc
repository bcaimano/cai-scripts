export PS1='\u@\h:$PWD [$?]\$ '

export CC=/opt/mongodbtoolchain/v2/bin/gcc

export CXX=/opt/mongodbtoolchain/v2/bin/g++
export CXXFLAGS="-Werror=noexcept-type"

#export LD_LIBRARY_PATH="/opt/mongodbtoolchain/v2/lib"

export PATH="/usr/local/sbin:$PATH"

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

export CCACHE_LOGFILE="${TMPDIR}/ccache.log"
export SCONS_CACHE_SCOPE="shared"

ccache -o max_size=20G
