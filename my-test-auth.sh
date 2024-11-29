#!/bin/bash

read -r input
user0=${input%%;*}
user=${user0#[}
pass0=${input#*;}
pass=${pass0%;]}


exist=$(id -u $user &> /dev/null ; echo $?) 

if  [ $exist -eq 0 ] ; then
	message64="$(echo "Authenticating external DUO, Press ENTER to continue...." | base64)"
	echo "challenge $user  $message64"
	/bin/bash -c "nohup /usr/sbin/login_duo  -d -f $user &> /tmp/$user.txt"
else
        echo "abort User not exist"
fi


