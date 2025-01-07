#!/bin/bash


# action to be perform 
action=$1


name=$2

# groupname to add in secondary group 
groupname=$3

# default team of every user to be added
Team="NinjaTeam"

# group file of every user

gfile="groupfile.txt"

# user file 
ufile="userfile.txt"


# used case statement for performing the task
case $action in

	addTeam)
		sudo groupadd "$name"

		if [ $? -eq 0 ]; then
        		echo "$2 group added successfully"
        		echo "$2" >> "$gfile"
    		else
        		echo "Kindly enter an another group name !!"
   		 fi

		;;

	addUser)
		sudo useradd -G "$groupname","$Team" -m -d /home/"$name" -s /bin/bash "$name"
		if [ $? -eq 0 ]; then
			sudo chmod 751 /home/"$name"
               		sudo mkdir -p /home/"$name"/team
                	sudo mkdir -p /home/"$name"/ninja
			sudo chown -R $name:$groupname /home/"$name"/team
			sudo chown -R $name:$Team /home/"$name"/ninja

                	sudo chmod 770 /home/"$name"/team
                	sudo chmod 770 /home/"$name"/ninja

                        echo "$name user added successfully"
                        echo "$2" >> "$ufile"
                
                else
                        echo "Kindly enter an another user username !!"
                 fi
		;;

	changeShell)
		sudo usermod -s "$groupname" "$name"
		if [ $? -eq 0 ]; then
			echo "Shell changed for $name to $groupname successfully !"
		else
			echo "User does not exist or invalid shell path. Kindly check!"
		fi
		;;
	
	changePasswd)
		sudo chage -d 0 $name
                if [ $? -eq 0 ]; then
                        echo "Successfully !! User $name need to change their password on next login"
		fi

		;;

	delUser)
		sudo userdel -r $name
		if [ $? -eq 0 ]; then
                        echo "User deleted successfully !!"
                fi

		;;

	delTeam)
		sudo groupdel $name
                if [ $? -eq 0 ]; then
                        echo "Team deleted successfully !!"
                fi

		;;
	
	ls)

		if [ "$name" = "User" ]; then

			echo "User List"
			echo "-----------"
			cat userfile.txt
			echo "-----------"

		elif [ "$name" = "Team" ]; then
			echo "-----------"
			echo "Group List"
			cat groupfile.txt
			echo "-----------"
		else
			echo "Wrong Input !!"
		fi
		;;

	*)
		echo "Wrong action selected !!"
	

esac
