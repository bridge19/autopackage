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
	elif  [ "${keyvalue[0]}" == "basecodeversion" ]; then
		basecodeversion=${keyvalue[1]}
	fi
done < $config

if [ "$wwwURL" == "" ] || [ "$deployURL" == "" ] || [ "$envstr" == "" ] || [ "$model" == "" ] || [ "$p_ver" == "" ] || [ "$basecodeversion" == "" ]; then
	echo some of the parameters in $config are missing...
	echo please check below parameters are dedined:
	echo wwwURL,deployURL,envstr,model,p_ver,basecodeversion
	exit 1
fi

export wwwURL
export deployURL
envstr=`echo $envstr | sed -e 's#.*#\L&#g'`
export envstr
export model
export p_ver
export basecodeversion

scriptsdir=`dirname $0`
if [ "$scriptsdir" == "." ]; then
	scriptsdir=$PWD
fi
$scriptsdir/firstrun.sh