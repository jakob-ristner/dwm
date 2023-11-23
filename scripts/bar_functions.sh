#!/bin/bash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
#. ~/git/dwm/scripts/bar_themes/catppuccin
. ~/git/dwm/scripts/bar_themes/nord


vol() {
    amixer sget Master | grep 'off' &> /dev/null
    if [ $? -eq 0 ] 
    then 
        printf "^c$blue^^b$black^  "
    else
        printf "^c$blue^^b$black^  "
    fi
    value="$(awk -F"[][]" '/Left:/ { print $2 }' <(amixer sget Master))"
    printf "^c$blue^^b$black^$value%"
}


battery() {
    acpi --ac-adapter | grep 'off' &> /dev/null
    if [ $? -eq 0 ] 
    then 
        value=$(upower -i $(upower -e | grep 'BAT') | awk '/percentage/ {print substr($2, 1, length($2) - 1)}')

        if (($value>98))
        then
            icon=" "
        elif (($value>75))
        then
            icon=" "
        elif (($value>40))
        then
            icon=" "
        elif (($value>10))
        then
            icon=" "
        else
            icon=" "
        fi
        printf "^c$green^^b$black^$icon  "
    else
        printf "^c$green^^b$black^  "
    fi
    get_capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
    printf "^c$green^^b$black^$get_capacity%%"
}


wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
    up) printf "^c$red^^b$black^  ^c$red^$(iwgetid -r)" ;;
	down) printf "^c$red^^b$black^󰤭  ^c$red^Disconnected" ;;
	esac
}

day() {
	printf "^c$yellow^^b$black^  "
	printf "^c$yellow^^b$black^$(date '+%a %d %B')"
}

clock() {
	printf "^c$darkblue^^b$black^  "
	printf "^c$darkblue^^b$black^$(date '+%H:%M')"
}

bar() {
    xsetroot -name "$(vol)   $(battery)   $(wlan)   $(day)   $(clock)  "
}

bar


