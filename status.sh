# Get IPC Socket
SOCK=$(find . -type s -name '*.ipc' | head -1)

# Send IPC command to node
ipc() {
    if [[ "$2" == "" ]]; then
        SF="IMPOSSIBLESTRING"
        echo $1 | gqdc attach $SOCK
    else
        echo $1 | gqdc attach $SOCK | grep $2 | sed "s/^. *"$2"//" | xargs
    fi
}

# Gather values
VERSION=$(ipc 'admin.nodeInfo' 'name:'| tr -d ',')
DATADIR=$(ipc 'admin.datadir' | tail -2 | head -1)
IP=$(ipc 'admin.nodeInfo' 'ip:')
BLOCK=$(ipc 'eth.getBlock("latest")' 'number:' | tr -d ',')
TSTAMP=$(ipc 'eth.getBlock("latest")' 'timestamp:' | tr -d ',')
PEERS=$(ipc 'net.peerCount' | tail -2 | head -1)

# Print values
echo -e "Socket:    \t"$SOCK
echo -e "Data dir:  \t"$DATADIR
echo -e "Version:   \t"$VERSION
echo -e "Block:     \t"$BLOCK
echo -e "Timestamp: \t"$(date -d @$TSTAMP)" ( -" $(( $(date +%s) -$TSTAMP)) ")"
echo -e "Peers:     \t"$PEERS
