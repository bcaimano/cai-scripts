#!/bin/bash

YCSB_DIR="${HOME}/git/mongodb-labs/YCSB/ycsb-mongodb"

ACTION=$1
THREADS=$2
WORKLOAD=$3

${YCSB_DIR}/bin/ycsb ${ACTION} mongodb -threads ${THREADS} -s -P ${YCSB_DIR}/workloads/${WORKLOAD}
