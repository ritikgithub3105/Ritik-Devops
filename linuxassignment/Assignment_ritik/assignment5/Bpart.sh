#!/bin/bash

set -x

. ot_function.sh

action=$1

case $action in

	addLineTop)
		fileName=$2
		line=$3
		addLineTop "$fileName" "$line"

		;;
	addLineBottom)
		fileName=$2
		line=$3
		addLineBottom "$fileName" "$line"

		;;
	addLineAt)
		fileName=$2
		lineNum=$3
		line=$4

		addLineAt "$fileName" "$lineNum" "$line"

		;;
	updateFirstWord)
		fileName=$2
		word=$3
		new_word=$4

		updateFirstWord "$fileName" "$word" "$new_word"

		;;
	updateAllWords)
		fileName=$2
		word=$3
		new_word=$4

		updateAllWords "$fileName" "$word" "$new_word"

		;;
	insertWord)
		fileName=$2
		word1=$3
		word2=$4
		new_word=$5

		insertWord "$fileName" "$word1" "$word2" "$new_word"

		;;
	deleteLine)

		fileName=$2
		line_no=$3
		word=$4

		deleteLine "$fileName" "$line_no" "$word"

		;;

	*)
		echo "Invalid Input !!"

esac
