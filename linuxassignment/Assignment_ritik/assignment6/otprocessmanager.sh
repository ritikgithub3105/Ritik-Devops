#!/bin/sudo bash

#set -x 

action=$1

case $action in

	topProcess)
		num=$(($2 + 1))
		sortby=$3

		if [[ "$sortby" == "memory" ]]; 
		then
			echo "top $(($num-1)) process list by memory !"
			echo
			#num=$(($num + 1))
			ps -eo user,pid,ppid,cmd,%mem --sort -%mem | head -"$num"
		elif [[ "$sortby" == "cpu" ]];
		then
			echo "top $(($num-1)) process list by cpu !"
			echo
			ps -eo user,pid,ppid,cmd,%cpu --sort -%cpu | head -"$num"
		else
			echo "Kindly select memory or cpu only !"
		
		fi
		;;

	killLeastPriorityProcess)

		pid=$(ps -eo pid,nice --sort=-nice | head -n 2 | tail -n 1 | awk '{print $1}')

    	    	if [ -n "$pid" ]; 
		then
			kill -9 "$pid"
        		echo "Killed process with least priority (PID: $pid)."
    		else
        		echo "No process found to kill."
    		fi
		;;

	RunningDurationProcess)

		if [ "$2" -eq "$2" ] 2>/dev/null; 
		then
        		ps -p "$2" -o pid,etime
    		else
        		pid=$(pgrep "$2")
        		if [ -n "$pid" ]; 
			then
				pid_list=$(echo "$pid" | tr '\n' ',')
				
				# to remove last comma from the list
				pid_list=${pid_list%,}  
				ps -p "$pid_list" -o pid,etime
         
        		else
            			echo "Process not found."
        		fi
    		fi
		;;

	listOrphanProcess)

		echo "Listing orphan processes:"
    		orphan_processes=$(ps -eo pid,ppid,comm | awk '$2 == 1')  # Get orphan processes with PPID = 1

    		if [ -z "$orphan_processes" ]; 
		then
        		echo "No orphan processes found."
    		else
        		echo "$orphan_processes" | awk '{print "PID:", $1, "COMMAND:", $3}'
    		fi
		;;

	listZoombieProcess)

		echo "Listing zombie processes:"
    		zombie_processes=$(ps -eo pid,stat,comm | awk '$2 ~ /^Z/')  # Get zombie processes

    		if [ -z "$zombie_processes" ]; 
		then
        		echo "No zombie processes found."
    		else
        		echo "$zombie_processes" | awk '{print "PID:", $1, "COMMAND:", $3}'  # Print PID and command of zombie processes
    		fi
		;;

	killProcess)
		
		if [ -z "$2" ]; 
		then
        		echo "Please provide a process name or PID."
        		return
    		fi

 
    		if [ "$2" -eq "$2" ] 2>/dev/null; 
		then
       	 		kill "$2" 2>/dev/null
        		if [ $? -eq 0 ]; 
			then
            			echo "Killed process with PID: $1."
        		else
            			echo "Failed to kill process with PID: $1."
        		fi
    		else
       
        		pids=$(pgrep "$2")
        		if [ -n "$pids" ]; 
			then

            			for pid in $pids; 
				do
                			kill "$pid" 2>/dev/null
                			echo "Killed process with name '$2' and PID: $pid."
            			done
        		else
            			echo "No process found with the name: $2."
        		fi
    		fi
		;;

	ListWaitingProcess)

		echo "Listing processes waiting for resources:"
		result=$(ps -eo pid,stat,comm | awk '$2 ~ /D/ {print $1, $3}')
		
    		if [ -z "$result" ]; 
		then
        		echo "No processes are currently waiting for resources."
		else
			echo "$result"
    		fi
		;;


	*)

		echo "Wrong Input !!!"
		;;

esac
