#!/bin/bash

#set -x

branch1=""
branch2=""

while getopts ":lmrb:d:1:2:" flags;
do
	case $flags in

		l)
			git branch
			;;
		b)
			branch_name=$OPTARG
			git branch $branch_name
			echo "$branch_name is added successfully !"
			;;
		d)
			branch_name=$OPTARG
			git branch -d $branch_name
			echo "$branch_name is deleted successfully !"
			;;

		1)
			branch1=$OPTARG;;

		2)
			branch2=$OPTARG;;

		m)
			action="merge"
			;;

		r)
			action="rebase"
			;;



		:)
			echo "Option -$OPTARG required an argurment."
			;;
		\?)
			echo "Wrong flags selection -$OPTARG!!"
			;;
	esac	
done


# Merge branch1 into branch2 

if [[ "$action" = "merge" ]];
then
	
        if [[ -n "$branch1" && -n "$branch2" ]];
        then
                git checkout "$branch2"
                git merge "$branch1"
                echo "merged branch $branch1 into $branch2 successfully !"
        else
                echo "Both branch1 and branch2 must be provided using -1 and -2 flags."
                exit 1
        fi
fi


 # Rebase branch1 onto branch2
 
if [[ "$action" = "rebase" ]];
then

        if [[ -n "$branch1" && -n "$branch2" ]];
	then
		git checkout "$branch2" #  Checkout the base branch first
		git rebase "$branch1"  # Rebase branch1 onto branch2

                echo "Rebased branch $branch1 onto $branch2 successfully!"
	else
		echo "Both branch1 and branch2 must be provided using -1 and -2 flags."
		exit 1
	fi
fi
