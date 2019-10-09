#!/bin/bash

######################################

echo " "

if [ "$EUID" -ne 0 ]; then 
 echo "Please run as root (or sudo)."
 echo "Exiting..."
 exit
fi


######################################


# Get date
DATE=$(date '+%Y-%m-%d')


# Get the host ip address
IP=`/bin/hostname -I` 


# Get the operating system and version
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    ...
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    ...
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi



######################################


echo "TECHNICAL NOTE:"
echo "This script was designed to install / setup on the Raspian operating system,"
echo "and was developed / created on Raspbian Linux v10, for Raspberry Pi computers"
echo "WITH SMALL IN-CASE LCD SCREENS."
echo " "
echo "It is ONLY recommended to install this ticker app"
echo "IF your device has an LCD screen installed."
echo " "

echo "Your operating system has been detected as:"
echo "$OS v$VER"
echo " "

echo "This script may work on other Debian-based systems as well, but it has not been tested for that purpose."
echo " "

if [ -f "/etc/debian_version" ]; then
echo "Your system has been detected as Debian-based, which is compatible with this automated installation script."
echo "Continuing..."
echo " "
else
echo "Your system has been detected as NOT BEING Debian-based. Your system is NOT compatible with this automated installation script."
echo "Exiting..."
exit
fi
  				
  				
echo "Select 1 or 2 to choose whether to continue, or quit."
echo " "

OPTIONS="continue quit"

select opt in $OPTIONS; do
        if [ "$opt" = "continue" ]; then
        echo " "
        echo "Continuing with setup..."
        break
       elif [ "$opt" = "quit" ]; then
        echo " "
        echo "Exiting setup..."
        exit
        break
       fi
done

echo " "


######################################


echo "Enter the system username to configure access for:"
echo "(leave blank / hit enter for default of username 'pi')"
echo " "

read SYS_USER
        
if [ -z "$SYS_USER" ]; then
SYS_USER=${1:-pi}
echo "Using default username: $SYS_USER"
else
echo "Using username: $SYS_USER"
fi


if [ ! -d "/home/$SYS_USER/" ]; then    		
echo " "
echo "Directory /home/$SYS_USER/ DOES NOT exist, cannot install DFD Crypto Ticker."
echo " "
echo "Please create user $SYS_USER's home directory before running this installation."
exit
fi

echo " "


######################################

  				
echo "You have set the user information as..."
echo "User: $SYS_USER"
echo "User home directory: /home/$SYS_USER/"
echo " "

echo "If this information is NOT correct, please quit installation and start again."
echo " "

echo "Select 1 or 2 to choose whether to continue, or quit."
echo " "

OPTIONS="continue quit"

select opt in $OPTIONS; do
        if [ "$opt" = "continue" ]; then
        echo " "
        echo "Continuing with setup..."
        break
       elif [ "$opt" = "quit" ]; then
        echo " "
        echo "Exiting setup..."
        exit
        break
       fi
done

echo " "


######################################


         
echo " "

echo "Making sure your system is updated before installation..."

echo " "
			
/usr/bin/sudo /usr/bin/apt-get update

/usr/bin/sudo /usr/bin/apt-get upgrade -y

echo " "
				
echo "Proceeding with required component installation..."
				
echo " "
				
/usr/bin/sudo /usr/bin/apt-get install xdotool lxde unclutter -y

echo " "
				
echo "Required component installation completed."
				
sleep 3
				
echo " "


######################################


echo "Do you want this script to automatically download the latest version of"
echo "DFD Crypto Ticker from Github.com, and install it?"
echo "(auto-install will overwrite / upgrade any previous install located at: /home/$SYS_USER/dfd-crypto-ticker)"
echo " "

echo "Select 1 or 2 to choose whether to auto-install DFD Crypto Ticker, or skip it."
echo " "

OPTIONS="auto_install_ticker_app skip"

