#!/bin/bash

# Name: Mohamed Rahaman
# Date: February 12, 2018
# File: xf86-video-ati.bash
# Description: This script
# automates xorg configuration
# files for the xf86-video-ati video
# driver for Arch linux

# Checking for root access
if [[ $EUID -ne 0 ]]
then
	echo "This script must be run as root"
	exit 1
fi

# Check Distribution
if [[ -z $(cat /etc/*-release | grep -o 'Arch Linux') ]]; then
	exit 1
fi

# Variables
AMD_CONFIG_LOCATION=/etc/X11/xorg.conf.d/20-radeon.conf

# Helper Function for headers
header()
{
	for (( i = 0; i < $1; i++ )); do
		printf '-'
	done
	printf '\n'
}

# Logic for each config
configs()
{
    if [[ $1 == 'FULL' ]]; then
        printf "Section \"Device\"\n\tIdentifier \"Radeon\"\n\tDriver \"radeon\"\n\tOption \"AccelMethod\" \"glamor\"\n\tOption \"DRI\" \"3\"\n\tOption \"TearFree\" \"on\"\nEndSection"
    elif [[ $1 == 'JUST_VSYNC' ]]; then
        printf "Section \"Device\"\n\tIdentifier \"Radeon\"\n\tDriver \"radeon\"\n\tOption \"TearFree\" \"on\"\nEndSection"
    fi
}

# Displays the Menu with each config
displayMenu()
{
    if [ $1 == 'Y' ] || [ $1 == 'y' ]; then
		printf "\nYour choices are:\n$(header 40)\n\t1 - Display Configurations\n\t2 - Full Configuration\n\t3 - Vsync Only Configuration\n\t4 - Remove\n\t5 - Quit\nEnter your choice: "
		read MENU_CHOICE

		case $MENU_CHOICE in
			1)
				printf "\nFull Configuration:\n$(header 40)\n$(configs FULL)\n\nVsync Only Configuration:\n$(header 40)\n$(configs JUST_VSYNC)\n\n"
				main
				;;
			2)
            	configs FULL > $AMD_CONFIG_LOCATION
                ;;
            3)
				configs JUST_VSYNC > $AMD_CONFIG_LOCATION
                ;;
			4)
				rm $AMD_CONFIG_LOCATION
				;;
			5)
			exit 0
				;;
			*)
			exit 1
			;;
        esac
	fi
}

# Main Logic
main ()
{
	if [[ -e $AMD_CONFIG_LOCATION ]]; then
		printf "\n\tCurrent Configuration\n"
		header 40
		cat $AMD_CONFIG_LOCATION
		printf '\n'
		header 40
		printf "\nDo you want to make changes to $AMD_CONFIG_LOCATION? (y,n): "
		read CHOICE
		displayMenu $CHOICE
	else
		printf "\nDo you want to add $AMD_CONFIG_LOCATION to xorg configuration? (y,n): "
		read CHOICE
		displayMenu $CHOICE
	fi
}

main
