#!/bin/bash

# Global Variables
MONITOR_LEFT='DisplayPort-0'
MONITOR_CENTER='HDMI-0'
MONITOR_RIGHT='DVI-0'

# Functions
bashColors()
{
	RESET="\e[0m"

	BOLD="\e[1m"
	RESET_BOLD="\e[21m"

	DIM="\e[2m"
	RESET_DIM="\e[22m"

	ITALIC="\e[3m"
	RESET_ITALIC="\e[23m"

	UNDERLINE="\e[4m"
	RESET_UNDERLINE="\e[24m"

	BLINK="\e[5m"
	RESET_BLINK="\e[25m"

	INVERT="\e[7m"
	RESET_INVERT="\e[27m"

	HIDDEN="\e[8m"
	RESET_HIDDEN="\e[28m"

	# Colors - Foreground - Texts
	DEFAULT_FOREGROUND_COLOR="\e[39m"
	BLACK="\e[30m"
	RED="\e[31m"
	GREEN="\e[32m"
	YELLOW="\e[33m"
	BLUE='\e[38;5;27m' 	`# BLUE='\e[34m'`
	MAGENTA='\e[35m'
	WHITE="\e[97m"
	CYAN='\e[36m'
	DARK_GREY='\e[90m'
	LIGHT_GREY='\e[37m'
	LIGHT_RED='\e[91m'
	LIGHT_GREEN='\e[92m'
	LIGHT_YELLOW='\e[93m'
	LIGHT_BLUE='\e[38;5;39m'	`# LT_BLUE='\e[94m'`
	LIGHT_MAGENTA="\e[95m"
	LIGHT_CYAN='\e[96m'

	# Colors - Background
	DEFAULT_BACKGROUND_COLOR="\e[49m"
	BACKGROUND_BLACK="\e[40m"
	BACKGROUND_RED="\e[41m"
	BACKGROUND_GREEN="\e[42m"
	BACKGROUND_YELLOW="\e[43m"
	BACKGROUND_BLUE="\e[44m"
	BACKGROUND_MAGENTA="\e[45m"
	BACKGROUND_CYAN="\e[46m"
	BACKGROUND_WHITE="\e[107m"
	BACKGROUND_DARK_GREY="\e[100m"
	BACKGROUND_LIGHT_GREY="\e[47m"
	BACKGROUND_LIGHT_RED="\e[101m"
	BACKGROUND_LIGHT_GREEN="\e[102m"
	BACKGROUND_LIGHT_YELLOW="\e[103m"
	BACKGROUND_LIGHT_BLUE="\e[104m"
	BACKGROUND_LIGHT_MAGENTA="\e[105m"
	BACKGROUND_LIGHT_CYAN="\e[106m"
}

displayOptions ()
{
	bashColors

	for i in `seq 1 35`;
	do
		printf '-'
	done

	echo -e "\n${GREEN}oneScreen${DEFAULT_FOREGROUND_COLOR} ${BLUE}[OPTION]${DEFAULT_FOREGROUND_COLOR}\n"
	echo -e "OPTIONS:\n"
	echo -e "-center\n\tOnly the center screen."
	echo -e "-left\n\tOnly the left screen."
	echo -e "-right\n\tOnly the right screen."
	echo -e "-back\n\tRevert back."

	for i in `seq 1 35`;
	do
		printf '-'
	done
}

switchMonitors ()	
{
	bashColors
	if [ -z $1 ]
	then
	{
		displayOptions
		exit 0
	}
	else
	{
		# Switch to center monitor
		if [ $1 = 'center' ] || [ $1 = 'Center' ] || [ $1 = 'CENTER' ]
			then
			{
				xrandr --output $MONITOR_RIGHT --off --output $MONITOR_LEFT --off --output $MONITOR_CENTER --auto --primary
				echo -e "${BLUE}MAIN MONITOR IS ${MONITOR_CENTER} ${DEFAULT_FOREGROUND_COLOR}"
			}
		# Switch to left monitor
		elif [ $1 = 'left' ] || [ $1 = 'Left' ] || [ $1 = 'LEFT' ]
			then
			{
				xrandr --output $MONITOR_RIGHT --off --output $MONITOR_CENTER --off --output $MONITOR_LEFT --auto --primary
				echo -e "${BLUE}MAIN MONITOR IS ${MONITOR_LEFT} ${DEFAULT_FOREGROUND_COLOR}"
			}
		# Switch to right monitor
		elif [ $1 = 'right' ] || [ $1 = 'Right' ] || [ $1 = 'RIGHT' ]
			then
			{
				xrandr --output $MONITOR_CENTER --off --output $MONITOR_LEFT --off --output $MONITOR_RIGHT --auto --primary
				echo -e "${BLUE}MAIN MONITOR IS ${MONITOR_RIGHT} ${DEFAULT_FOREGROUND_COLOR}"
			}
		# Switch back to all monitors
		elif [ $1 = 'back' ] || [ $1 = 'Back' ] || [ $1 = 'BACK' ]
			then
			{
				xrandr --output $MONITOR_CENTER --auto --primary --output $MONITOR_LEFT --auto --left-of $MONITOR_CENTER --output $MONITOR_RIGHT --auto --right-of $MONITOR_CENTER
				echo -e "${CYAN}ALL MONITORS ARE ON${DEFAULT_FOREGROUND_COLOR}"
			}
		else
		{
			displayOptions
			exit 1
		}
		fi
	}
	fi
}

# Main
switchMonitors $1

exit 0
