#!/bin/bash

# action to be perform
action=$1 
# directoary name
dir=$2
# file name
name=$3
# content to be added into a file
content=$4

# to be displayed content in range
range=$5


# used case statement to perform an action
case $action in
	addDir)
		mkdir -p "$dir/$name"
		;;
	deleteDir)
		rm -rf "$dir/$name"
		;;
	listAll)
		ls -al "$dir"
		;;
	listFiles)
		ls -l "$dir" | grep "^-"
		;;
	listDirs)
		ls -al "$dir" | grep '^d'
		;;
	addFile)
		touch "$dir/$name"
		echo -n "$content" >"$dir/$name" 
		;;
	addContentToFile)
		echo -e "\n$content" >>"$dir/$name"
		;;
	addContentToFileBegining)
		echo "$content" | cat - "$dir/$name" > "$dir/temp" && mv "$dir/temp" "$dir/$name"
		;;
	showFileBeginingContent)
		head -"$content" "$dir/$name"
		;;
	showFileEndContent)
		tail -"$content" "$dir/$name"
		;;
	showFileContentAtLine)
		head -"$content" "$dir/$name" | tail -1
		;;
	showFileContentForLineRange)
		num_line=$((range - content + 1))
		head -"$range" "$dir/$name" | tail -"$num_line"
		;;
	moveFile)
		mv "$dir" "$name"
		;;
	copyFile)
		cp "$dir" "$name"
		;;
	clearFileContent)
		echo -n "" > "$dir/$name"
		;;
	deleteFile)
		rm "$dir/$name"
		;;
	
	*)
		echo "Wrong action input !!"
		;;
esac
