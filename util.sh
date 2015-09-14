loginfo()
{
	# | version | deliveredby | date | comments
	printf "|%-9s|%-15s|%15s|%s\n" $1 $2 $3 $4
}

filemd5()
{
	md5=`md5sum $1 | awk -F' ' '{print $1}'`
	echo $md5
}

copyfile()
{
	srcfile=$1
	destfile=$2
	destfolder=${destfile%/*}
	[ ! -d $destfolder ] && mkdir -p $destfolder
	cp $srcfile $destfile
}

log(){
	echo $1
	echo $1 >> $LOG_FILE
}
unzipfile()
{
	unzip $@ 2>&1 >> $LOG_FILE
}
filemd5()
{
	md5=`md5sum $1 | awk -F' ' '{print $1}'`
	echo $md5
}

compare(){
	if ! [ $# -eq 2 ]; then
		return 1
	fi
	if [ ! -f $2 ]; then 
		return 1
	fi
	srcmd5=`md5sum $1 | awk -F' ' '{print $1}'`
	destmd5=`md5sum $2 | awk -F' ' '{print $1}'`
	if [ $srcmd5 == $destmd5 ]; then
		return 0
	else
		return 1
	fi
}

buildfile()
{
	fullsrcfolder=$1
	partialsrcfolder=$2
	tmpfolder=$3
	model=$4
	outputfile=$5
	[ -e $tmpfolder ] && rm -rf $tmpfolder
	mkdir -p $tmpfolder
	filesnum=`find $partialsrcfolder -type f | wc -l`
	if [ $filesnum -eq 0 ]; then
		echo there is no file in src direcotry $partialsrcfolder
		return 1
	fi
	
	# 3.1 zip files
	(cd $partialsrcfolder; zip -r $tmpfolder/$model.zip ./* 2>&1 >> $LOG_FILE) 
	# 3.2 make md5 files
	manifestfile=$tmpfolder/$model.txt
	touch $manifestfile

	outputstr="{\"model\":\"$model\",\"version\":\"$version\",\"md5\":\"$(filemd5 $tmpfolder/$model.zip)\",\"md5List\":{"
	echo $outputstr >> $manifestfile

	totalfile=`find $fullsrcfolder -type f -not -path "*/.svn/*" | wc -l`
	scanfile=0
	for srcfile in `find $fullsrcfolder -type f -not -path "*/.svn/*"`
	do
		scanfile=$(( $scanfile + 1 ))
		relativefilename=${srcfile#$fullsrcfolder/}
		if [ $scanfile -eq $totalfile ]; then
		outputstr="\"$relativefilename\":\"$(filemd5 $srcfile)\""
		else
		outputstr="\"$relativefilename\":\"$(filemd5 $srcfile)\","
		fi
		echo $outputstr >> $manifestfile
	done
	echo }} >> $manifestfile

	manifestmd5value=$(filemd5 $manifestfile)
	# 3.3 zip $model.zip and manifest file
	(cd $tmpfolder; zip $outputfile ${model}.txt ${model}.zip 2>&1 >> $LOG_FILE) 
}
