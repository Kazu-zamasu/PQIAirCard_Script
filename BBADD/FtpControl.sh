#!/bin/sh
sleep 10
if ! [ -s /mnt/sd/DCIM/199_WIFI/WSD00001.JPG ];
then
#This address is PQI w1 mode deffult.
Address=192.168.1.50
else
#get from ftp saver IP address
Address=`grep "FTP_Address" /mnt/mtd/config/wsd.conf|cut -b15-`
fi

while :
do
 #check server live
ping -c1 ${Address}
 live=`echo $?`
 if [ "${live}" = 0 ]
  then
	#Check AUTPRINT.MRK file
	while :
	do
	if [ -s /mnt/sd/MISC/AUTPRINT.MRK ];
	then
	/mnt/sd/DPOFftp.sh
	exit 0
	else
	sleep 3
	continue 2
	fi
	done
 else
 continue
 fi
done
