#!/bin/bash
scriptsdir=`dirname $0`
. $scriptsdir/util.sh
log "======================================== COMPARE AND COPY FILE ============================================"
log "== 1. prepare"
envstr=`echo $envstr | sed -e 's#.*#\L&#g'`

workspace=$scriptsdir/workspace_$envstr
builddir=$workspace/build/$model
buildfull=$builddir/fullsrc
buildpartial=$builddir/partsrc
buildrefer=$builddir/refersrc

log "== 2. calculate different files"
[ -d $buildpartial ] && rm -rf $buildpartial
mkdir -p $buildpartial
for srcfile in `find $buildfull -type f -not -path "*/.svn/*"`
do
	relativepath=${srcfile#$buildfull}
	referfile=$buildrefer$relativepath
	partialfile=$buildpartial$relativepath

	if [ -f $referfile ]; then
		srcfilemd5=$(filemd5 $srcfile)
		referfilemd5=$(filemd5 $referfile)
		if [ ! "$srcfilemd5" == "$referfilemd5" ]; then
			copyfile $srcfile $partialfile
		fi
	else
		copyfile $srcfile $partialfile
	fi
done
log "======================================== STEP END ============================================"