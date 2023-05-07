  #!/bin/bash
  
  
  
  
  #print menu function
  menu(){
  

  choice=$(whiptail --title "choice" --menu "what do you want to do today?" 25 78 16 \
  "1)" "Add user" \
  "2)" "Modify user" \
  "3)" "List user" \
  "4)" "Add group" \
  "5)" "Modify group" \
  "6)" "List group" 3>&2 2>&1 1>&3
  )
  
  
  
  #This shows exit status
exitstatus=$?
if [ $exitstatus = 0 ]; then
echo "User selected Ok"
echo "User eneterd is $choice"

else
echo "User selected Cancel."
exit

fi
  } 
  

  
  
  #checking user choice >> printing the gui of the chosen command
  check_menu_output(){
  
    
   case $choice in 
   "1)") echo "case 1"
   adduser
   start
   ;;
   
   "2)") echo "case 2"
   modify_user
   start
   ;;
   
   "3)") echo "case 3"
   list_users_menu
   start
   ;;
   
   "4)") echo "case 4"
   add_group
   start
   
   ;;
   
   "5)") echo "case 5"
   modify_group
   start
   ;;
   
   "6)") echo "case 6"
   list_all_groups
   #start
   ;;
   
   *)
    echo -n "Invalid"
    ;;
    
esac

  }
  
  #get username from the user 
  get_user_name(){
  #username gui
  username=$(whiptail --inputbox "Enter username " 8 39 user1 --title "User" 3>&1 1>&2 2>&3)
  
  
  }
  #adding new users 
  adduser(){
  
  #username gui func
    get_user_name
  
  #printing the next gui "user password gui"
  exitstatus=$?
  echo $exitstatus
  
  if [ $exitstatus = 0 ]; then
      echo "must print the next gui "
  #password gui
  echo "you enterd the password gui "
        password=$(whiptail --inputbox "Enter your password " 8 39 user1 --title "password" 3>&1 1>&2 2>&3)
            
       #output=$((sudo adduser $username && echo "$password" | sudo passwd --stdin $username) 2>&1)
      output=$( (sudo adduser $username && echo "$username:$password" | sudo chpasswd) 2>&1 )
            echo "the output file is $output"
            
            
    else
        echo "User selected Cancel."
        start
    fi
    if [ $output="" ]; then
    whiptail --title "Statue" --msgbox "youre user has been created succesfully >> $username" 8 78
    else
    whiptail --title "Statue" --msgbox "$output" 15 78
    fi
  }
  
  
  
  
 #**************************************************************************************************************************** 
  
  
  #printing a gui for the options of modification of the user
  modify_user_menu(){
   choice=$(whiptail --title "user modify" --menu "what do you want to do ?" 25 78 16 \
  "1)" "Add a user to a group" \
  "2)" "Change a user's primary group" \
  "3)" "Change a user's home directory" \
  "4)" "Change a user's password" \
  "5)" "Disable Account" \
  "6)" "Enable Account" \
  "7)" "back" 3>&2 2>&1 1>&3
  )
   
exitstatus=$?
  if [ $exitstatus = 0 ]; then
    echo "User selected Ok and entered " $username
    
else
    echo "User selected Cancel."
    start

fi
  
  }
  
  
  get_group_name(){

group_name=$(whiptail --inputbox "Enter Group name to start edit." 8 39 group1 --title "Group Name" 3>&1 1>&2 2>&3)
  
  
  }
  
  
  get_password(){
  
  PASSWORD1=$(whiptail --passwordbox "please enter your secret password" 8 78 --title "password dialog" 3>&1 1>&2 2>&3)
                                                                     
      exitstatus=$?
      if [ $exitstatus == 0 ]; then
          echo "User selected Ok and entered $PASSWORD1" 
          
                              PASSWORD2=$(whiptail --passwordbox "please enter your secret password" 8 78 --title "password dialog2" 3>&1 1>&2 2>&3)
                              
                              exitstatus=$?
                              if [ $exitstatus == 0 ]; then
                                  echo "User selected Ok and entered $PASSWORD2" 
                              else
                                  echo "User selected Cancel."
                                  modify_user
                                  
                              fi
                              
                              echo "(Exit status was $exitstatus)"
          
          
      else
          echo "User selected Cancel."
          modify_user
          
      fi
      
      echo "pass1 is $PASSWORD1"
      echo "pass2 is $PASSWORD2"
      if [ "$PASSWORD1" == "$PASSWORD2" ]; then 
      echo "password is correct"
       password="$PASSWORD1"
      echo "password is $password"
      
      else  
      whiptail --title "Example Dialog" --msgbox "passwords didn't match" 8 78
      get_password   
      fi
      echo "(Exit status was $exitstatus)"


  }
  
  
  #func that modify users by give the user some options 
  
  modify_user(){
 
  #printing menu for modify user options
   modify_user_menu
 
  

  #- Change a user's home directory: `usermod -d HOME_DIR USER`
  #- Change a user's password
  
#print a input box to write user name that will be modified
  
  
   case $choice in 
   
   #- Add a user to a group: `usermod -a -G GROUP USER`
   "1)") echo "case 1"
 #calling a method that take the usrename from the user 
  get_user_name
   
  exitstatus=$?
    if [ $exitstatus = 0 ]; then
        echo "User selected Ok and entered " $username
        get_group_name
    else
    echo "User selected Cancel."
    modify_user
   fi
   
  sudo usermod -a -G "$group_name" "$username"
   
   ;;
   
   #- Change a user's primary group: `usermod -g GROUP USER`
   "2)") echo "case 2"
    #calling a method that get the usrename from the user 
    get_user_name

     exitstatus=$?
    if [ $exitstatus = 0 ]; then
        echo "User selected Ok and entered " $username
        get_group_name
    else
    echo "User selected Cancel."
    modify_user
   fi
   
    sudo usermod -g "$group_name" "$username" 
   ;;
   #- Change a user's home directory: `usermod -d HOME_DIR USER`
   "3)") echo "case 3"
   
   get_user_name
   
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        echo "User selected Ok and entered " $username
        
                                     home_dir=$(whiptail --inputbox "where do yo want to move your home directory notice that you have to spacified the path /new/home/directory "  20 39  --title "Destnition Dir" 3>&1 1>&2 2>&3)
    
                                        exitstatus=$?
                                        if [ $exitstatus = 0 ]; then
                                            echo "User selected Ok and entered $home_dir" 
                                          sudo  usermod -m -d "$home_dir" "$username"
                                            
                                        else
                                            echo "User selected Cancel."
                                            modify_user
                                            
                                        fi
                                        
                                        echo "(Exit status was $exitstatus)"        
        
        
        
        
        
        
    else
    echo "User selected Cancel."
    modify_user
   fi
   
   ;;
   
   "4)") echo "case 4"
   
   get_user_name
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        echo "User selected Ok and entered " $username
        get_password
    else
    echo "User selected Cancel."
    modify_user
   fi
   
       
  echo "${username}:${password}" | sudo chpasswd
   ;;
   
   "5)") echo "case 5"
    if [ -n "$USER" ]; then
     get_user_name
     sudo usermod --expiredate 1 "$username"
     whiptail --title "Disable User Account" --msgbox "User $username disabled successfully." 20 80
            fi
   ;;
   
   
    "6)") echo "case 6"
    if [ -n "$USER" ]; then
     get_user_name
 	sudo usermod --expiredate "" "$username"
     whiptail --title "Enable User Account" --msgbox "User $username Enable successfully." 20 80
            fi
   ;;
   
   
   *)
    echo -n "back button"
    start
    ;;
    
