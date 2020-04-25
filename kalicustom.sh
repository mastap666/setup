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
#0.1	Initial
#0.2	corrections
#1.0	first runs
#1.10	add more stuff
#1.11	add ssh section
#1.12	add password section
#1.20	add more stuff
#1.21	bugfix
#1.22	change wallpaper
#1.23	change lockscreen wallpaper + time
#1.24	add openvas and move pw change up
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
   
                                  --== by Patrick Frei - v.1.24 - AUG2019 ==--
											


												
"

#### Variables ######
read -p "Choose your keyboard layout (ch;de;us): " -i ch -e keyboard
read -p "Choose your system time zone (Europe/Zurich): " -i Europe/Zurich -e timezone
read -p "Choose your ntp server: " -i ch.pool.ntp.org -e ntp
read -p "Install Vmbox guest tools? (y/n): " -i n -e vbox
read -p "Install Custom Tools? (y/n): " -i y -e tools
read -p "Change Hostname (y/n): " -i n -e hs
if 	[ $hs == y ]
		then
			read -p "Enter new hostname: " -e hostname
	else
			hostname=kali
fi
read -p "Enable SSH with root access? (y/n): " -i n -e ssh
read -p "Change root password? (y/n): " -i n -e password
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
gsettings set org.gnome.desktop.input-sources sources "[('xkb', '$keyboard')]"

# set wallpaper and disable lockscreen
cd ~/Pictures
wget https://raw.githubusercontent.com/mastap666/scripts/master/wallpaper/wp1.jpg
gsettings set org.gnome.desktop.background picture-uri "file:///root/Pictures/wp1.jpg"
gsettings set org.gnome.desktop.screensaver picture-uri "file:///root/Pictures/wp1.jpg"
gsettings set org.gnome.desktop.session idle-delay 0


#set new password
if [ $password == y ]
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

#install tools
echo "Default tools will be installed...
----------------------------------
"
sleep 3
apt-get install ntpdate -y
apt-get install terminator -y
apt-get install chromium -y
cd ~
mkdir tools


#update tools
nmap --script-updatedb
searchsploit -u
geoipupdate

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
			sleep 3
	elif [ $vbox == "y" ]
        then
			apt-get install -y virtualbox-guest-x11 
    




fi



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

Set ntp server...
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
			echo SSH will be enabled with root access...
			echo "PubkeyAuthentication yes" >>/etc/ssh/sshd_config
			echo "PermitRootLogin yes" >>/etc/ssh/sshd_config
			/etc/init.d/ssh enable
			/etc/init.d/ssh start 

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



"

#### END #####
