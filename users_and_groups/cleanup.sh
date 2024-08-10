#!/bin/bash
# Cleanup Script for add_users_and_groups.sh
# Cleans all the users, groups and home folders for them.

for i in {1..12}
do
	sudo userdel "tmp_usr_$i"
	sudo rm -rf "/home/tmp_usr_$i"
done

grps=("Human_Resources" "Finance" "Sales")
for i in "${grps[@]}" # Iterate through the above groups
do
	sudo groupdel $i
done