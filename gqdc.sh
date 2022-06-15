#!/bin/bash
source /home/quadrans/environment
MINER_OPTS=""
STATS_OPTS=""
if [ "${MINER_OPTIONS}" = "true" ]; then
  MINER_OPTS="--mine --unlock ${MINER_WALLET} --password ${MINER_PASSWORD}"
fi
if [ $(grep -c "NODE_LISTED=true" /home/quadrans/environment ) -eq 1 ]; then
  # TESTNET
  STATS_OPTS=$(printf "%sethstats \"%s\":\"QuadransStatsNetwork\"@status.testnet.quadrans.io:3000" "--" "${NODE_NAME}")
  # MAINNET
  # STATS_OPTS=$(printf "%sethstats \"%s\":\"QuadransStatsNetwork\"@status.quadrans.io:3000" "--" "${NODE_NAME}")
fi

# TESTNET
eval "/usr/local/bin/gqdc ${GETH_PARAMS} --verbosity 5 --testnet ${MINER_OPTS} ${STATS_OPTS}"


# MAINNET
# eval "/usr/local/bin/gqdc ${GETH_PARAMS} --verbosity 2 ${MINER_OPTS} ${STATS_OPTS}"
