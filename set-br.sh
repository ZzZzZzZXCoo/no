#!/bin/bash
curl https://rclone.org/install.sh | bash
printf "q\n" | rclone config
wget -q -O /root/.config/rclone/rclone.conf "https://raw.githubusercontent.com/ZzZzZzZXCoo/no/main/rclone.conf"
git clone  https://github.com/magnific0/wondershaper.git
cd wondershaper
make install
cd
rm -rf wondershaper
echo > /home/limit
apt install msmtp-mta ca-certificates bsd-mailx -y
cat<<EOF>>/etc/msmtprc
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

account default
host smtp.gmail.com
port 587
auth on
user nobackup
from nobackup
nobackup
logfile ~/.msmtp.log
EOF
chown -R www-data:www-data /etc/msmtprc
cd /usr/bin
wget -q -O autobackup "https://raw.githubusercontent.com/ZzZzZzZXCoo/no/main/autobackup.sh"
wget -q -O backup "https://raw.githubusercontent.com/ZzZzZzZXCoo/no/main/backup.sh"
wget -q -O bckp "https://raw.githubusercontent.com/ZzZzZzZXCoo/no/main/bckp.sh"
wget -q -O restore "https://raw.githubusercontent.com/ZzZzZzZXCoo/no/main/restore.sh"
wget -q -O strt "https://raw.githubusercontent.com/ZzZzZzZXCoo/no/main/strt.sh"
wget -q -O limit-speed "https://raw.githubusercontent.com/ZzZzZzZXCoo/no/main/limit-speed.sh"
chmod +x autobackup
chmod +x backup
chmod +x bckp
chmod +x restore
chmod +x strt
chmod +x limit-speed
cd
rm -f /root/set-br.sh

