#!/bin/bash
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi
echo "Start Update"
#cd /usr/bin
rm /usr/bin/menu
wget -q https://raw.githubusercontent.com/ZzZzZzZXCoo/error/main/install.sh && chmod +x install.sh && sed -i -e 's/\r$//' install.sh && ./install.sh
rm install.sh
clear
echo " Update Successfull"
echo " Enjoyy"
