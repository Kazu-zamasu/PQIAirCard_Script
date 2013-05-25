#!/bin/sh
#Applet link
ln -sf /BBADD/bin/busybox /bin/cut
ln -sf /BBADD/bin/busybox /bin/ftpput
ln -sf /BBADD/bin/busybox /bin/dos2unix
ln -sf /BBADD/bin/busybox /bin/sed
ln -sf /BBADD/bin/busybox /bin/basename
ln -sf /BBADD/bin/busybox /bin/diff
ln -sf /BBADD/bin/busybox /bin/sort
ln -sf /BBADD/bin/busybox /bin/uniq
#Following by FtpControl Preparation
#cp -f /mnt/sd/DCIM/FCT/ftpstop.JPG /mnt/sd/DCIM/199_WIFI
#cp -f /mnt/sd/DCIM/FCT/ftpstat.JPG /mnt/sd/DCIM/199_WIFI
#Start to Ftpcontrol.sh make file to JPG data.
/mnt/sd/FtpControl.sh &
#Start to automatically client mode
#sleep 5
#/usr/bin/w2
iwconfig mlan0 power off
sleep 30
iwconfig mlan0 power on
sync
exit 0
