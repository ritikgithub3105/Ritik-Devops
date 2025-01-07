#!/bin/sudo bash

#set -x
# Create a service file that will store alias and script path
SERVICE_FILE="services.txt"


# Function to register a service
register_service() {

    	script_path="$1"
    	alias_name="$2"
	priority="${3:-0}"

    	# Check if alias already exists
    	if grep -q "^$alias_name:" "$SERVICE_FILE"; 
	then
        	echo "Error: Alias '$alias_name' is already registered."
        	return
    	fi

    	# Create a systemd service file and stored that file in /etc/systemd/system dir.
	service_file="/etc/systemd/system/$alias_name.service"
    	echo "[Unit]" > "$service_file"
    	echo "Description=$alias_name Service" >> "$service_file"
    	echo "[Service]" >> "$service_file"
    	echo "ExecStart=$script_path" >> "$service_file"
    	echo "Restart=always" >> "$service_file"
	echo "Nice=$priority" >> "$service_file"
    	echo "[Install]" >> "$service_file"
    	echo "WantedBy=multi-user.target" >> "$service_file"


    	# Register the service in the service file
    	echo "$alias_name:$script_path" >> "$SERVICE_FILE"
    	echo "Service '$alias_name' registered."
}


# Function to start a service
start_service() {

    	alias_name="$1"
    	systemctl start "$alias_name" 	# this command will work because I have given sudo permission in seabang
	systemctl enable "$alias_name"
    	echo "Service '$alias_name' started."
}


# Function to check the status of a service
check_status() {

    	alias_name="$1"
    	systemctl status "$alias_name"
}


# Function to stop a service
stop_service() {

    	alias_name="$1"
    	systemctl stop "$alias_name"
	systemctl disable "$alias_name"
    	echo "Service '$alias_name' stopped."
}


# Function to change service priority
change_priority() {
	
    	alias_name="$1"
    	priority="$2"
    	service_file="/etc/systemd/system/$alias_name.service"

    	if [ ! -f "$service_file" ]; 
	then
        	echo "Error: No service found with alias '$alias_name'."
        	return
    	fi

    	case "$priority" in
        	low) nice_value=10 ;;
        	med) nice_value=0 ;;
        	high) nice_value=-10 ;;
        	*) echo "Invalid priority. Use 'low', 'med', or 'high'." && return ;;
    	esac

    	# Update the Nice value in the service file
    	sed -i "s/^Nice=.*$/Nice=$nice_value/" "$service_file"
    
    	# Reload the systemd daemon and restart the service to apply changes
    	systemctl daemon-reload
    	systemctl restart "$alias_name"

    	echo "Priority for '$alias_name' set to '$priority' (Nice=$nice_value)."
}
# Function to list all registered services
list_services() {

    	echo "Registered Services:"
    	cut -d':' -f1 "$SERVICE_FILE"
}


# Function to show details of a specific service
show_service_details() {

    	alias_name="$1"
    	script_path=$(grep "^$alias_name:" "$SERVICE_FILE" | cut -d':' -f2)
    	if [ -z "$script_path" ]; 
	then

        	echo "Error: No service found with alias '$alias_name'."
        	return
    	fi

    	# Get the Main PID from the systemd service status
    	main_pid=$(systemctl show -p MainPID "$alias_name" | cut -d'=' -f2)

    	# Check if the service is active
    	state=$(systemctl is-active "$alias_name")

    	if [ "$state" == "active" ] && [ "$main_pid" -ne 0 ]; 
	then

        	# Retrieve the priority of the main PID
        	priority=$(ps -o nice= -p "$main_pid" 2>/dev/null)
    	else
        	priority="N/A"  # Set to N/A if not running or no valid PID
        	main_pid="N/A"  # Set to N/A if not running
    	fi
    	echo "Service Details for '$alias_name':"
    	echo
    	echo "PID: $main_pid"        # Use main_pid here
    	echo "State: $state"
    	echo "Priority: ${priority:-20}"  # Default to 20 if priority is empty
    	echo "Script: $script_path"
	#echo "$alias_name, $pid, $state, $script_path"
}
