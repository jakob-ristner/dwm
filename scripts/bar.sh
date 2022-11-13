#!/bin/bash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ./bar_themes/catppuccin

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$red^ ^b$black^ "
  printf " ^c$red^^b$black^$cpu_val "
}

pkg_updates() {
  #updates=$(doas xbps-install -un | wc -l) # void
  updates=$(checkupdates | wc -l)   # arch
  # updates=$(aptitude search '~U' | wc -l)  # apt (ubuntu,debian etc)

  if [ -z "$updates" ]; then
    printf "  ^c$pink^    Fully Updated "
  else
    printf "  ^c$pink^    $updates"" updates "
  fi
}

battery() {
  get_capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
  printf "^c$mauve^  $get_capacity%%"
}

mem() {
  printf "^c$maroon^^b$black^  "
  printf "^c$maroon^$(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g) "
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
    up) printf "^c$peach^^b$black^ 󰤨 ^c$yellow^$(iwgetid -r)" ;;
	down) printf "^c$peach^^b$black^ 󰤭 ^c$yellow^Disconnected" ;;
	esac
}

day() {
	printf "^c$yellow^ ^b$black^ "
	printf "^c$yellow^^b$black^ $(date '+%a %d %B') "
}

clock() {
	printf "^c$green^ ^b$black^ "
	printf "^c$green^^b$black^$(date '+%H:%M')  "
}


while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$updates $(battery) $(cpu) $(mem) $(wlan) $(day) $(clock)"
done
