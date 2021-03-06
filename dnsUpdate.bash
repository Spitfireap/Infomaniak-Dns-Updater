#!/bin/bash

# Infomaniak DNS updater
# Written by Spitap
# Update your DynDNS with ease !
# Can easily be applied to every other provider using dyndns2 standard
#
#-------------------------------------CONFIGURATION-------------------------------------
#Set this variable to the config folder path, by default: /.../thisScript/IDUConfig
CONFIGDIR="$(dirname "$(readlink -f $0)")/IDUConfig"

#Advanced settings : if you want to get the IP another way, change this
CURRENTIPV4=$(curl -s https://ifconfig.me)
CURRENTIPV6=$(curl -s https://Icanhazip.com)
#----------------------------------------PROGRAM----------------------------------------
function UpdateIPV6 () {
    if [ "$CURRENTIPUSED" != "$CURRENTIPV6" ] ;then
        if [ "$VERBOSE" = "1" ]; then
            echo "Former ip ($CURRENTIPUSED) different from the new one ($CURRENTIPV6), setting up new one"
            curl -X POST "https://$LOGIN:$PASSWORD@infomaniak.com/nic/update?hostname=$HOST&myip=$CURRENTIPV6"
            echo "done"
        else
            curl -s -o /dev/null -X POST "https://$LOGIN:$PASSWORD@infomaniak.com/nic/update?hostname=$HOST&myip=$CURRENTIPV6"
        fi
    else 
        if [ "$VERBOSE" = "1" ]; then
            echo "IP ($CURRENTIPUSED) hasn't yet changed"
        fi
            
    fi
}
function UpdateIPV4 () {
    if [ "$CURRENTIPUSED" != "$CURRENTIPV4" ] ;then
        if [ "$VERBOSE" = "1" ]; then
            echo "Former ip ($CURRENTIPUSED) different from the new one ($CURRENTIPV4), setting up new one"
            curl -X POST "https://$LOGIN:$PASSWORD@infomaniak.com/nic/update?hostname=$HOST&myip=$CURRENTIPV4"
            echo "done"
        else
            curl -s -o /dev/null -X POST "https://$LOGIN:$PASSWORD@infomaniak.com/nic/update?hostname=$HOST&myip=$CURRENTIPV4"
        fi
    else 
        if [ "$VERBOSE" = "1" ]; then
            echo "IP ($CURRENTIPUSED) hasn't yet changed"
        fi
    fi
}

function Parser() {
    for file in $CONFIGDIR/*.conf; do
        if [ "$VERBOSE" = "1" ]; then
            echo "Currently looking to file $(basename $file)"
        fi
        
        FILE=$(cat $file)
        
        IPV6=$(echo "$FILE" | awk '/^ipv6=/' | cut -d "=" -f2)
        LOGIN=$(echo "$FILE" | awk '/^login=/' | cut -d "=" -f2)
        PASSWORD=$(echo "$FILE" | awk '/^password=/' | cut -d "=" -f2)
        HOST=$(echo "$FILE" | awk '/^host=/' | cut -d "=" -f2)
        
        case $IPV6 in
        "1")
        CURRENTIPUSED=$(host -t AAAA "$HOST" | awk '/has.*address/{print $NF}')
        UpdateIPV6
        ;;
        "2")
        CURRENTIPUSED=$(host -t A "$HOST" | awk '/has.*address/{print $NF}')
        UpdateIPV4
        CURRENTIPUSED=$(host -t AAAA "$HOST" | awk '/has.*address/{print $NF}')
        UpdateIPV6
        ;;
        *)
        CURRENTIPUSED=$(host -t A "$HOST" | awk '/has.*address/{print $NF}')
        UpdateIPV4
        esac
    done
}

function EchoHelp () {
    echo "Infomaniak DNS updater"
    echo "Update your DynDNS with ease !"
    echo "Usage:"
    echo "-v or -verbose : verbose mode"
    echo "-help or -h : help"
    echo "More information on configuration, etc here : https://github.com/Spitfireap/infomaniak-dns-updater"
}

for i in "$@"; do
    case $i in
    "-v"|"-verbose")
    VERBOSE="1"
    Parser
    shift
    ;;
    "-h"|"-help")
    EchoHelp
    shift
    ;;
    *)
    Parser
    break
    ;;
    esac
done
#---------------------------------------------------------------------------------------