esac

  
  }
  
  
  
  
  #list users with root or sudo privlage
 
  list_users_menu(){
  
  
   
  choice=$(whiptail --title "choice" --menu "what do you want to do today?" 25 78 16 \
  "Regular users: " "only the non system users" \
  "All users: " "all users including system users "  3>&2 2>&1 1>&3 )
  
   exitstatus=$?
    if [ $exitstatus = 0 ]; then
        echo "User selected Ok and entered $choice"
        
        case $choice in 
   
             "Regular users: ") echo "case Regular users: "
             list_regular_users_data
             
             ;;
             
             *)
              echo  "All users: "
              list_all_users_data
              
              ;;
            
            esac
        
    else
    echo "User selected Cancel."
    
    start    
    
   fi
   
   
  
  }
  

  
  
  
  #read the output of the awk command line by line and save the output in the menu
  
  
  list_all_users_data(){
  
  
 echo "Before while loop"


usernames=()
uids=()
while IFS=' ' read -r username uid; do
    uids+=("$uid")
    usernames+=("$username")
    #the awk command to get all users from passwd
done < <( awk -F':' '{ print $1, $3}' /etc/passwd )

#printing the users with the id 
options=()
for i in "${!uids[@]}"; do
    options+=("${usernames[$i]}" "${uids[$i]}")
   
done



choice=$(whiptail --title "users list" --menu "" 25 78 16 "${options[@]}" 3>&1 1>&2 2>&3)

chosen_userename="$choice"

whiptail --title "User name" --msgbox "You chose username $chosen_userename" 12 78


  
  }
  
  
  
  list_regular_users_data(){
usernames=()
uids=()
while IFS=' ' read -r username uid; do
    uids+=("$uid")
    usernames+=("$username")
    #the awk command to get all users from passwd
done < <( awk -F':' '{ if ($3 >= 1000 && $3 < 65534) print $1, $3}' /etc/passwd )

#printing the users with the id 
options=()
for i in "${!uids[@]}"; do
    options+=("${usernames[$i]}" "${uids[$i]}")
done



choice2=$(whiptail --title "users list" --menu "" 25 78 16 "${options[@]}" 3>&2 2>&1 1>&3)

chosen_userename="$choice2"
echo "$choice"

whiptail --title "User_name " --msgbox "You chose username $chosen_userename" 20 78

  
  }
  
  #*********************************************************************************************
 #creating new groups 
  add_group(){
  #to get group name 
  groupname

          
           #This shows exit status
          exitstatus=$?
          if [ $exitstatus = 0 ]; then
          echo "User selected Ok"
           echo "this group will be created >>$groupname"
      output=$((sudo groupadd "$groupname" ) 2>&1)
      echo "the output file is $output"
       if [ $output="" ]; then
    whiptail --title "Group Added" --msgbox "youre Group has been created succesfully >> $groupname" 8 78
    else
    whiptail --title "Error" --msgbox "$output" 15 78
    fi
          
          else
          echo "User selected Cancel."
          start
          exit
          
          fi
  }
 #********************************************************************************************************************************* 
   #to get group name with gui
  groupname(){
  
  groupname=$(whiptail --inputbox "Enter group name" 8 39 group1 --title "Add Group" 3>&1 1>&2 2>&3)
 
  
  }
  
  
  modify_group(){
  
  
  choice=$(whiptail --title "choice" --menu "what do you want to do ?" 25 78 16 \
  "1)" "Add user to group" \
  "2)" "change group name"   3>&2 2>&1 1>&3
  )
  
  
  
  #This shows exit status
exitstatus=$?
if [ $exitstatus = 0 ]; then
echo "User selected Ok"

        case $choice in 
   
             "1)") echo "Add user to group"
             add_user_to_group
             
             
             ;;
             
             *)
              echo  "change group name"
              change_group_name
              
              ;;
            
            esac

