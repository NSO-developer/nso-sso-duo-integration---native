#!/bin/bash

read -r input
user0=${input%%;*}
user=${user0#[}
pass0=${input#*;}
pass=${pass0%;]}


message64="$(echo "Authenticating through DUO, Press ENTER to continue...." | base64)"
#echo "${message64}"
#user64="$(echo $user | base64)"
echo "challenge $user  $message64"
/bin/bash -c "nohup /usr/sbin/login_duo  -d -f $user &> /tmp/$user.txt"

#echo "accept_token external info 1000 2000 /home/info t2 "