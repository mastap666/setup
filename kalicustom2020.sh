#!/bin/bash

###################################
###################################
#### Kali Custom - under GPLv3 ####
#### by Patrick Frei           ####
####                           ####
#### Thanks to the community!  ####
###################################
###################################

###Changelog:
#2.00	New version for Kali 2020
#2.01	Bugfix
#2.10	updated  script
#2.20	rebuild script
###


#### Title ####

clear

echo "
   __  _   ____  _      ____         __  __ __  _____ ______   ___   ___ ___       _____   __  ____   ____  ____  ______ 
  |  |/ ] /    || |    |    |       /  ]|  |  |/ ___/|      | /   \ |   |   |     / ___/  /  ]|    \ |    ||    \|      |
  |  ' / |  o  || |     |  |       /  / |  |  (   \_ |      ||     || _   _ |    (   \_  /  / |  D  ) |  | |  o  )      |
  |    \ |     || |___  |  |      /  /  |  |  |\__  ||_|  |_||  O  ||  \_/  |     \__  |/  /  |    /  |  | |   _/|_|  |_|
  |     ||  _  ||     | |  |     /   \_ |  :  |/  \ |  |  |  |     ||   |   |     /  \ /   \_ |    \  |  | |  |    |  |  
  |  .  ||  |  ||     | |  |     \     ||     |\    |  |  |  |     ||   |   |     \    \     ||  .  \ |  | |  |    |  |  
  |__|\_||__|__||_____||____|     \____| \__,_| \___|  |__|   \___/ |___|___|      \___|\____||__|\_||____||__|    |__|  
   
                                  --== V2020 by Patrick Frei - v.2.20 - MAY2020 ==--
											


												
"
#### Intro ####
echo " 
This setup script is designed for Kali Linux 2020.x with XFCE desktop environment
Run this script as sudo -i
 
 
"

#### Check root rights (sudo) ####
if [ $(id -u) -ne 0 ]; then
	echo "You need root rights (sudo)."
	exit
fi


### COLORS  ###

#Colors directly in the script.

cOFF='\e[39m'	  #color OFF / Default color
rON='\e[31m'	  #red color ON
gON='\e[32m'	  #green color ON
yON='\e[33m'	  #yellow color ON


#### Functions #####

funcConfExpand(){
	# expand the bashrc
	echo "alias ls='ls -la --color=auto'" >>/etc/bash.bashrc

	# expand the vimrc
	echo "set number" >>/etc/vimrc
	echo "set bg=dark" >>/etc/vimrc
}

funcKeylayout(){
	# set keyboard layout
	setxkbmap ${keyboard}
	echo "setxkbmap $keyboard" >>/etc/bash.bashrc
	echo ""
	echo Keyboard Layout changed to ${_keyboard}
	echo ""
	sleep 2
}

funcSetwallpaper(){
	# set wallpaper
	cd /usr/share/backgrounds/kali
	wget https://raw.githubusercontent.com/mastap666/oscripts/master/wallpaper/wp1.png
	mv kali-logo-16x9.png kali-logo-16x9.org
	mv kali-light-16x9.png kali-light-16x9.org
	cp wp1.png kali-logo-16x9.png
	cp wp1.png kali-light-16x9.png

}

funcSetpw(){
	#set new root password
	if [ ${_rootpw} == y ]
			then
				echo "

	change root password...
	-------------------

	"
				passwd root
				sleep 5
				
	fi
	echo "

	"

	#set new kali password
	if [ ${_kalipw} == y ]
			then
				echo "

	change kali User password...
	-------------------

	"
				passwd kali
				sleep 5
				
	fi

}

funcDefaulttools(){
	##install tools
	echo "

	Default tools will be installed...
	----------------------------------
	"
	sleep 3
	apt-get update
	sleep 3
	apt-get install ntpdate -y
	apt-get install terminator -y
	apt-get install tshark -y
	mkdir -p /tools

}

funcUpdatetools(){
	#update tools
	nmap --script-updatedb
	searchsploit -u
}

funcGithub(){
	#Github Clones
	if [ ${_git} == "y" ]
			then 
				echo "			
	Github Tools will be cloned...
	----------------------------------

	"

	mkdir -p /tools/gitclone
	cd /tools/gitclone
	git clone https://github.com/OCSAF/freevulnsearch.git 
	git clone https://github.com/OCSAF/freevulnaudit.git
	git clone https://github.com/OCSAF/free-open-auditor.git
	git clone https://github.com/OCSAF/freepwnedcheck.git

	fi
}

funcCustomtools(){
	if [ ${_tools} == "y" ]
			then 
				echo "
				
	Custom tools will be installed...
	----------------------------------

				"
				sleep 2
				#div_tools
				apt-get install ipcalc -y
				apt-get install mtr -y
				apt-get install mtr-tiny -y
				apt-get install tor -y
				apt-get install openvas -y
				#freevulnserach
				apt-get install geoip-bin -y
				apt-get install jq -y
				#freevulnaudit
				apt-get install xlstproc -y
				apt-get install wkhtmltopdf -y
				echo "
				
	tool installations completed...

	"
	fi
}

