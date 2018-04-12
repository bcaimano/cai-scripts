#!/bin/bash

BASE_DIR="/data/replset"

run_mongod() {
    ADDR=$1
    PORT=$2
    ROLE=$3
    REPL=$4

    SUB_DIR="mongod-${PORT}"
    DB_DIR="${BASE_DIR}/${SUB_DIR}"

    mkdir -p "${DB_DIR}/db"

    mongod --fork \
        --bind_ip="${ADDR}" --port="${PORT}" --replSet="${REPL}" \
        --dbpath="${DB_DIR}/db" \
        --logpath="${DB_DIR}/db.log" \
        --pidfilepath="${DB_DIR}/db.pid"

    DBSUB="${ADDR}:${PORT}"
}

make_set(){

run_mongod 127.0.0.1 27021 "" rs
run_mongod 127.0.0.1 27022 "" rs
run_mongod 127.0.0.1 27023 "" rs

sleep 1

mongo --host "127.0.0.1:27021" << EOF
rs.initiate( {
    _id : "rs",
    members: [
        { _id: 0, host: "127.0.0.1:27021" },
        { _id: 1, host: "127.0.0.1:27022" },
        { _id: 2, host: "127.0.0.1:27023" }
    ]
})
EOF

CONFIGDB="rs/127.0.0.1:27021,127.0.0.1:27022,127.0.0.1:27023"

SUB_DIR="mongos"
DB_DIR="${BASE_DIR}/${SUB_DIR}"

mkdir -p "${DB_DIR}"

mongos --fork \
    --bind_ip=127.0.0.1  --configdb="${CONFIGDB}" \
    --logpath="${DB_DIR}/db.log" \
    --pidfilepath="${DB_DIR}/db.pid"
}
