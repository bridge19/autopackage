#!/bin/bash

scriptsdir=/home/scripts/resourcespack
workspace=$scriptsdir/workspace_$envstr
configdir=$workspace/config/$model

[ -d $configdir ] || mkdir -p $configdir

versionfile=$configdir/${model}_${p_ver}_version.txt
baseverfile=$configdir/basever.txt

echo 0:$basecodeversion > $baseverfile
echo /dev/null > $versionfile
echo ${p_ver}.1 > $versionfile


