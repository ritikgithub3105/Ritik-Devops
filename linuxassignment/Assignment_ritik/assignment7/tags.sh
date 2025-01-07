#!/bin/bash


while getopts ":lt:d:" flags;
do
	case $flags in

		l)
			# to list all tags
			echo "All tags"
			git tag
			;;
		t)
			tag_name=$OPTARG
			git tag -a "$tag_name" -m "$tag_name release"
			echo "tag $tag_name is created successfully."
			;;
		d)
			tag_name=$OPTARG
			git tag -d "$tag_name"
			echo "tag $tag_name is deleted successfully."
			;;
		:)
			echo "Options -$OPTARG need an argument."
			;;
		\?)
			echo "Wrong selection flag !!"
			;;
	esac
done
