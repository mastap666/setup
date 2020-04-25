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
###


# Title
clear

echo "
   __  _   ____  _      ____         __  __ __  _____ ______   ___   ___ ___       _____   __  ____   ____  ____  ______ 
  |  |/ ] /    || |    |    |       /  ]|  |  |/ ___/|      | /   \ |   |   |     / ___/  /  ]|    \ |    ||    \|      |
  |  ' / |  o  || |     |  |       /  / |  |  (   \_ |      ||     || _   _ |    (   \_  /  / |  D  ) |  | |  o  )      |
  |    \ |     || |___  |  |      /  /  |  |  |\__  ||_|  |_||  O  ||  \_/  |     \__  |/  /  |    /  |  | |   _/|_|  |_|
  |     ||  _  ||     | |  |     /   \_ |  :  |/  \ |  |  |  |     ||   |   |     /  \ /   \_ |    \  |  | |  |    |  |  
  |  .  ||  |  ||     | |  |     \     ||     |\    |  |  |  |     ||   |   |     \    \     ||  .  \ |  | |  |    |  |  
  |__|\_||__|__||_____||____|     \____| \__,_| \___|  |__|   \___/ |___|___|      \___|\____||__|\_||____||__|    |__|  
   
                                  --== V2020 by Patrick Frei - v.2.10 - APR2020 ==--
											


												
"
#### Intro ####
echo " 
This setup script is designed for Kali Linux 2020.x with XFCE desktop environment
Run this script as sudo -i
 
 
"

#### Check root rights (sudo) before execution ####
if [ $(id -u) -ne 0 ]; then
	echo "You need root rights (sudo)."
	exit
fi


#### Variables ######
read -p "Choose your keyboard layout (ch;de;us): " -i ch -e keyboard
read -p "Choose your system time zone (Europe/Zurich): " -i Europe/Zurich -e timezone
read -p "Choose your ntp server: " -i ch.pool.ntp.org -e ntp
read -p "Clone Github Tools? (y/n): " -i y -e git
read -p "Install Custom Tools? (y/n): " -i y -e tools
read -p "Change Hostname (y/n): " -i n -e hs
if 	[ $hs == y ]
		then
			read -p "Enter new hostname: " -e hostname
	else
			hostname=kali
fi
read -p "Enable SSH access? (y/n): " -i n -e ssh
read -p "Change root password? (y/n): " -i n -e rootpw
read -p "Change kali user password? (y/n): " -i n -e kalipw
read -p "Change to Quad9 DNS Server? (y/n): " -i n -e dns
read -p "Install Kali updates? (y/n): " -i n -e update
if [ $update == y ]
		then
			read -p "Install Kali rolling Updates? (y/n): " -i n -e rolling
	else
			rolling="n"
		
fi		
echo "

" 


#### main script #####

# expand the ls command
sleep 2

echo "alias ls='ls -la --color=auto'" >>~/.bashrc
alias ls='ls -la --color=auto'



# set keyboard layout
setxkbmap $keyboard
echo "setxkbmap $keyboard" >>~/.bashrc

# set wallpaper and disable lockscreen
cd /usr/share/backgrounds/
wget https://raw.githubusercontent.com/mastap666/scripts/master/wallpaper/wp1.jpg
xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/image-path --set /usr/share/backgrounds/wp1.jpg
xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/last-image --set /usr/share/backgrounds/wp1.jpg
xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/last-single-image --set /usr/share/backgrounds/wp1.jpg
xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor1/image-path --set /usr/share/backgrounds/wp1.jpg
xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor1/last-image --set /usr/share/backgrounds/wp1.jpg
xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor1/last-single-image --set /usr/share/backgrounds/wp1.jpg
xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitorVirtual1/workspace0/last-image --set /usr/share/backgrounds/wp1.jpg
xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitorVirtual1/workspace1/last-image --set /usr/share/backgrounds/wp1.jpg


#set new root password
if [ $rootpw == y ]
		then
			echo "

change root password...
-------------------

"
			sleep 2
			passwd root
			sleep 5
			
fi
echo "

"

#set new kali password
if [ $kalipw == y ]
		then
			echo "

change kali User password...
-------------------

"
			sleep 2
			passwd kali
			sleep 5
			
fi
echo "

"

#install tools
echo "Default tools will be installed...
----------------------------------
"
sleep 3
apt-get update
sleep 3
echo "ntpdate"
apt-get install ntpdate -y
#apt-get install terminator -y
echo "tools"
cd /
mkdir tools

#update tools
# nmap --script-updatedb
# searchsploit -u


#Github Clones
if [ $git == "y" ]
		then 
			echo "
			
Github Tools will be cloned...
----------------------------------

"
sleep 3

mkdir /tools/gitclone
cd /tools/gitclone
git clone https://github.com/OCSAF/freevulnsearch.git 
git clone https://github.com/OCSAF/freevulnaudit.git
git clone https://github.com/OCSAF/free-open-auditor.git
git clone https://github.com/OCSAF/freepwnedcheck.git




if [ $tools == "y" ]
		then 
			echo "
			
Custom tools will be installed...
----------------------------------

			"
			sleep 3
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



#set ntp server
echo "

Set ntp server...
-----------------
"
ntpdate $ntp
sleep 3

# change hostname
if [ $hs == y ]
		then
			echo "

Set new hostname...
-----------------
"
			echo $hostname >/etc/hostname
			echo "
			
Your new hostname is $hostname

"

fi

# enable ssh with root access
if [ $ssh == "y" ]
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
echo "
"
sleep 3
# set timezone
timedatectl set-timezone $timezone



#DNS Quad9 Server
if [ $dns == y ]
		then
				echo "Quad9 DNS will be configured... "
				echo "nameserver 9.9.9.9" >/etc/resolv.conf
				
fi

# update kali
if [ $update == y ]
        then
                echo "Updates will be installed, please hold the line..."
				sleep 3
                apt-get update -y && apt-get upgrade -y
				
	elif [ $rolling == y ]
		then
				echo "Rolling updates will be installed..."
				apt-get dist-upgrade -y
                
	else
                echo "No updates will be installed..."

fi


echo "



Script is complete.... Thank you for using!



your machine will reboot in 1 minute....



"
shutdown -r 1

#### END #####
