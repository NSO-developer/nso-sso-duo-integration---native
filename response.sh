#!/bin/bash

#user=$1
#password=$2

#message=$(/usr/sbin/login_duo  -f $user)
#message64="$(echo "Autopushing login request to phone..." | base64)"
#echo "${message64}"
#uid=$(id -u admin)
read -r input
challenge_id0=${input%%;*}
challenge_id=${challenge_id0#[}

response0=${input#*;}
response=${response0%;]}

#[6] Successful Duo login for 'admin'
#[4] Failed Duo login for 'admin'
result=$(cat /tmp/$challenge_id.txt | grep Successful | wc -l)



if [ $result -gt 0 ]
    then
        uid=$(id -u $challenge_id)
        gid=$(id -g $challenge_id) 
        groups=$(id -Gn $challenge_id) 
        echo "accept $groups $challenge_id $uid $gid /home/$challenge_id $challenge_id";
    else
        echo "reject DUO authentication failed"
fi
rm -f /tmp/$challenge_id.txt

