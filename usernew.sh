#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
exit 0
clear
read -p "Username : " Login
read -p "Password : " Pass
read -p "Expired (hari): " masaaktif
IP=$(wget -qO- icanhazip.com);
domain=$(cat /root/domain);
ssl="$(cat ~/log-install.txt | grep -w "Stunnel4" | cut -d: -f2)"
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
sleep 1
echo Ping Host
echo Cek Hak Akses...
sleep 0.5
echo Permission Accepted
clear
sleep 0.5
echo Membuat Akun: $Login
sleep 0.5
echo Setting Password: $Pass
sleep 0.5
clear
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e ""
echo -e "==============================="
echo -e "Thank You For Using Our Services"
echo -e "SSH & OpenVPN Account Info"
echo -e "Username          : $Login "
echo -e "Password          : $Pass"
echo -e "==============================="
echo -e "ISP               : $ISP"
echo -e "City              : $CITY"
echo -e "Domain            : $domain"
echo -e "Host              : $IP"
echo -e "OpenSSH           : 22"
echo -e "Dropbear          : 109, 143"
echo -e "SSL/TLS           : 443"
echo -e "Port WS SSL       : 443"
echo -e "Port WS HTTP      : 80"
echo -e "Port WS OVPN      : 2082"
echo -e "BadVPN            : 7100-7300"
echo -e "==============================="
echo -e "PAYLOAD 1"
echo -e "GET / HTTP/1.1[crlf]Host: $domain[crlf]Connection: Keep-Alive[crlf]User-Agent: [ua][crlf]Upgrade: websocket[crlf][crlf]"
echo -e "==============================="
echo -e "PAYLOAD 2"
echo -e "CONNECT wss://bug.com/ [protocol][crlf]Host: $domain[crlf]Upgrade: websocket[crlf*2]"
echo -e "==============================="
echo -e "Expired On      : $exp"
