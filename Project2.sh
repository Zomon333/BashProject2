#!/bin/bash

#Create a list of emails
#Extract a username from left of @ delimiter
#Create a user account using the username, password, ensure that it has a home directory and that the default shell is bash.
	#Also make sure the user needs to change their password on first login.
		#Add each user to the CSI230 group
		#If the user already exists, update their password
	#Send the user an email with their initial username/password (Google "send a gmail from bash 2fa")

#Notes:
#This should run in one execution.
#Have my own email password be entered at runtime, and hide it on entry
#Add the ability to remove the users you just added to facilitate testing. Not graded.

#Deliverables: 1) A github link to script
# 2) A github link to your project notes in markdown format
	#What internet sources did you use for each element of the pseudocode?
	#Notes should have a chronology of your progress
# 3) A googledoc link to your demonstration video where you demonstrate:
	#Show the absence of accounts before the run
	#An email script run using at least 3 student emails, including your instructor's email addresss. Add this last so as not to irritate your instructor with spam during testing.
	#Show a screenshot of one of the received emails (An account under your control)
	#Test your login via SSH using the new credentials
		#You should be directed to change your password
	#Do a repeat run using a single account already created
		#This should result in a simple password change
	#Repeat the login process for that account

####Root check
user=$(id -u)

if [ $user -eq 0 ]; then
	echo -e "You are root user.\n"
else
	echo "Must run as root."
	exit -1
fi

####Global variables
#I read how to use arrays from gnu.org/software/bash/manual/html_node/Arrays.html
declare -a uNamePass
declare -a rawEmail
declare -a lineCount=0
declare -a MAILCONTENT
declare -a contentName

####Functions

#A function which reads the file input to populate the arrays
#I forgot file input so I read some of this from "http://www.linuxhint.com/read_file_line_by_line_bash/"
#It's been reformatted into a function, which takes the read information and concactenates it into a useful string and throws it into an array.
#It also keeps count of how many lines are in the array.
function readFile()
{

	while read line;
	do
			currentLine=$line
			if [ -z $currentLine ]; then
				echo "Cannot create uNamePass from newline"
			else
				rawEmail[$lineCount]=$currentLine
				uNamePass[$lineCount]=$(appendPass $(truncateEmail $currentLine) )
				#Learning to increment a variable came from "http://www.linuxize.com/post/bash-increment-decrement-variable/"
				echo ${uNamePass[lineCount]}
				lineCount=$((lineCount+1))
			fi
	done < $1
}

#A function which removes the address
function truncateEmail()
{
	echo $1 | cut --delimiter=@ -f 1
}

#A function which generates a password and appends it onto the end of a given string
function appendPass()
{
	toAppend=":$(openssl rand -hex 6)"
	toEcho="$1$toAppend"
	echo $toEcho
}

#A function which obtains email and password without displaying password
function getEmailAndPass()
{
	echo "Email: "
	read email
	echo "Password: "
	read -s password
	echo -e "\n"
}

#Function adds a user of a specific name and password, and assigns them the group CSI230
function addUser()
{
	$(useradd -m $1 -p $2 -g CSI230)
	#echo -e "Added "$1" account\n"
}

#Iterates through uNamePass, calling addUser() for all name/password combos
function addUsers()
{
	i=0
	while [ $i -lt $lineCount ]
	do
		USERNAME=$(getUsername ${uNamePass[i]})
		PASSWORD=$(getPass ${uNamePass[i]})
		if [ -z $(grep $(getUsername $USERNAME) /etc/passwd) ]; then
			addUser $(getUsername ${uNamePass[i]}) $(getPass ${uNamePass[i]})
			sendEmail ${rawEmail[i]} $USERNAME $PASSWORD "Scripting Project 2: New User Account Created"
		else
			echo -e $PASSWORD"\n"$PASSWORD | passwd $USERNAME
			passwd -e $USERNAME
			echo "Password updated for "$USERNAME
			sendEmail ${rawEmail[i]} $USERNAME $PASSWORD "Scripting Project 2: Password Updated"
		fi

		rawEmail[i]=""
		setPassReq $(getUsername ${uNamePass[i]})
		i=$((i+1))
	done

}


#A function which takes a formatted string from uNamePass and parses the specific information requested
function getUsername()
{
	echo $1 | cut --delimiter=: -f 1
}

#A function which takes a formatted string from uNamePass and parses the specific information requested
function getPass()
{
	echo $1 | cut --delimiter=: -f 2
}

#A function which sends an email to $1 with the Username $2 and Password $3
function sendEmail()
{
	uName=$(echo $(getUsername ${uNamePass[i]}))
	uPass=$(echo $(getPass ${uNamePass[i]}))
	sudo ssmtp -C/etc/ssmtp/ssmtp.conf -au$email -ap$password $1 << ENDOFFILE
to:$1
from:"Dagan Poulin"
Content-Type:text/html
Subject:$4
<body>
<h2>Username: </h2><pre>$2</pre>
<h2>Password: </h2><pre>$3</pre>
</body>
ENDOFFILE
return 0
}

#Function returns the current date. Acts as a simple alias so I don't need to rewrite a slightly-more-confusing command.
function getDate()
{
	echo $(date --rfc-3339 date)
}

#Function sets the last day to change your password to today and sets the amount of remaining time to zero days, forcing a password change on login.
function setPassReq()
{
	chage --lastday $(getDate) -M 0 $1
	passwd -e $1
}


####Main Script Body
readFile "emails.txt"
getEmailAndPass
addUsers
