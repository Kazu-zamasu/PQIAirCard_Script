#!/bin/sh
iwconfig mlan0 power off
#* Follow is P2P ftp transport adhoc *
detect1=`find /mnt/sd/DCIM/199_WIFI -regex /mnt/sd/DCIM/199_WIFI/WSD00001.JPG`
if [ ${detect1} != /mnt/sd/DCIM/199_WIFI/WSD00001.JPG ];
then
#This address is PQI w1 mode deffult.
Address=192.168.1.50
else
#get from ftp saver IP address
Address=`grep "FTP_Address" /mnt/mtd/config/wsd.conf|cut -b15-`
FtpPort=`grep "FTP_Port" /mnt/mtd/config/wsd.conf|cut -b12-`
fi

#check server live
ping -c10 ${Address}
go=`echo $?`
if [ "${go}" = 0 ]
then
sync

#Check the ftp result.
test -s /mnt/sd/MISC/ftp_fail_number ;
ftp_fail=`echo $?`
test -s /mnt/sd/MISC/ftp_read_list ;
ftp_result_check=`echo $?`
#select file
if [ 0 = "${ftp_fail}" -o 0 = "${ftp_result_check}" ];
#ftp fail retry
then
> /mnt/sd/MISC/ftp_remain_list
sync
diff /mnt/sd/MISC/ftp_send_list /mnt/sd/MISC/ftp_read_list|sed -e "1,3d"|grep "^+"|cut -c2- > /mnt/sd/MISC/ftp_remain_list
readfilename=`cat "/mnt/sd/MISC/ftp_remain_list"`
sync
#ftp file select the remaining.
	if [ 0 = "${ftp_fail}" ];
	then
	ftp_error=`grep "ftp" /mnt/sd/MISC/ftp_fail_number`
	readfilename=`echo "/mnt/sd/MISC/ftp_read_list"`
	sync
	test -s /mnt/sd/MISC/ftp_remain_list ;
	ftp_remain_check=`echo $?`
	> /mnt/sd/MISC/ftp_error_pass
	while read error
	do
	passno=`echo "${error}"|cut -c-3|sed 's/  *$//g'`
	result=`cat "${readfilename}"|sed -n ${passno}p`
	echo ${result} >> /mnt/sd/MISC/ftp_error_pass
	sync
	done < /mnt/sd/MISC/ftp_fail_number
	 if [ 0 = "${ftp_remain_check}" ];
	   then
	   cat /mnt/sd/MISC/ftp_remain_list >> /mnt/sd/MISC/ftp_error_pass
	   sort /mnt/sd/MISC/ftp_error_pass|uniq > /mnt/sd/MISC/ftp_resend_list
	   sync
	  fi
	rm -f /mnt/sd/MISC/ftp_remain_list
	rm -f /mnt/sd/MISC/ftp_error_pass
	readfilename=`cat /mnt/sd/MISC/ftp_resend_list`
#ftp normal
	fi
#ftp first time sending.
else
dos2unix /mnt/sd/MISC/AUTPRINT.MRK
readfilename=`grep "JPG" /mnt/sd/MISC/AUTPRINT.MRK|cut -c 13-|sed -e 's/"//g' -e 's/>//g' -e 's:..:/mnt/sd:'`
echo "${readfilename}" > /mnt/sd/MISC/ftp_read_list
sync
rm -f /mnt/sd/MISC/ftp_remain_list
rm -f /mnt/sd/MISC/ftp_fail_number
rm -f /mnt/sd/MISC/ftp_fail_numbere
sync
sync
fi

#Ftp start
i=0
> /mnt/sd/MISC/ftp_send_list
> /mnt/sd/MISC/ftp_fail_number
sync

echo "${readfilename}"|while read line
do
i=$((i + 1))
sendfilename=`basename ${line}`
ftpput -P${FtpPort} ${Address} ${sendfilename} ${line} 2>> /mnt/sd/MISC/ftp_fail_number
ftpcheck=`echo $?`
if [ "${ftpcheck}" = 0 ];
then
echo ${line} >> /mnt/sd/MISC/ftp_send_list
else
sed -in '$s'"/^/${i}  /" /mnt/sd/MISC/ftp_fail_number
fi
sync
done
	if [ -s /mnt/sd/MISC/ftp_fail_number ];
	then
    	  sync
	else
	  rm -f /mnt/sd/MISC/ftp_send_list
	  rm -f /mnt/sd/MISC/ftp_read_list
          rm -f /mnt/sd/MISC/ftp_remain_list
	  rm -f /mnt/sd/MISC/ftp_fail_number
	  rm -f /mnt/sd/MISC/ftp_fail_numbern
          rm -f /mnt/sd/MISC/ftp_error_pass
	  rm -f /mnt/sd/MISC/ftp_resend_list
	  rm -f /mnt/sd/MISC/AUTPRINT.MRK
	  sync
	fi
else
iwconfig mlan0 power on
/mnt/sd/FTPControl.sh
exit 0
fi
iwconfig mlan0 power on
sync
exit 0
