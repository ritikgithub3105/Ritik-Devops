#!/bin/bash

#set -x

. ot_function.sh

action=$1

case $action in
	-a)
		port=22
		shift
		while getopts "n:h:u:p:i:" flags;
		do
			case $flags in
				n)
					name="$OPTARG";;
				h)
					host="$OPTARG";;
				u)
					user="$OPTARG";;
				p)
					port="$OPTARG";;
				i)
					keys="$OPTARG";;
				\?)
					echo "Invalid flags:- $OPTARG"
					exit 1;;
				:)
					echo "Option -$OPTARG requires as argument."
					exit 1;;
			esac
		done
		if [ -z "$name" ] || [ -z "$host" ] || [ -z "$user" ];
		then
			echo "Required flags missing !!"
			echo "Usage: All options -n, -h, -u are required."
			exit 1
		else
			add_connection "$name" "$host" "$user" "$port" "$keys"
		fi
		;;

	-u)
		#$ otssh -u -n server1 -h server1 -u user1
		#$ otssh -u -n server2 -h server2 -u user2 -p 2022
		shift
		while getopts "n:h:u:p:i:" flags;
		do
			case $flags in
				n)
					name=$OPTARG;;
				h)
					host=$OPTARG;;
				u)
					user=$OPTARG;;
				p)
					port=$OPTARG;;
				i)
					key=$OPTARG;;
				\?)
                                        echo "Invalid flags:- $OPTARG"
                                        exit 1;;
				:)

      					echo "Option -$OPTARG requires as argument."
                                        exit 1;;
			esac
		done
		if [ -z "$name" ];
                then
                        echo "Name is required"
			echo "input name to update the details"
			exit 1
		else
                        update_connection "$name" "$host" "$user" "$port" "$key"
                fi
                ;;
	ls)
		details=$2

		list_connection $details
		;;

	rm)
		servername=$2
		delete_ssh_connection $servername
		;;



	*)
		ssh_to_server $1

		;;
esac
