# EVM Node Scripts for Quadrans

This is a set of scripts that might result usefull in setting up and mantaing a EVM/Geth based node.
It's strongly built on **Quadrans** blockchain (quadrans.io, https://github.com/quadrans) but might be used on other **geth** based blockchain like:
- Ethereum
- Ethereum classic
- CELO
- BSC
- ...

## Installation of the node

- **environment**: simple bash script that contains the environment variables to be used by the gqdc.sh script
- **gqdc.sh**: strartup script used by quadrans-node.service
- **quadrans-node.service**: systemd / systemctl script that starts the service 

##### Installation Steps

- create a /home/quadrans direcshtory and the quadrans system user
- checkout all files in this directory
- create the /home/quadrans/bin directory
- download the last version of the **gqdc** binary from https://repo.quadrans.io
- create a simlink in /user/local/bin to gqcd
- edit environment and gqdc.sh as neede
- **beware of different main-net / test-net settings**
- copy quadrans-node.service in /etc/systemd/system
- run :

```
systemctl daemon-reload
systemctl enable quadrans-node.service
systemctl status quadrans-node.service
systemctl start quadrans-node.service
```

## Peer Management
- **getPeers.sh** : script to output all the public peers a node is connected to
- **setPeers.sh** : gets a list of public network nodes from another node and connects to the same peers. **Testnet Only**

## Status

  * **status.py** is a simple python script that allows you to gave some info and stats about how your node is behaving.

#### Install & Usage

- install the dependecies:

```
sudo apt update
sudo apt install python3-pip python3-dev
sudo pip3 install wheel setuptools termcolor datetime rlp 'web3>=5.25.0' pyfiglet
```
- run :

```
root@mainnet:/home/quadrans# ./status.py 
  ___                  _                       _   _           _      
 / _ \ _   _  __ _  __| |_ __ __ _ _ __  ___  | \ | | ___   __| | ___ 
| | | | | | |/ _` |/ _` | '__/ _` | '_ \/ __| |  \| |/ _ \ / _` |/ _ \
| |_| | |_| | (_| | (_| | | | (_| | | | \__ \ | |\  | (_) | (_| |  __/
 \__\_\\__,_|\__,_|\__,_|_|  \__,_|_| |_|___/ |_| \_|\___/ \__,_|\___|
                                                                      

Provider:		IPC (MainNet: /home/quadrans/.quadrans/gqdc.ipc)
Connected:		  OK !  
Peer Connections:	   14   
Syncing:		  100%  
Block Number:		20661405 (2022-06-15 06:29:54 / 1 seconds ago)
Software Version:	gqdc/v1.5.2-stable-53b6a36d/linux-amd64/go1.13.4
Protocol Version:	63
Chain ID:		10946
Net Version:		1

```

