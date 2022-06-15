#!/bin/bash
#########################################################################################
# 
#   GET PEERS
#
#   Simple script to connect to a node's RPC and output all his peer it is connected to
#   in a format that can be used to attach another node to the same peers
#   This is usefull to deploy a new node and start a fast sync skipping the netword 
#   discovery phase
#
#   https://github.com/BlockChainCaffe/EVM_node_Scripts
#
#########################################################################################



if [[ -S /home/quadrans/.quadrans/gqdc.ipc ]]; then
    # echo "Node is runnint on MAINNET"
    cd /home/quadrans/.quadrans
    echo "## MAIN NET"
else 
	if [[ -S /home/quadrans/.quadrans/testnet/gqdc.ipc ]]; then
    		# echo "Node is running on TESTNET"
    		cd /home/quadrans/.quadrans/testnet
            echo "## TEST NET PUBLIC ENODES"
	else
		echo "Node is not active"
		exit
	fi
fi

FROM=$(mktemp)
TO=$(mktemp)

gqdc attach gqdc.ipc << EOF | grep enode > $FROM
admin.peers;
EOF
 
cat $FROM | sed "s:^    enode\: ::" | sed "s:^:admin.addPeer(:" | sed "s:,$:);:" | sed "s/:[^:]*\"/:28657\"/" > $TO

# Connectivity Test
for PEER in $(cat $TO)
do
    IP=$(echo $PEER | sed "s:^.*@::" | sed "s:\:.*$::")
    # port scan with netcat
    nc -z -w3 $IP 28657
    if [[ "$?" == "0" ]]; then
        echo $PEER
    fi
done

rm $FROM $TO