else
echo "User selected Cancel."
start

fi
 
}


add_user_to_group(){
get_group_name
exitstatus=$?
if [ $exitstatus = 0 ]; then
echo "User selected Ok"
get_user_name


output=$((sudo usermod -aG "$group_name" "$username" )2>&1)
    
echo "the output is : $output"

            if [ $output="" ]; then
              whiptail --title "Statue" --msgbox "youre user >> $username has been added to group >> $group_name succesfully." 8 78
              else
              whiptail --title "Statue" --msgbox "$output" 15 78
              fi




else
echo "User selected Cancel."
modify_group

fi
}


change_group_name(){


 whiptail --title "From" --msgbox "Enter the group name yhou want to change" 15 50

get_group_name
exitstatus=$?
output1="$group_name"
echo "this is the output from $output1"


echo "statue : $exitstatus"
if [ $exitstatus = 0 ]; then
echo "user pressed okey"
 whiptail --title "To" --msgbox "choose a new group name" 15 50
get_group_name
exitstatus=$?
output2="$group_name"


if [ $exitstatus = 0 ]; then
echo "user pressed okey"
        output=$((sudo groupmod -n "$output2" "$output1" )2>&1)
        echo "the output file is $output"
  else modify_group
fi  
    if [ $output="" ]; then
              whiptail --title "Statue" --msgbox "youre group >> $output1 has been changed to be group >> $output2 succesfully." 8 78
              else
              whiptail --title "Statue" --msgbox "$output" 15 78
              fi

  
else
echo "User selected Cancel."
modify_group

fi
  
}
  
#***********************************************************************************************  
  
 #lsit all groups in the system 
  
  list_all_groups(){
  

menu_options=$(getent group | awk -F: '{ print $1 , $3}')
choice=$(whiptail --menu "Choose a group" 0 0 0 ${menu_options} 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
echo "User selected Ok"

   
                              #This shows exit status
                            
    list_groups_members
    


else
echo "User selected Cancel."
start


fi
  }
  
  
  
  list_groups_members(){
  

menu_options=$(sudo groupmems -g "$choice" -l | awk -F" " '{ print $0 }')
options=()

for word in $menu_options
do
    options+=("$word" "")
done

  
if [ -z"${options[@]}" ]; then 
whiptail --title "Alert!" --msgbox "This Group has no members" 8 78


else
choice=$(whiptail --title "Menu" --menu "  " 25 78 16 "${options[@]}" 3>&1 1>&2 2>&3)
                          exitstatus=$?
                          if [ $exitstatus = 0 ]; then
                          echo "User selected Ok"
                          
                              else
                              echo "User selected Cancel."
                              list_all_groups
                              fi
echo "You chose: $choice"
fi





  }
  
  
  
  #********************************************************************************************
  
  #excute the the first view
  start(){
  
  menu 
  check_menu_output
  
  }
  ################################################################################################
  
  #welcome function
  whiptail --msgbox --title "project by ahmed eldsoky" "hallo im Ahmed Eldsoky im happy to share withe you my simple project that is use to add and modify users and groups
  
  
  email: ahmedebrahimeldsoky@gmail.com
  phone: 01064647866
  thanks to Eng.Romany Nageh 
  " 25 80
  
  
  start
  
