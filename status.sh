# Colors
# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[0;33m'
BLUE='\033[1;34m'
PURPLE='\033[0;35m'
PURPLE2='\033[1;35m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# Get IPC Socket
SOCK=$(find . -type s -name '*.ipc' | head -1)
if [[ "$SOCK" == "" ]]; then
    echo -e "${RED} 🟥 Can't connect to socket. Check if node is running${NC}"
    exit
fi

# Send IPC command to node
ipc() {
    if [[ "$2" == "" ]]; then
        SF="IMPOSSIBLESTRING"
        echo $1 | gqdc attach $SOCK 2>/dev/null
    else
        echo $1 | gqdc attach $SOCK 2>/dev/null | grep $2 | sed "s/^. *"$2"//" | xargs
    fi
}

# Gather values
VERSION=$(ipc 'admin.nodeInfo' 'name:'| tr -d ',')
DATADIR=$(ipc 'admin.datadir' | tail -2 | head -1)
IP=$(ipc 'admin.nodeInfo' 'ip:')
BLOCK=$(ipc 'eth.getBlock("latest")' 'number:' | tr -d ',')
SYNC=$(ipc 'eth.syncing' | tail -2 | head -1)
TSTAMP=$(ipc 'eth.getBlock("latest")' 'timestamp:' | tr -d ',')
DELTA=$(( $(date +%s) - $TSTAMP ))
PEERS=$(ipc 'net.peerCount' | tail -2 | head -1)

## Conditional formatting

CFNET=$PURPLE2'🔥'
if [[ $(echo $SOCK | grep 'testnet' ) ]]; then
    CFNET=$BLUE'🎲'
    # CFNET=$PURPLE2'🔥'
fi

CFDATE=$GREEN'✅'
if (( $DELTA > 30 )) ; then
    CFDATE=$YELLOW'🟡'
fi
if (( $DELTA > 600 )) ; then
    CFDATE=$RED'💀'
fi

CFPEER=$GREEN'✅'
if (( $PEERS < 5 )); then
    CFPEER=$RED'🟥'
fi
if (( $PEERS < 10 )); then
    CFPEER=$YELLOW'🟡'
fi

CFBLCK=$GREEN'🏁'
if [[ "$SYNC" != "false" ]]; then
    CFBLCK=$YELLOW'⏳'
    SYNC=$(ipc 'eth.syncing' 'currentBlock:')' / '$(ipc 'eth.syncing' 'highestBlock:')
else
    SYNC=''
fi

# Print values
echo -e "${WHITE}═══════════════════════════════════════════════════════════════════"
echo -e "${WHITE}  Version:   \t${PURPLE2} "$VERSION
echo -e "${GRAY}───────────────────────────────────────────────────────────────────"
echo -e "${WHITE}  Socket:    \t${CFNET} "$SOCK
echo -e "${WHITE}  Data dir:  \t${CFNET} "$DATADIR
echo -e "${GRAY}───────────────────────────────────────────────────────────────────"
echo -e "${WHITE}  Block:     \t${CFBLCK} "$BLOCK" "$SYNC
echo -e "${WHITE}  Timestamp: \t${CFDATE} "$(date -d @$TSTAMP)" ( -"$DELTA")"
echo -e "${WHITE}  Peers:     \t${CFPEER} "$PEERS
echo -e "${GRAY}───────────────────────────────────────────────────────────────────"
echo -e "${NC}"
