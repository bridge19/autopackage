#!/bin/bash

scriptsdir=`dirname $0`
. $scriptsdir/util.sh

log "============================ please find below infomation to deploy the new package============================"
workspace=$scriptsdir/workspace_$envstr
builddir=$workspace/build/$model
buildzip=$builddir/zip
configdir=$scriptsdir/workspace_$envstr/config/$model
versionfile=$configdir/${model}_${p_ver}_version.txt
version=`cat $versionfile`
outputdir=$scriptsdir/workspace_$envstr/build/$model/output/$version
log "== source pakcages are saved at 192.168.57.61:$outputdir/$version" 
log "== copy files to 192.168.57.55:/usr/local/web/static/resource/$version"
log "== 登录到中台系统：$manageURL"
log "== 录入以下信息："
log "SOFT_VERSION: $p_ver"
log "BUNDLE_MODEL: $model"
log "BUNDLE_VERSION: $version"
log "BUNDLE_INSTALL_PATH: $staticURL/$version"

for file in `find $outputdir -type f`
do
	[ -d $buildzip ] && rm -rf $buildzip
	mkdir -p $buildzip
	cd $buildzip
	$(unzipfile $file $model.txt)
	md5str=$(filemd5 $buildzip/$model.txt)
	md5all=$md5all,$md5str
done
log "BUNDLE_MD5: $md5all"


