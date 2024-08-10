#!/bin/bash

# Alexander J Rapino
# August 10th 2024
# CYB 300

# The Goal:
#   Use the Ping utility to report connections of all IP addresses 
#   that end in an odd number in the network, and output them to a 
#   text file called ping.txt

# Color Variables 
# https://dev.to/ifenna__/adding-colors-to-bash-scripts-48g4
Red=$'\e[1;31m'
Green=$'\e[1;32m'
Blue=$'\e[1;34m'
PURPLE=$'\e[1;35m'
WHITE=$'\e[0;97m'
CYAN=$'\e[0;36m'
BROWN=$'\e[0;33m'

# This will print basically a "I am running banner" to the user so
# the user knows the script is running properly.
function on_run_print(){ 
    echo -e "[${CYAN}*${WHITE}] Welcome to odd ping sweep!" 
    echo -e "[${CYAN}*${WHITE}] This tool pings all the odd-numbered ip addresses, and exports the results to ping.txt"
    echo -e "[${Red}!${WHITE}] WARNING: This tool is reccomended only for /24 or smaller networks."
    return
}

# This function does a for loop through .1-.255 (all valid in /24 and smaller networks)
function get_odd_ips(){
    echo -e "[${Green}+${WHITE}] Proceeding with $1 as the base IP" # telling the user proceding with the base IP
    echo -e "[${Green}+${WHITE}] Path to ping.txt : ${2}ping.txt" # telling the user the path to ping.txt
    local base=$1  # setting local variable for base ip
    local pth="${2}ping.txt" # setting path for ping.txt
    local hup=() # array for hosts thaat are up
    local hdn=() # array for hosts that are down
    local dt=$(date)
    echo -e "------------ START $dt ------------" >> $pth # Echo scan start to path
    for i in {1..255..2} # iteratting through 1-255 stepping every 2 getting all odd number ie 1+2=3
    do
        echo -e "[${BROWN}*${WHITE}] Trying $1$i..." # Telling the user we are attempting an IP
        ping -c 1 $1$i >> $pth # Send the results of the ping to ping.txt
        
        # From the ping man page:
        # If ping does not receive any reply packets at all it will exit with code 1. If a packet count and deadline are both
        # specified, and fewer than count packets are received by the time the deadline has arrived, it will also exit with code 1. On
        # other error it exits with code 2. Otherwise it exits with code 0. This makes it possible to use the exit code to see if a
        # host is alive or not.

        if [ $? == 0 ] # if the status code of the ping == 0 (getting a reply) tell the user
        then
            echo -e "[${Green}+${WHITE}] Host up: ${PURPLE}$1$i${WHITE}"
            hup+=("$1$i")
        else # if any other status assume host down
            echo -e "[${Red}!${WHITE}] Host down: ${Red}$1$i${WHITE}"
            hdn+=("$1$i")
        fi
    done
    echo -e "------------ QUICK SUMMARY ------------" >> $pth # quick summary of hosts
    echo -e "Unavailable Hosts: ${hdn[@]}" >> $pth # put unavailable hosts in the quick summary
    echo -e "Available Hosts: ${hup[@]}" >> $pth # put available hosts in the quick summary
    echo -e "------------ END QUICK SUMMARY ------------" >> $pth # end quick summary
    echo -e "------------ END $dt ------------" >> $pth # end scan totality
}

function main(){
    on_run_print
    read -p "${CYAN}Enter base IP (ending with a . example: 192.168.7.)>>${WHITE} " CHOICE
    read -p "${CYAN}Enter the path (with / at the end) you want to save ping.txt (/home/user/)>>${WHITE} " PTH
    get_odd_ips "$CHOICE" "$PTH"
}

main