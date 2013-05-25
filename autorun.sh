#!/bin/sh
ln -sf /mnt/sd/BBTemp/bin/busybox /bin/gunzip
ln -sf /mnt/sd/BBTemp/bin/busybox /bin/gzip
ln -sf /mnt/sd/BBTemp/bin/busybox /bin/cpio
ln -sf /mnt/sd/BBTemp/bin/busybox /bin/dd
file1=`find /mnt/sd/ -regex /mnt/sd/initramfs3.gz`
file2=`find /mnt/sd/ -regex /mnt/sd/good.txt`
if [ "${file1}" = "/mnt/sd/initramfs3.gz" -a "${file2}" != "/mnt/sd/good.txt" ];
then
	cd
	#"Prepare the working dir."
	`mkdir working`
	#"Cut on 8byte file header, and rename file."
	`dd if=/mnt/sd/initramfs3.gz of=/mnt/sd/initramfs.gz bs=1 skip=8`
	`rm /mnt/sd/initramfs3.gz`
	#"Extract on file."
	`gunzip /mnt/sd/initramfs.gz`
	#"Change to the working Dir."
	cd working
	sleep 1
	#"Expand the file to a directory."
	`cpio -i < /mnt/sd/initramfs`
	#"Copy to the new dir of BusyBox."
	`cp -fr /mnt/sd/BBADD /working/BBADD`
	`cp -f /mnt/sd/rcS /working/etc/init.d/rcS`
	`cp -f /mnt/sd/dhcp.script /working/etc/dhcp.script`
	`cp -f /mnt/sd/kcard_edit_config.pl /working/www/cgi-bin/kcard_edit_config.pl`
	`cp -f /mnt/sd/kcard_save_config.pl /working/www/cgi-bin/kcard_save_config.pl`
	#"Make the initramfs3 update file."
	`find ./ | cpio --create --format='newc' | gzip > /mnt/sd/initramfs.gz`
	#"Added to the 8byte to the header of the file. Make the new update firmware."
	`/mnt/sd/add8arm /mnt/sd/initramfs.gz /mnt/sd/initramfs3.gz`
	#"Delete temp files"
	`rm -f /mnt/sd/initramfs.gz`
	`rm -f /mnt/sd/rcS`
	`rm -f /mnt/sd/dhcp.script`
	`rm -f /mnt/sd/add8arm`
	`rm -f /mnt/sd/initramfs`
	`rm -f /mnt/sd/kcard_edit_config.pl`
	`rm -f /mnt/sd/kcard_save_config.pl`
	`rm -f /mnt/sd/BBADD/FtpControl.sh`
	`rm -f /mnt/sd/BBADD/autorun.sh`
	`rm -f /mnt/sd/BBADD/DPOFftp.sh`
	`rm -f /mnt/sd/BBADD/bin/busybox`
	`rmdir /mnt/sd/BBADD/bin`
	`rmdir /mnt/sd/BBADD`
	`rm -f /mnt/sd/BBTemp/bin/busybox`
	`rmdir /mnt/sd/BBTemp/bin`
	`rmdir /mnt/sd/BBTemp`
	`rm -f /mnt/sd/initramfs.sh`

	#"Change the permission 777."
	`chmod -R 777 /mnt/sd`
	echo Script good > /mnt/sd/good.txt
	sync
else
	echo Script Error please format and restart > /mnt/sd/error.txt
	`chmod -R 777 /mnt/sd`

fi
