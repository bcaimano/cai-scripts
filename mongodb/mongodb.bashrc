export PS1='\u@\h:$PWD [$?]\$ '
export CXX=g++-7
export CC=gcc-7

alias ll='ls -lah'
alias cf='./buildscripts/clang_format.py format'

export CCACHE_LOGFILE="${TMPDIR}/ccache.log"
export SCONS_CACHE_SCOPE="shared"
