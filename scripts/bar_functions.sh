#!/bin/bash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/git/dwm/scripts/bar_themes/catppuccin


vol() {
    amixer sget Master | grep 'off' &> /dev/null
    if [ $? -eq 0 ] 
    then 
        printf "^c$pink^^b$black^婢 "
    else
        printf "^c$pink^^b$black^墳 "
    fi
    value="$(awk -F"[][]" '/Left:/ { print $2 }' <(amixer sget Master))"
    printf "^c$pink^^b$black^$value%"
}

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$red^^b$black^"
  printf " ^c$red^^b$black^$cpu_val"
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
        printf "^c$mauve^^b$black^$icon "
    else
        printf "^c$mauve^^b$black^ﴞ "
    fi
    get_capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
    printf "^c$mauve^^b$black^$get_capacity%%"
}

mem() {
  printf "^c$maroon^^b$black^ "
  printf "^c$maroon^$(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
    up) printf "^c$peach^^b$black^󰤨 ^c$yellow^$(iwgetid -r)" ;;
	down) printf "^c$peach^^b$black^󰤭 ^c$yellow^Disconnected" ;;
	esac
}

day() {
	printf "^c$yellow^^b$black^ "
	printf "^c$yellow^^b$black^$(date '+%a %d %B')"
}

clock() {
	printf "^c$green^^b$black^ "
	printf "^c$green^^b$black^$(date '+%H:%M')"
}

bar() {
    xsetroot -name "$(vol)   $(battery)   $(cpu)   $(mem)   $(wlan)   $(day)   $(clock)  "
}

bar


