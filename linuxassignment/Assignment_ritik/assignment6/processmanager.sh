#!/bin/sudo bash  
#this script will run with sudo user only


# Source the functions
source ./ProcessManagerFunction.sh

# Check the command line arguments
if [ "$#" -lt 2 ]; 
then

    	echo "Usage: $0 -o <operation> [-s <script_path>] [-a <alias>]"
    	exit 1
fi


# using getopts function to store value using flags

operation=""
while getopts ":o:s:a:p:" opt; 
do

    	case $opt in

        	o) operation="$OPTARG" ;;
        	s) script_path="$OPTARG" ;;
        	a) alias_name="$OPTARG" ;;
		p) priority="$OPTARG" ;;
		:)
			echo "Option -$OPTARG requires as argument."
			exit 1;;
               \?)
		       echo "Invalid flags:- $OPTARG"
                       exit 1;;

    	esac
done


# Perform operations based on the command line options
case "$operation" in

    	register)
        	register_service "$script_path" "$alias_name"
		;;
    	start)
        	start_service "$alias_name"
        	;;
    	status)
        	check_status "$alias_name"
        	;;
    	kill)
        	stop_service "$alias_name"
        	;;

	priority)

        	if [ -z "$priority" ]; 
		then
            		echo "Error: Priority level not specified."
            		exit 1
        	fi
        	change_priority "$alias_name" "$priority"
        	;;

    	list)
        	list_services
        	;;
    	top)
        	show_service_details "$alias_name"
        	;;
   	*)
        	echo "Invalid operation. Use 'register', 'start', 'status', 'kill', Priority, 'list', or 'details'."
        	exit 1
        	;;
esac
