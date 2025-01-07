function file:





#!/bin/bash

set -x
config_file="$HOME/ssh_connection"


add_connection(){

	name=$1
	host=$2
	user=$3
	port=$4
	keys=$5

	if grep -q "^$name" "$config_file";
	then
		echo "Server $name already exists."
		exit 1
	fi

	echo "$name:$host:$user:$port:$keys" >> "$config_file"
	echo "SSH connection added successfully for: $name"
}


update_connection() {
	
    	name=$1
    	host=$2
    	user=$3
    	port=$4 
    	key=$5  

    if ! grep -q "^$name:" "$config_file"; then
        echo "Server '$name' not found."
        exit 1
    fi

    current_line=$(grep "^$name:" "$config_file")

    current_name=$(echo "$current_line" | cut -d':' -f1)
    current_host=$(echo "$current_line" | cut -d':' -f2)
    current_user=$(echo "$current_line" | cut -d':' -f3)
    current_port=$(echo "$current_line" | cut -d':' -f4)
    current_key=$(echo "$current_line" | cut -d':' -f5) 

    updated_host=${host:-$current_host}
    updated_user=${user:-$current_user}
    updated_port=${port:-$current_port}
    updated_key=${key:-$current_key}


    updated_line="$current_name:$updated_host:$updated_user:$updated_port:$updated_key"


    sed -i "/^$name/d" "$config_file"  
    echo "$updated_line" >> "$config_file"   
    echo "Updated ssh connection successfully for: '$name'"
}



list_connection() {
	
    	value=$1

    	if [ ! -s "$config_file" ]; then

        	echo "No connections found."
        	exit 1
    	fi

    	if [ ! -z "$value" ]; 
    	then

		while read -r line; 
		do

			
        		name=$(echo "$line" | cut -d':' -f1)
        		host=$(echo "$line" | cut -d':' -f2)
        		user=$(echo "$line" | cut -d':' -f3)
        		port=$(echo "$line" | cut -d':' -f4)
        		key=$(echo "$line" | cut -d':' -f5)

      
        

        
        		if [ -n "$key" ]; 
			then
	
            			echo "$name: ssh -i $key -p $port $user@$host"

        		elif [ "$port" != "22" ];
		       	then
            			echo "$name: ssh -p $port $user@$host"
        		else
            			echo "$name: ssh $user@$host"
        		fi

    		done < "$config_file"


    	else

            	awk -F':' '{print $1}' "$config_file"

    fi
}



delete_ssh_connection() {

    	name=$1

    	if ! grep -q "^$name:" "$config_file"; 
	then
        	echo "Server '$name' not found."
        	exit 1
    	fi

    	sed -i "\|^$name:|d" "$config_file"
    	echo "Removed connection from config file for: '$name'"
}


ssh_to_server() {


    	name=$1

    	if ! grep -q "^$name:" "$config_file";
       	then
		
        	echo "[ERROR]: Server information is not available, please add server first"
        	exit 1
    	fi

    	connection_info=$(grep "^$name:" "$config_file")
    	host=$(echo "$connection_info" | cut -d':' -f2)
    	user=$(echo "$connection_info" | cut -d':' -f3)
    	port=$(echo "$connection_info" | cut -d':' -f4)
    	key=$(echo "$connection_info" | cut -d':' -f5)

    	if [ -n "$key" ]; then
		
        	echo "Connecting to $name on $port port as $user via $key key"
        	ssh -i "$key" -p "$port" "$user@$host"
    	elif [ "$port" != "22" ]; then

        	echo "Connecting to $name on $port port as $user"
        	ssh -p "$port" "$user@$host"
    	else
        	echo "Connecting to $name as $user"
        	ssh "$user@$host"
    	fi
}
