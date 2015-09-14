#!/bin/bash

scriptsdir=`dirname $0`
. $scriptsdir/util.sh
log "======================================== GET CODE FROM SVN ============================================"
log "== 1. prepare"

workspace=$scriptsdir/workspace_$envstr
configdir=$workspace/config/$model
sourcedir=$workspace/src/$model
referdir=$workspace/refer/$model
builddir=$workspace/build/$model
buildfullsrc=$builddir/fullsrc
buildrefersrc=$builddir/refersrc
[ -d $workspace ] || mkdir -p $workspace
[ -d $configdir ] || mkdir -p $configdir
[ -d $sourcedir ] || mkdir -p $sourcedir
[ -d $referdir ] || mkdir -p $referdir
[ -d $builddir ] || mkdir -p $builddir

log "== 2. calculate code version"
baseverfile=$configdir/basever.txt
if [ ! -f $baseverfile ]; then
	echo $baseverfile does not exist, please execute scripts with first run step.
fi 
basever=`cat $baseverfile`
lastver=${basever#*:}
info=$(echo `svn log --username xuyong --password 123456 --non-interactive $wwwURL` | sed 's/-\{72\}/\n/g' | sed -e 's/ //g' | sed -e 's/^r\([0-9]*\)|.*/\1/' |sed -e '/^$/d' | sort -n)
infoarray=(${info})
length=${#infoarray[@]}
if [ "$1" == "" ]; then
	endver=${infoarray[$(($length-1))]} 
else
	endver=$1
fi

if [ ! $endver -gt $lastver ]; then
	log "the last builded code version is $lastver, and the latest code version is $endver"
	log "there is no update between them..."
	exit 1
fi
for ver in $info
do
	if [ $ver -gt $lastver ] && [ "$startver" == "" ]; then
		startver=$ver
	fi
	if [ $ver -gt $endver ]; then
		break
	fi
done
log "last version is $lastver, the latestver is $endver"
#check out latest code

	log "== 3. Checkout last version codes, version: $lastver "
	cd $referdir
	rm -rf ./*
	svn co --username xuyong -r $lastver --password 123456 --non-interactive $wwwURL 2>&1 >> $LOG_FILE
	log "Checkout environment rely files"
	svn co --username xuyong -r $lastver --password 123456 --non-interactive $deployURL 2>&1 >> $LOG_FILE
	log "== 4. Checkout latest version codes, version: $endver "
	log "Checkout environment rely files"
	cd $sourcedir
	rm -rf ./*
	svn co --username xuyong -r $endver --password 123456 --non-interactive $wwwURL 2>&1 >> $LOG_FILE
	svn co --username xuyong -r $endver --password 123456 --non-interactive $deployURL 2>&1 >> $LOG_FILE


log "== 5. copy files from $sourcedir to $buildfullsrc "

[ -d $buildfullsrc ] && rm -rf $buildfullsrc
mkdir -p $buildfullsrc
for srcfile in `find $sourcedir/www -type f -not -path "*/.svn/*"`
do
	relativepath=${srcfile#$sourcedir}
	buildfile=$buildfullsrc$relativepath
	copyfile $srcfile $buildfile
done

for srcfile in `find $sourcedir/deploy/$envstr -type f -not -path "*/.svn/*"`
do
	filename=${srcfile##*/}
	for fullpathfile in `find $buildfullsrc -name "$filename"`
	do
		copyfile $srcfile $fullpathfile
	done
done

log "== 5. copy files from $referdir to $buildrefersrc "

[ -d $buildrefersrc ] && rm -rf $buildrefersrc
mkdir -p $buildrefersrc
for srcfile in `find $referdir/www -type f -not -path "*/.svn/*"`
do
	relativepath=${srcfile#$referdir}
	buildfile=$buildrefersrc$relativepath
	copyfile $srcfile $buildfile
done
for srcfile in `find $referdir/deploy/$envstr -type f -not -path "*/.svn/*"`
do
	filename=${srcfile##*/}
	for fullpathfile in `find $buildrefersrc -name "$filename"`
	do
		copyfile $srcfile $fullpathfile
	done
done
#calculate the committed comments
log "== 6. list the update version and comments"
info=`svn log --username xuyong --password 123456 --non-interactive --xml -r "$startver:$endver" $wwwURL`

tmpdir=$workspace/tmp/$model
datestr=`date +"%Y%m%d_%H%M%S"`
xmlfile=$tmpdir/data_${datestr}_input.xml
datafile=$tmpdir/data_${datestr}_output.dat
[ -d $tmpdir ] || mkdir -p $tmpdir
echo $info | sed -e 's#> <#><#g'|sed -e 's#\(<?.*?>\)#\1\n#' | sed -e 's#</logentry>#</logentry>\n#g' > $xmlfile

perl $scriptsdir/xmlparser.pl -a $xmlfile -b $datafile
log "= below result can be found from $datafile"
cat $datafile

#record the version
[ -f $baseverfile ] && mv $baseverfile $baseverfile.bak
echo /dev/null > $baseverfile
echo $startver:$endver > $baseverfile
log "======================================== STEP END ============================================"