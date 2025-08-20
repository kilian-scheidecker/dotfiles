#!/usr/bin/env bash

choice=$(printf " Lock\n󰍃 Logout\n󰤄 Suspend\n󰜉 Reboot\n Shutdown" | rofi -dmenu)
if [[ $choice == " Lock" ]];then
    hyprlock
elif [[ $choice == "󰍃 Logout" ]];then
    pkill -KILL -u "$USER"
elif [[ $choice == "󰤄 Suspend" ]];then
    systemctl suspend
elif [[ $choice == "󰜉 Reboot" ]];then
    systemctl reboot
elif [[ $choice == " Shutdown" ]];then
    systemctl poweroff
fi
