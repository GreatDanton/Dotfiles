#!/bin/bash

# Script for checking if servers are up and displayed with conky

# ping server 
# Usage: checkServer ip/domain_name
function checkServer {
address=$1
serverPing=$(ping -c 1 $address) #ping server once

if [[ $? -eq 0 ]]; then # if last command (ping) exits with 0 == successful
    echo -n "\${color1}$address: [ "'${color green}'"OK" "\${color1}]"
else
    echo -n "\${color1}$address: [ "\${color2}"DOWN" "\${color1}]"
fi
echo
}

checkServer 192.168.1.10
