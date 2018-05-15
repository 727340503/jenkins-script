#!/bin/bash
#source /etc/profile

ftp_ip=$1
ftp_user_name=$2
ftp_password=$3
local_path=$4
ftp_path=$5
deploy_type=$6
file_name=$7

function deploy_folder(){
ftp_ip=$1
ftp_user_name=$2
ftp_password=$3
local_path=$4
ftp_path=$5

lftp <<EOF
echo "open $ftp_ip"
open $ftp_ip

echo "login $ftp_user_name $ftp_password"
login $ftp_user_name $ftp_password

echo "mirror -Re $local_path $ftp_path"
mirror -Re $local_path/ $ftp_path/

echo "cd $ftp_path"
cd $ftp_path
ls

exit 
EOF
}

function deploy_file(){
ftp_ip=$1
ftp_user_name=$2
ftp_password=$3
local_path=$4
ftp_path=$5
file_name=$6
lftp <<EOF

echo "open $ftp_ip"
open $ftp_ip

echo "login $ftp_user_name $ftp_password"
login $ftp_user_name $ftp_password

echo "cd $ftp_path"
cd $ftp_path

echo "rm -rf $file_name.war"
rm -rf $file_name.war
echo "rm -rf $file_name"
rm -rf $file_name

echo "lcd $local_path"
lcd $local_path
echo "put $file_name.war "
put $file_name.war
exit
EOF
}

#script start
if [ "$deploy_type" = "2" ]; then
	deploy_folder $ftp_ip $ftp_user_name $ftp_password $local_path $ftp_path
elif [ "$deploy_type" = "1" ]; then
    deploy_file $ftp_ip $ftp_user_name $ftp_password $local_path $ftp_path $file_name
fi

echo "deploy done."
exit 0
