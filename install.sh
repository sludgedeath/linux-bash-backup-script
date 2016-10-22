#!/bin/sh

mkdir -p '/home/'$(whoami)'/.backup' 
cp 'backup.sh' '/home/'$(whoami)'/.backup' 
chmod +x '/home/'$(whoami)'/.backup/backup.sh'


crontab -l > '/tmp/ccron'
if grep -q "#backup" "/tmp/ccron";then
	echo "#backup cron job exists"
else
	echo "adding new cron job"
	echo '55 0-23/2 * * * /home/'$(whoami)'/.backup/backup.sh #backup' >> '/tmp/ccron'
	crontab '/tmp/ccron'
fi

rm '/tmp/ccron'
