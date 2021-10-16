#!/bin/bash

#Set this variable to the config folder path
CONFIGDIR=/home/test/IDUConfig

function updateIPV6 () {
    if [ "$CURRENTIPUSED" != "$CURRENTIPV6" ] ;then
            curl -X POST "https://$LOGIN:$PASSWORD@infomaniak.com/nic/update?hostname=$HOST&myip=$CURRENTIPV6"
    fi
}
function updateIPV4 () {
    if [ "$CURRENTIPUSED" != "$CURRENTIPV4" ] ;then
            curl -X POST "https://$LOGIN:$PASSWORD@infomaniak.com/nic/update?hostname=$HOST&myip=$CURRENTIPV4"
    fi
}

CURRENTIPV4=$(curl http://ifconfig.me)
CURRENTIPV6=$(curl Icanhazip.com)

for file in $CONFIGDIR/*.conf; do
    FILE=$(cat $file)
    
    IPV6=$(echo "$FILE" | awk '/^ipv6=/' | cut -d "=" -f2)
    LOGIN=$(echo "$FILE" | awk '/^login=/' | cut -d "=" -f2)
    PASSWORD=$(echo "$FILE" | awk '/^password=/' | cut -d "=" -f2)
    HOST=$(echo "$FILE" | awk '/^host=/' | cut -d "=" -f2)
    CURRENTIPUSED=$(getent hosts "$HOST" | awk '{ print $1 }')
    
    case $IPV6 in
    "1")
    updateIPV6
    ;;
    "2")
    updateIPV4
    updateIPV6
    ;;
    *)
    updateIPV4
    
    esac
done
