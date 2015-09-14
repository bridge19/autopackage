#!/bin/bash

config=$1
if [ ! -f $config ]; then
	echo config file $! does not exist...
	exit 1
fi
while read line
do
	keyvalue=( `echo $line | awk -F'=' '{print $1" "$2 }'` )
	if [ "${keyvalue[0]}" == "wwwURL" ]; then
		wwwURL=${keyvalue[1]}
	elif  [ "${keyvalue[0]}" == "deployURL" ]; then
		deployURL=${keyvalue[1]}
	elif  [ "${keyvalue[0]}" == "envstr" ]; then
		envstr=${keyvalue[1]}
	elif  [ "${keyvalue[0]}" == "model" ]; then
		model=${keyvalue[1]}
	elif  [ "${keyvalue[0]}" == "p_ver" ]; then
		p_ver=${keyvalue[1]}
	elif  [ "${keyvalue[0]}" == "manageURL" ]; then
		manageURL=${keyvalue[1]}
	elif  [ "${keyvalue[0]}" == "staticURL" ]; then
		staticURL=${keyvalue[1]}
	fi
done < $config

if [ "$wwwURL" == "" ] || [ "$deployURL" == "" ] || [ "$envstr" == "" ] || [ "$model" == "" ] || [ "$p_ver" == "" ] || [ "$manageURL" == "" ]; then
	echo some of the parameters in $config are missing...
	echo please check below parameters are dedined:
	echo wwwURL,deployURL,envstr,model,p_ver
	exit 1
fi
export wwwURL
export deployURL
envstr=`echo $envstr | sed -e 's#.*#\L&#g'`
export envstr
export model
export p_ver
export manageURL
export staticURL

scriptsdir=`dirname $0`
if [ "$scriptsdir" == "." ]; then
	scriptsdir=$PWD
fi
logdir=$scriptsdir/workspace_$envstr/logs
[ -d $logdir ] || mkdir -p $logdir
LOG_FILE=$logdir/${model}_${p_ver}`date +"%Y%m%d_%H%M%S"`.log
export LOG_FILE
echo ============================================================
echo = the log file can be found at $LOG_FILE
echo =
echo ============================================================

$scriptsdir/getcode.sh $2 && $scriptsdir/prebuild.sh && $scriptsdir/package.sh&& $scriptsdir/notification.sh

