#!/bin/bash

# Alexander J Rapino
# August 10th 2024
# CYB 300

# The Goal:
#   Create three groups: Human Resources, Finance, and Sales. 
#   Create 12 user accounts and place them in one of the three groups. 
#   Set the passwords to NewP@$$w0rd

# Color Variables 
# https://dev.to/ifenna__/adding-colors-to-bash-scripts-48g4
RED=$'\e[1;31m'
GREEN=$'\e[1;32m'
BLUE=$'\e[1;34m'
PURPLE=$'\e[1;35m'
WHITE=$'\e[0;97m'
CYAN=$'\e[0;36m'
BROWN=$'\e[0;33m'

# This will print basically a "I am running banner" to the user so
# the user knows the script is running properly.
function on_run_print(){ 
    echo -e "[${CYAN}*${WHITE}] Welcome to user/group add!" 
    echo -e "[${CYAN}*${WHITE}] This tool creates 3 groups, HR, Finance and sales."
    echo -e "[${CYAN}*${WHITE}] This then creates 12 user accounts and distributes them to the 3 created groups"
    echo -e "[${CYAN}*${WHITE}] The default password for these accounts is NewP@\$\$w0rd"
    return
}

function create_groups(){
    local grps=("Human_Resources" "Finance" "Sales") # Linux doesnt like spaces in group names therefore the _
    for i in "${grps[@]}" # Iterate through the above groups
    do
        sudo groupadd "$i" # Add Group
        if [ $? == 0 ] # If groupadd successful then tell the user
        then
                echo -e "[$GREEN+$WHITE] $i Group added sucessfully!"
        else
                # Letting the user know that if the status code failed with a 9 the groups exists according to the
                # man pages
                echo -e "[$RED!$WHITE] $i Failed to be added statuscode $? *if status code 9 group probably exists."
        fi
    done
}

function add_users(){
    local grps=("Human_Resources" "Finance" "Sales")
    for i in {1..12}
    do
        local rnum=$(($RANDOM%(2-0+1)+0))  # generate a random number for random group every time it loops
        sudo useradd -m -p "NewP@ssw0rd" -g ${grps[$rnum]}  "tmp_usr_$i" # add user with specified params
        if [ $? == 0 ] # Checking statuscode of useradd
        then
                echo -e "[$GREEN+$WHITE] User tmp_usr_$i:${grps[$rnum]} home at: /home/tmp_usr_$i added sucessfully!"
        else
                echo -e "[$RED!$WHITE] User tmp_usr_$i:${grps[$rnum]} home at: /home/tmp_usr_$i was not added successfuly, statuscode: $?"
        fi
    done
}

function main(){
    on_run_print # run banner
    create_groups # this is done first as the users cant be added to the groups without them
    add_users # add users
}

main