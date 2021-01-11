#!/bin/sh -e

echo
echo "*** Simple WiFi setup utility ***"
echo
echo "Available networks:"
echo

i=0
iw dev wlan0 scan | grep 'SSID: ' | sed -e 's/^.*SSID: //' > /tmp/networks.txt
while IFS="" read -r ssid || [ -n "$ssid" ]
do
    echo "    $i. $ssid"
    i=`expr $i + 1`
done < /tmp/networks.txt

if [ $i -ge 1 ]
then
    echo "Enter the number of your network:"
    read network_number
    if [ "$network_number" -ge 0 ]
    then
        echo
    fi
else
    echo "No network found"
    exit 1
fi

selected_network=$network_number
final_ssid=""
i=0
while IFS="" read -r ssid || [ -n "$ssid" ]
do
    if [ $i -eq $selected_network ]
    then
        final_ssid=$ssid
    fi
    i=`expr $i + 1`
done < /tmp/networks.txt

if [ "$final_ssid" == "" ]
then
    echo "Wrong network number"
    exit 1
else
    echo "Selected network is: $final_ssid"
    # Read Password
    echo -n Password:
    read -s password
    echo
    # Run Command
    wpa_passphrase "$final_ssid" "$password" | grep -v '#psk' > /etc/wpa_supplicant.conf
fi


