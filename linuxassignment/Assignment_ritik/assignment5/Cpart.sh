#!/bin/bash

set -x

file=$2

if [ -f "$file" ];
then
	addLineTop(){
		file=$1
		line=$2
		if [ ! -s "$file" ];
		then
			echo "$line" > $file
		else
			sed -i "1i$line" "$file"
		fi
	}

	addLineBottom(){
		file=$1
		line=$2
		echo "$line" >> "$file"
	}

	addLineAt(){
		file=$1
		lineNum=$2
		line=$3

		sed -i "${lineNum}i $line" "$file"

	}

	updateFirstWord(){
		file=$1
		word=$2
		new_word=$3
		sed -i "0,/\\b$word\\b/s/\\b$word\\b/$new_word/" "$file"

	}

	updateAllWords(){
		file=$1
                word=$2
                new_word=$3
                sed -i "s/\b$word\b/$new_word/g" "$file"

	}
 
	insertWord(){
		file=$1
                word1=$2
                word2=$3
		new_word=$4

		sed -i "s/\b$word1\b[[:space:]]\b$word2\b/$word1 $new_word $word2/g" $file


        }

	deleteLine(){
		file=$1
    		line_no=$2
    		word=$3

    		if [ -n "$word" ]; 
		then
			if sed -n "${line_no}p" "$file" | grep -q "$word"; 
			then
				sed -i "${line_no}d" "$file"
			fi
    		else
        		sed -i "/$word/d" $file
    		fi
	}

else
	echo "File not found .."
	exit 1
fi