funcSetntp(){
	#set ntp server
	echo "

	Set ntp server...
	-----------------
	"
	ntpdate ${_ntp}
	sleep 3
}

funcSethostname(){
	# change hostname
	if 	[ ${_hs} == y ]
			then
				read -p "Enter new hostname: " -e _hostname
	fi

	echo "
	Set new hostname...
	-----------------
	"
	echo ${_hostname} >/etc/hostname
	echo "
				
	Your new hostname is ${_hostname}

	"
	sleep 3
}

funcSSHenable(){
	# enable ssh with root access
	if [ ${_ssh} == "y" ]
			then
			echo "

	Setup SSH Server...
	-------------------

	"
				echo SSH will be enabled...
				echo "PubkeyAuthentication yes" >>/etc/ssh/sshd_config
				systemctl enable ssh
				systemctl start ssh

	fi
}

funcTimezone(){
	# set timezone
	timedatectl set-timezone ${_timezone}
}

funcDNSchange(){
	#DNS Quad9 Server
	if [ ${_dns} == y ]
			then
					echo "Quad9 DNS will be configured... "
					echo "nameserver 9.9.9.9" >/etc/resolv.conf
					
	fi
}

funcUpdate(){
	# update kali
	if [ ${_update} == y ]
			then
					echo "Updates will be installed, this takes some time...
					"
					apt-get update -y && apt-get upgrade -y
					
		elif [ ${_rolling} == y ]
			then
					echo "Rolling updates will be installed...
					"
					apt-get dist-upgrade -y
					
		else
					echo "No updates will be installed...
					"

	fi
}




#### MAIN Script ######

## Reads ##

read -p "Choose your keyboard layout (ch;de;us): " -i ch -e _keyboard
read -p "Choose your system time zone (Europe/Zurich): " -i Europe/Zurich -e _timezone
read -p "Choose your ntp server: " -i ch.pool.ntp.org -e _ntp
read -p "Clone Github Tools? (y/n): " -i y -e _git
read -p "Install Custom Tools? (y/n): " -i y -e _tools
read -p "Change Hostname (y/n): " -i n -e _hs
read -p "Enable SSH access? (y/n): " -i n -e _ssh
read -p "Change root password? (y/n): " -i n -e _rootpw
read -p "Change kali user password? (y/n): " -i n -e _kalipw
read -p "Change to Quad9 DNS Server? (y/n): " -i n -e _dns
read -p "Install Kali updates? (y/n): " -i n -e _update
if [ ${_update} == y ]
		then
			read -p "Install also Kali rolling Updates? (y/n): " -i n -e _rolling
else
			_rolling="n"
		
fi		


echo "


" 
echo -e "${yON}<----------------------------------------------------->
Set Keyboard Layout${cOFF}
"
funcKeylayout
echo -e "
${yON}...done${cOFF}
"
echo -e "${yON}<----------------------------------------------------->
Set new Hostname${cOFF}
"
funcSethostname
echo -e "
${yON}...done${cOFF}
"
echo -e "${yON}<----------------------------------------------------->
Set new Passwords${cOFF}
"
funcSetpw
echo -e "
${yON}...done${cOFF}
"
echo -e "${yON}<----------------------------------------------------->
Expand Config Filest${cOFF}
"
funcConfExpand
echo -e "
${yON}...done${cOFF}
"
echo -e "${yON}<----------------------------------------------------->
Set Wallpaper${cOFF}
"
funcSetwallpaper
echo -e "
${yON}...done${cOFF}
"
echo -e "${yON}<----------------------------------------------------->
Install default tools${cOFF}
"
funcDefaulttools
echo -e "
${yON}...done${cOFF}
"
#echo -e "${yON}<----------------------------------------------------->
#Update NMAP and Searchsploit${cOFF}
#"
#funcUpdatetools
#echo -e "
#${yON}...done${cOFF}
#"
echo -e "${yON}<----------------------------------------------------->
Clone Github tools${cOFF}
"
funcGithub
echo -e "
${yON}...done${cOFF}
"
echo -e "${yON}<----------------------------------------------------->
Install Custom tools${cOFF}
"
funcCustomtools
echo -e "
${yON}...done${cOFF}
"
echo -e "${yON}<----------------------------------------------------->
Set NTP Server${cOFF}
"
funcSetntp
echo -e "
${yON}...done${cOFF}
"
echo -e "${yON}<----------------------------------------------------->
Enable SSH Server${cOFF}
"
funcSSHenable
echo -e "
${yON}...done${cOFF}
"
echo -e "${yON}<----------------------------------------------------->
Set Timezone${cOFF}
"
funcTimezone
echo -e "
${yON}...done${cOFF}
"
echo -e "${yON}<----------------------------------------------------->
Set Quad9 DNS Server${cOFF}
"
funcDNSchange
echo -e "
${yON}...done${cOFF}
"
echo -e "${yON}<----------------------------------------------------->
Install Kali Updates${cOFF}
"
funcUpdate
echo -e "
${yON}...done${cOFF}
"



echo -e "${gON}



Script is complete.... Thank you for using!

your machine will reboot in 1 minute....



${cOFF}"
shutdown -r 1

#### END #####
