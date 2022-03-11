#!/bin/sh
set -x
set -e

ID=$1
shift
HOST=xaiki.net

test -z "$ID" && echo "usage: $0 id" && exit 

PRIVATE=$(wg genkey)
PUBLIC=$(echo "$PRIVATE" | wg pubkey)
HOSTIP=$(host $HOST | cut -d' ' -f4 | head -1)
ALLOWEDIPS=$(ssh root@$HOST wg | grep 'allowed ips' | cut -d':' -f2 | sed s/'\/.*'/''/g)
IP=$(echo "$ALLOWEDIPS" | grep '\.' | cut -d'.' -f 4 | sort -u | tail -1)
NIP=$(($IP + 1))

cat<<EOF > "${ID}.wg"
[Interface]
 Address = 10.0.0.$NIP/24
 Address = fd13:bea7::$NIP/64
 DNS = 1.1.1.1
 PrivateKey = $PRIVATE
[Peer]
 PublicKey = 0uxZKVoMS9nJZxFWQb2WssSNb6GCagNPlZKiY1+4qD4=
 AllowedIPs = 10.0.0.0/0, ::/0, 0.0.0.0/5, 8.0.0.0/7, 11.0.0.0/8, 12.0.0.0/6, 16.0.0.0/4, 32.0.0.0/3, 64.0.0.0/2, 128.0.0.0/3, 160.0.0.0/5, 168.0.0.0/6, 172.0.0.0/12, 172.32.0.0/11, 172.64.0.0/10, 172.128.0.0/9, 173.0.0.0/8, 174.0.0.0/7, 176.0.0.0/4, 192.0.0.0/9, 192.128.0.0/11, 192.160.0.0/13, 192.169.0.0/16, 192.170.0.0/15, 192.172.0.0/14, 192.176.0.0/12, 192.192.0.0/10, 193.0.0.0/8, 194.0.0.0/7, 196.0.0.0/6, 200.0.0.0/5, 208.0.0.0/4, 1.1.1.1/32
 Endpoint = $HOSTIP:51820
 PersistentKeepalive = 5
EOF

ssh "root@$HOST" wg set wg0 peer "$PUBLIC" allowed-ips "10.0.0.$NIP" persistent-keepalive 5
qrencode -t ansiutf8 < "${ID}.wg"