select opt in $OPTIONS; do
        if [ "$opt" = "auto_install_ticker_app" ]; then
        
        	
				echo " "
				
				echo "Making sure your system is updated before installing required components..."
				
				echo " "
				
				/usr/bin/sudo /usr/bin/apt-get update
				
				/usr/bin/sudo /usr/bin/apt-get upgrade -y
				
				echo " "
				
				echo "Proceeding with required component installation..."
				
				echo " "
				
				/usr/bin/sudo /usr/bin/apt-get install curl jq bsdtar openssl -y
				
				echo " "
				
				echo "Required component installation completed."
				
				sleep 3
				
				echo " "
				
				echo "Downloading and installing the latest version of DFD Crypto Ticker, from Github.com..."
				
				echo " "
				
				mkdir DFD-Crypto-Ticker
				
				cd DFD-Crypto-Ticker
				
				ZIP_DL=$(/usr/bin/curl -s 'https://api.github.com/repos/taoteh1221/DFD_Crypto_Ticker/releases/latest' | /usr/bin/jq -r '.zipball_url')
				
				/usr/bin/wget -O DFD-Crypto-Ticker.zip $ZIP_DL
				
				/usr/bin/bsdtar --strip-components=1 -xvf DFD-Crypto-Ticker.zip
				
				rm DFD-Crypto-Ticker.zip
				
  				mkdir -p /home/$SYS_USER/dfd-crypto-ticker
  				
				cd dfd-crypto-ticker
				
				# No trailing forward slash here
				\cp -r ./ /home/$SYS_USER/dfd-crypto-ticker
				
				cd ../
				
				\cp LICENSE /home/$SYS_USER/dfd-crypto-ticker/LICENSE
				
				\cp README.txt /home/$SYS_USER/dfd-crypto-ticker/README.txt
				
				\cp TICKER-INSTALL.bash /home/$SYS_USER/dfd-crypto-ticker/TICKER-INSTALL.bash
				
				cd ../
				
				rm -rf DFD-Crypto-Ticker
				
				# No trailing forward slash here
				chown -R $SYS_USER:$SYS_USER /home/$SYS_USER/dfd-crypto-ticker
				
				echo " "
				
				echo "DFD Crypto Ticker has been installed."
				
	        	INSTALL_SETUP=1
   	     	
   	     	

        break
       elif [ "$opt" = "skip" ]; then
        echo " "
        echo "Skipping auto-install of DFD Crypto Ticker."
        break
       fi
done

echo " "



######################################


echo "Do you want to automatically configure DFD Crypto Ticker?"
echo " "

echo "Select 1 or 2 to choose whether to auto-configure DFD Crypto Ticker, or skip it."
echo " "

OPTIONS="auto_config_ticker_app skip"

select opt in $OPTIONS; do
        if [ "$opt" = "auto_config_ticker_app" ]; then
        

				echo " "
				
				echo "Configuring DFD Crypto Ticker..."

				echo " "

				chmod -R 755 /home/$SYS_USER/dfd-crypto-ticker/scripts
			
				ln -s /home/$SYS_USER/dfd-crypto-ticker/scripts/chromium-refresh.bash /home/$SYS_USER/reload
				
				chown $SYS_USER:$SYS_USER /home/$SYS_USER/reload
				
				
					if [ "$SYS_USER" = "pi" ]; then
					
					LXDE_PROFILE="LXDE-pi"
					
					else
					
					echo "The LXDE profile name used by your operating system could not be automatically determined."
					echo " "
					
					echo "Enter the LXDE profile name used by your operating system:"
					echo "(~/.config/lxsession/<profile name>/)"
					echo "(leave blank / hit enter for default of profile name 'LXDE')"
					echo " "
					
					read LXDE_PROFILE
        			
						if [ -z "$LXDE_PROFILE" ]; then
						LXDE_PROFILE=${1:-LXDE}
						echo "Using default profile name: $LXDE_PROFILE"
						else
						echo "Using profile name: $LXDE_PROFILE"
						fi
					
					echo " "

					LXDE_ALERT=1
					
					fi
				
				
				mkdir -p /home/$SYS_USER/.config/lxsession/$LXDE_PROFILE/

				touch /home/$SYS_USER/.config/lxsession/$LXDE_PROFILE/autostart
				
				GLOBAL_LXDE=$(</etc/xdg/lxsession/$LXDE_PROFILE/autostart)

				echo -e "$GLOBAL_LXDE \n@xset s off \n@xset -dpms \n@xset s noblank \n@/bin/bash /home/$SYS_USER/dfd-crypto-ticker/scripts/start-chromium.bash & \n@unclutter -idle 0" > /home/$SYS_USER/.config/lxsession/$LXDE_PROFILE/autostart
				
				chown -R $SYS_USER:$SYS_USER /home/$SYS_USER/.config
				
				touch /etc/cron.d/ticker

				CRONJOB="* * * * * $SYS_USER /bin/bash /home/$SYS_USER/dfd-crypto-ticker/scripts/keep.screensaver.off.bash > /dev/null 2>&1"

				echo "$CRONJOB" > /etc/cron.d/ticker

				chown $SYS_USER:$SYS_USER /etc/cron.d/ticker
				
				echo "Ticker configuration complete."

				echo " "
				
				echo "DFD Crypto Ticker has been configured."
				
	        	CONFIG_SETUP=1
   	     	

        break
       elif [ "$opt" = "skip" ]; then
        echo " "
        echo "Skipping auto-configuration of DFD Crypto Ticker."
        break
       fi
