setxkbmap -option caps:escape

dwm_networkmanager () {
    CONNAME=$(nmcli -a | grep 'Wired connection' | awk 'NR==1{print $1}')
    if [ "$CONNAME" = "" ]; then
        CONNAME=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -c 5-)
   fi

    PRIVATE=$(nmcli -a | grep 'inet4 192' | awk '{print $2}')
	printf "%s %s %s" "$CONNAME" "$PRIVATE"
}

dwm_keyboard () {
	printf "%s" "$(setxkbmap -query | awk '/layout/{print $2}')"
}

while true; do

        LOCALTIME=$(date '+ %A   %B   %d   %R ')
        DISKHOME=$(df -Ph | grep "/home$" | awk {'print $4 " (" $5 " )"'})
        MEM=$(free -h --kilo | awk '/^Mem:/ {print $3 "/" $2}')
        CPU=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
        xsetroot -name " $LOCALTIME | $(dwm_keyboard) | HOME: $DISKHOME | $(dwm_networkmanager) | MEM: $MEM | CPU: $CPU"
        sleep 1s
done &

exec dwm
