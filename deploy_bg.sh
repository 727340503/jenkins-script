#!/bin/bash
#source /etc/profile

war_file=$1
web_context=$2
host=$3
port=$4
user=$5
remote_war_path=$6
tomcat_home=$7

check_tomcat_pid_file=/var/lib/jenkins/deploy/check_tomcat_pid.sh

function deploy_server(){
war_file=$1
web_context=$2
server_host=$3
server_port=$4
server_user=$5
remote_war_path=$6
tomcat_home=$7

remote_tomcat_webapps=$tomcat_home/webapps
remote_tomcat_bin=$tomcat_home/bin

ssh -tT -p $server_port $server_user@$server_host << EOF
mkdir -p ~/dist
exit
EOF

echo "scp -P $server_port $war_file $server_user@$server_host:$remote_war_path"
scp -P $server_port $war_file $server_user@$server_host:$remote_war_path

echo "ssh -tT -p $server_port $server_user@$server_host"
ssh -tT -p $server_port $server_user@$server_host << EOF
sudo su
#stop tomcat
echo "stop tomcat"
sh $remote_tomcat_bin/shutdown.sh

echo "delete old $web_context"
rm -rf $remote_tomcat_webapps/$web_context
rm -rf $remote_tomcat_webapps/${web_context}.war
echo "mv -f $remote_war_path/${web_context}.war $remote_tomcat_webapps/"
mv -f $remote_war_path/${web_context}.war $remote_tomcat_webapps/
#start tomcat
echo "start tomcat"
sh $remote_tomcat_bin/startup.sh
exit
EOF
}

#script start
deploy_server $war_file $web_context $host $port $user $remote_war_path $tomcat_home

echo "deploy done."

exit 0
