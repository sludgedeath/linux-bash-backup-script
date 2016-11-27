#!/bin/bash
DAYS=3

DESTINATION=(
	'/media/'"$(whoami)"'/Backup_king'
)

SOURCE=(
	'/home/'"$(whoami)"'/dev'
	'/home/share/database'
	'/home/share/txt'
	'/home/share/web'
)


####################################################################################################
#(. )( .)  (. )( .)  (. )( .)  (. )( .)  (. )( .)  (. )( .)  (. )( .)  (. )( .)  (. )( .)  (. )( .)#
####################################################################################################

copy_ () {
	fil=$1
	target=$2
	tstamp=$(stat "$fil" -c %y | cut -d "." -f1 |  sed -e  's/-//g; s/://; s/\ //g; s/:/\./')
	cp "$fil" "$target""$fil"
	echo COPY "$target""$fil"
	touch -mt $tstamp "$target""$fil"
}


for TARGET in ${DESTINATION[@]} ; do


	if [ ! -d "$TARGET" ]; then
		logger "backup storage medium not found:" "$TARGET" 
		echo ERROR
		break
	fi
	
	logger "backup is backing up files now:" "$TARGET"

	#rm unneeded dates
	folders_count=$(ls "$TARGET" | wc -l)
	if (( $folders_count > $DAYS )); then
		for rm_folder in $(ls "$TARGET" -t | tail -n $(( $folders_count - $DAYS )) );do
			rm -r "$TARGET"'/'"$rm_folder"
		done
	fi

	#mk todays dir
	dir_='/'$(date +"%d-%m-%y")
	if [ ! -d "$dir_" ];then
		mkdir -p "$TARGET""$dir_"
	fi

	TARGET="$TARGET""$dir_"

	#rm files from Backup
	find "$TARGET" -type f | while read files;do
		sourcefile=$(echo "$files"|sed 's|'$TARGET'||'g )
		if [ ! -f "$sourcefile" ] ;then
			rm "$TARGET""$sourcefile"
		fi
	done
	#rm dirs from Backup
	find "$TARGET" -type d| while read dir;do
		sourcefile=$(echo "$dir"|sed 's|"$TARGET"||'g )
		if [ ! -d "$sourcefile" ] ;then
			rm -r "$TARGET""$sourcefile"
		fi
	done

	for files in ${SOURCE[@]}; do
		#mkdirs on Backup
		find "$files" -type d | while read dir; do
			if [ ! -d $"TARGET""$dir" ]; then
				mkdir -p "$TARGET""$dir"
			fi
		done
		#file operations
		find "$files" -type f | while read file ; do
			if [ ! -f "$TARGET""$file" ]; then
				copy_ "$file" "$TARGET"
			else
				lm_o=$(stat "$file" -c %Y)
				lm_b=$(stat "$TARGET""$file" -c %Y)
				if [ $lm_o != $lm_b ] && [ $lm_o != $(( $lm_b + 1 )) ] && [ $lm_o != $(( $lm_b + 2 )) ];then
					copy_ "$file" "$TARGET"
				fi
			fi 
		done
		
	done #SOURCE
	
done #TARGET

