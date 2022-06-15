#!/bin/bash
#########################################################################################
# 
#   SET PEERS
#
#   Simple script to connect a new TESTNET node to the network skipping the network 
#	discovery phase.
# 	Relies on the fact that the testnet explorer is constantly exporting a list of 
#	it's peers to a static web link by outputing the 'getPeers.sh' result to a file
#	This scripts read those info and passes it to the node.
#
#   https://github.com/BlockChainCaffe/EVM_node_Scripts
#
#########################################################################################

IPC=$(find . -type s | grep ipc)
DIR=$(dirname $IPC)
SOCK=$(basename $IPC)

if [[ $IPC == "" ]]; then
	echo "Node is not active"
	exit
fi

cd $DIR

PEERFILE=$(mktemp)
URL="https://faucetpage.testnet.quadrans.io/nodes/"
wget -O - $URL | grep -v "#" | sed "s:<br>::" > $PEERFILE
gqdc attach $SOCK < $PEERFILE
rm $PEERFILE
