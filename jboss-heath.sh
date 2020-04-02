#!/bin/sh
#
#   JBOSS APPLICATION HEALTH CHECKER
#
#	CREATED BY KIRILL RUDENKO
#
#	FRIENDLY TECHNOLOGIES LIMITED
#
# --------------------------------------------------------
#
#	UNCOMMENT NECESSARY VARIABLES LIKE:
#		- DB LISTENING SOCKETS
#		- CUSTOMER SPECIFIC JBOSS SOCKETS
#		-- SEE COMMENTS BELOW
#
#
# Can be set in crontab to run every 15 minutes
# IN CMD FOR ONE LINER USE:
#
#     (crontab -l ; echo "*/15 * * * * exec /path/to/script/jboss-health.sh > /dev/null 2>1&") | crontab -
#
#
#--------------------------------------------------------


PATH=$PATH:/sbin:/bin:/usr/bin:/usr/sbin

export PATH

export JBOSS_LOG_HOME=  # RECHECK IF JBOSS HOME IS NON STANDARD
export JAVA_THREADS=`ps -eLf | grep -c jboss| grep -v grep`

#export ORACLE_DB_PORT=`netstat -na | grep 1521 | grep -v grep | grep -ic est`
export MYSQL_DB_PORT=`netstat -na | grep 3306 | grep -v grep | grep -ic est`
export QOE_DB_PORT=`netstat -na | grep 8123| grep -v grep | grep -ic est`

export RAM=`free -m|grep Mem`
export LOAD_AVERAGE=`cat /proc/loadavg |cut -d ' ' -f 1`
#
# JBOSS PORTS / CHECK IF YOUR APP IS USING OTHERS
#
export JSOCKET_1=`netstat -na |grep 8080| grep -v grep| grep -ic est`
export JSOCKET_2=`netstat -na |grep 8181|grep -v grep |wc -l`
export JSOCKET_3=`netstat -na |grep 8182| grep -v grep| grep -ic est`
export JSOCKET_4=`netstat -na |grep 8443|grep -v grep |wc -l`
#  UNCOMMENT FOR MULTI-NODE ENVIRONMENTS
#export JSOCKET_5=`netstat -na |grep 7600|grep -v grep |wc -l`
export LOAD_AVERAGE=`cat /proc/loadavg |cut -d ' ' -f 1`
export JAVA_MEMORY=`ps -C java -O rss  |awk 'NR>1 {print $2/1024}'`
export TOTAL_RAM=`echo $RAM|awk '{print $2}'`
export USED_RAM=`echo $RAM|awk '{print $3}'`
export FREE_RAM=`echo $RAM|awk '{print $4}'`



function main(){
echo `date +'%d-%m-%Y %R:%S'`
echo "---------------------------------------------------------------------"
echo "JAVA TREADS - $JAVA_THREADS"
echo "																		"
echo "DB PORT CONNECTIONS - $MYSQL_DB_PORT"
echo "QOE DB PORT CONNECTIONS - $QOE_DB_PORT"
echo "																		"
echo "SERVER LOAD AVERAGE - $LOAD_AVERAGE"
echo "RAM TOTAL - $TOTAL_RAM"
echo "RAM USED - $USED_RAM"
echo "RAM FREE - $FREE_RAM"
echo "JAVA USED RAM - $JAVA_MEMORY"
echo "																		"
echo "ACS CONNECTIONS:"
echo "8080 - $JSOCKET_1"
echo "8181 - $JSOCKET_2"
echo "8182 - $JSOCKET_3"
echo "8443 - $JSOCKET_4"
echo "---------------------------------------------------------------------"
}

main >> jboss_health_stat.log
