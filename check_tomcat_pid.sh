#!/bin/bash

echo "ps -ef | grep tomcat | grep -v grep |awk '{print $2}"
pid=$(ps -ef | grep tomcat | grep -v grep |awk '{print $2}')
echo "pid=$pid"
if [ "$pid" ]; then
echo "kill -9 $pid"
kill -9 $pid
fi
