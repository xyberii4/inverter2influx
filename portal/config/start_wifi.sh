#!/bin/bash


#config locations 
config_path="/home/admin/config"

wifi_folder="${config_path}/wifi"

wps_wifi="${wifi_folder}/wps_wifi.conf"
dhcpcd_wifi="${wifi_folder}/dhcpcd_wifi.conf"
dnsmasq_wifi="${wifi_folder}/dnsmasq_wifi.conf"


#system-wide config locations
wps="/etc/wpa_supplicant/wpa_supplicant.conf"
dhcpcd="/etc/dhcpcd.conf"
dnsmasq="/etc/dnsmasq.conf"


#check if wpa_wifi has been edited
wpa_wifi_count=wc -m < $wps_wifi
if [[ $wpa_wifi_count -ne 188 ]] ; then
    #rewrite network files
    sudo cat $wps_wifi > $wps
    echo "Updated wpa_supplicant.conf"
    sleep 2
    sudo cat $dhcpcd_wifi > $dhcpcd
    echo "Updated dhcpcd.conf"
    sleep 2
    sudo cat $dnsmasq_wifi > $dnsmasq
    echo "Updated dnsmasp.conf"
    sleep 2

    echo "Disabling nginx..."
    sudo systemctl disable nginx
    sleep 2

    echo "Restarting network services..."
    sleep 2
    echo "  Refreshing wpa..."
    wpa_cli -i wlan0 reconfigure
    sleep 2
    echo "  Restarting dhcpcd and dnsmasq..."
    systemctl restart dhcpcd dnsmasq
    sleep 2

    echo "Pi successfully starting in client mode"

    #check if Wi-Fi works, otherwise switch back to AP mode
    ((count = 5))
    while [[ $count -ne 0 ]] ; do
        ping -c 1 www.google.com
        rc=$?
        if [[ $rc -ne 0 ]] ; then
            ((count = count - 1))
        else
            sleep 0.5
            ((count = 5))
        fi
    done

    if [[ $rc -ne 0 ]] ; then
        echo "Invalid Wi-Fi connection. Switching to AP mode..."
        /home/admin/config/start_ap.sh
    fi
else
    echo "Wi-Fi network not added. Switching to AP mode..."
    /home/admin/config/start_ap.sh
fi