done

echo " "



######################################



######################################


echo "WARNING:"
echo "DO NOT install the 'goodtft LCD-show' LCD drivers below, UNLESS YOU HAVE A 'goodtft LCD-show' LCD SCREEN."
echo " "

echo "Select 1 or 2 to choose whether to install 'goodtft LCD-show' LCD drivers, or skip."
echo " "

OPTIONS="install_goodtft skip"

select opt in $OPTIONS; do
        if [ "$opt" = "install_goodtft" ]; then
         
			
			echo " "
			
			echo "Making sure your system is updated before installing required components..."
			
			echo " "
			
			/usr/bin/sudo /usr/bin/apt-get update
			
			/usr/bin/sudo /usr/bin/apt-get upgrade -y
			
			echo " "
			
			echo "Proceeding with required component installation..."
			
			echo " "
			
			/usr/bin/sudo /usr/bin/apt-get install git -y
			
			echo " "
			
			echo "Required component installation completed."
			
			sleep 3
			
			echo " "
			echo "Setting up for 'goodtft LCD-show' LCD devices..."
			echo " "
			
			ln -s /home/$SYS_USER/dfd-crypto-ticker/scripts/switch-display.bash /home/$SYS_USER/display
				
			chown $SYS_USER:$SYS_USER /home/$SYS_USER/display
			
			mkdir -p /home/$SYS_USER/dfd-crypto-ticker/builds
			
			cd /home/$SYS_USER/dfd-crypto-ticker/builds
			
			/usr/bin/git clone https://github.com/goodtft/LCD-show.git
			
			cd /home/$SYS_USER/dfd-crypto-ticker/
			
			chmod -R 755 /home/$SYS_USER/dfd-crypto-ticker/builds
			
			# No trailing forward slash here
			chown -R $SYS_USER:$SYS_USER /home/$SYS_USER/dfd-crypto-ticker/builds

				
			echo " "
			echo "'goodtft LCD-show' LCD device setup completed."
				
			echo " "
			
			
			GOODTFT_SETUP=1
			
        break
       elif [ "$opt" = "skip" ]; then
        echo " "
        echo "Skipping 'goodtft LCD-show' LCD setup..."
        break
       fi
done

echo " "


######################################


echo " "
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "# SAVE THE INFORMATION BELOW FOR FUTURE ACCESS TO THIS APP #"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo " "


if [ "$LXDE_ALERT" = "1" ]; then

echo "The LXDE profile name used by your operating system could not be automatically determined,"
echo "and the custom profile name '$LXDE_PROFILE' was used."
echo " "

echo "Your LXDE autostart path was setup at:"
echo "/home/$SYS_USER/.config/lxsession/$LXDE_PROFILE/autostart"
echo " "

echo "If the ticker DOES NOT autostart at system boot time, your operating system's"
echo "LXDE profile name PROBABLY IS NOT '$LXDE_PROFILE' after all."
echo " "

echo "You can re-run this install script later on with the proper LXDE profile name if needed."
echo " "

fi


if [ "$GOODTFT_SETUP" = "1" ]; then

echo "Run the below command to configure your 'goodtft LCD-show' LCD screen:"
echo "cd ~/;./display"
echo " "

fi


echo "Edit the following file in a text editor to switch between the"
echo "different Coinbase Pro crypto assets and their paired markets: "
echo "/home/$SYS_USER/dfd-crypto-ticker/apps/ticker/config.js"
echo " "

echo "Example editing config.js in nano by command-line:"
echo "nano ~/dfd-crypto-ticker/apps/ticker/config.js"
echo " "

echo "After updating config.js, reload the ticker with this command:"
echo "cd ~/;./reload"
echo " "

echo "Ticker installation should be complete, unless you saw any error messages on your screen."
echo "You must restart your device to activate the Ticker (it should run automatically at startup when you reboot)."
echo " "

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"


