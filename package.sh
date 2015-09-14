#!/bin/bash

scriptsdir=`dirname $0`
. $scriptsdir/util.sh
log "======================================== PACKAGING ============================================"
log "== 1. prepare"

workspace=$scriptsdir/workspace_$envstr
sourcedir=$workspace/src/$model
configdir=$workspace/config/$model
builddir=$workspace/build/$model
buildfull=$builddir/fullsrc
buildpartial=$builddir/partsrc
buildzip=$builddir/zip
outputdir=$builddir/output
tmpdir=$builddir/tmp
versionfile=$configdir/${model}_${p_ver}_version.txt

log "== 2. calculate minor version of the package"
[ -e $buildzip ] && rm -rf $buildzip
mkdir -p $buildzip
mainver=${p_ver#v}
newminorver=2
if [ -e $versionfile ]; then
	oldversion=`cat $versionfile`
	oldlastbit=${oldversion##*.}
	newminorver=$(( $oldlastbit + 1 ))
fi
lastoutput=$outputdir/$oldversion
newoutput=$outputdir/$mainver.$newminorver
[ -d $newoutput ] && rm -rf $newoutput
mkdir -p $newoutput

startminorver=1

log "== 3. package"
log "generate ${model}_${mainver}.${newminorver}.zip"
buildfile $buildfull $buildfull $buildzip $model $newoutput/${model}_${mainver}.${newminorver}.zip

while [ $startminorver -lt $newminorver ]; 
do
	log "generate ${model}_${mainver}.${startminorver}_${mainver}.${newminorver}.zip"
	if [ "$(($startminorver+1))" == "$newminorver" ]; then
		buildfile $buildfull $buildpartial $buildzip $model $newoutput/${model}_${mainver}.${startminorver}_${mainver}.${newminorver}.zip
	else
		output_incrementzipfile=$newoutput/${model}_${mainver}.${startminorver}_${mainver}.${newminorver}.zip
		input_incrementzipfile=$lastoutput/${model}_${mainver}.${startminorver}_${mainver}.${oldlastbit}.zip
		[ -d $tmpdir ] && rm -rf $tmpdir
		mkdir -p $tmpdir
		(cd $tmpdir; $(unzipfile $input_incrementzipfile); $(unzipfile $model.zip); rm -f $model.zip $model.txt )
		for srcfile in `find $buildpartial -type f`
		do
			relativepath=${srcfile#$buildpartial}
			tmpfile=$tmpdir$relativepath
			copyfile $srcfile $tmpfile
		done
		buildfile $buildfull $tmpdir $buildzip $model $output_incrementzipfile
	fi
	startminorver=$(($startminorver+1))
done


echo /dev/null > $versionfile
echo $mainver.$newminorver > $versionfile
log "======================================== STEP END ============================================"
