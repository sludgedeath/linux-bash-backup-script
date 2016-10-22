#!/bin/bash
DAYS=7

TARGET='/media/'$(whoami)'/Backup'

SOURCE=(
	'/home/'$(whoami)'/porn'
	'/home/share/database'
)


##############################################################################################
#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#\/#
##############################################################################################


if [ ! -d $TARGET ]; then
	logger "backup storage medium not found:" $TARGET 
	exit
fi


copy_ () {
	fil=$1
	tstamp=$(stat $fil -c %y | cut -d "." -f1 |  sed -e  's/-//g; s/://; s/\ //g; s/:/\./')
	cp $file $TARGET$fil
	touch -mt $tstamp $TARGET$fil
}

logger "backup is backing up files now:" $TARGET 
#rm unneeded dates
folders_count=$(ls $TARGET | wc -l)
if (( $folders_count > $DAYS )); then
	for rm_folder in $(ls $TARGET -t | tail -n $(( $folders_count - $DAYS )) );do
		rm -r $TARGET'/'$rm_folder
	done
fi

#mk todays dir
dir_='/'$(date +"%d-%m-%y")
if [ ! -d $dir_ ];then
	mkdir -p $TARGET$dir_
fi


TARGET=$TARGET$dir_

#rm files from Backup
for files in $(find $TARGET -type f);do
	sourcefile=$(echo $files|sed 's|'$TARGET'||'g )
	if [ ! -f $sourcefile ] ;then
		rm $TARGET$sourcefile
	fi
done
#rm dirs from Backup
for dir in $(find $TARGET -type d);do
	sourcefile=$(echo $dir|sed 's|'$TARGET'||'g )
	if [ ! -d $sourcefile ] ;then
		rm -r $TARGET$sourcefile
	fi
done

for files in ${SOURCE[@]}; do
	#mkdirs on Backup
	for dir in $(find $files -type d); do
		if [ ! -d $TARGET$dir ]; then
			mkdir -p $TARGET$dir
		fi
	done
	#file operations
	for file in $(find $files -type f); do
		if [ ! -f $TARGET$file ]; then
			copy_ $file		
		else
			lm_o=$(stat $file -c %Y)
			lm_b=$(stat $TARGET$file -c %Y)
			if [ $lm_o != $lm_b ];then
				copy_ $file
			fi
		fi 
	done
done







