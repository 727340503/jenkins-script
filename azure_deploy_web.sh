#!/bin/bash
#source /etc/profile

tar_path=$1
tar_name=$2
host=$3
port=$4
user=$5

remote_tar_path=$6
remote_deploy_path=$7

function deploy_server(){
tar_path=$1
tar_name=$2
deploy_path=$3
server_host=$4
server_port=$5
server_user=$6

ssh -tT -p $server_port $server_user@$server_host << EOF
mkdir -p ~/dist
exit
EOF

echo "scp -P $server_port $tar_path/$tar_name $server_user@$server_host:$remote_tar_path"
scp -P $server_port $tar_path/$tar_name $server_user@$server_host:$remote_tar_path
echo "ssh -tT -p $server_port $server_user@$server_host"
ssh -tT -p $server_port $server_user@$server_host << EOF
# echo "mkdir -p $deploy_path"
# mkdir -p $deploy_path
echo "tar -zxvf $remote_tar_path/$tar_name -C $deploy_path"
tar -zxvf $remote_tar_path/$tar_name -C $deploy_path
exit
EOF
}

#script start
deploy_server $tar_path $tar_name $remote_deploy_path $host $port $user

echo "deploy done."

exit 0
