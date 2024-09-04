#!/bin/bash
#starts the Pi in AP mode

#config locations 
config_path="/home/admin/config/"

ap_folder="${config_path}ap/"

wps_ap="${ap_folder}wps_ap.conf"
dhcpcd_ap="${ap_folder}dhcpcd_ap.conf"
dnsmasq_ap="${ap_folder}dnsmasq_ap.conf"


#system-wide config locations
wps="/etc/wpa_supplicant/wpa_supplicant.conf"
dhcpcd="/etc/dhcpcd.conf"
dnsmasq="/etc/dnsmasq.conf"


#rewrite network files
cat $wps_ap > $wps
echo "Updated wpa_supplicant.conf"
sleep 2

cat $dhcpcd_ap > $dhcpcd
echo "Updated dhcpcd.conf"
sleep 2

cat $dnsmasq_ap > $dnsmasq
echo "Updated dnsmasp.conf"
sleep 2

echo "Enabling nginx..."
systemctl enable nginx
sleep 2

echo "Restarting network services..."
sleep 2
echo "  Refreshing wpa..."
wpa_cli -i wlan0 reconfigure
sleep 2

echo "  Restarting dhcpcd and dnsmasq..."
systemctl restart dhcpcd dnsmasq
sleep 2

echo "Pi started successfully in AP mode"