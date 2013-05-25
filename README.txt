PQI_AirCard
===========

PQI Aircard digital camera DPOF function used by ftp sending script.

1.Introduction
This is PQI AirCard modified shell script and wifi ftp setting perl source code.
Normally AirCard can not ftp server files pushing. But, this code can provide you ftp push interface.

2.What this can do
1)To use DPOF function of Digital camera, DPOF selected by images for ftp transfer.

2)To Add to internal MMC automatically.

3)To see AirCard IP address on your web browser.
4)To remake shell script automatically even if the perform disk erases the SD.

3.How to install.
1)Install your smart phone ftp application. Required environment is following.
 -Change the ftp distination folder.
 -Anonymouse access. this script has no support login name and login pin code.
2)Extract PQI firmware zip file.

NOTICE!!!!
If you install PQI card on original firm ware, please install the normal PQI firmware.

3)Elase disk on your SD card.
4)Copy to initramfs3.gz and all files on SD card.
[Following folder tree]
SD
├BBADD
│├autorun.sh
│├DPOFftp.sh
│└FtpControl.sh
├add8arm
├autorun.sh
├dhcp.script
├kcard_edit_config.pl
├kcard_save_config.pl
└rcS

5)Insert your SD card on devices at correct working PQI AirCard.
6)Wait about 5min. (Normal `dd` is required about 250sec, gzip and any shell totally 360sec).

7)Check the SD card files if Following foler tree result is successful.
SD
├MISC
├DCIM
├autorun.sh
├initramfs3.gz
└good.txt

8)If you find error.txt, back to the step 3).
9)Copy to new initramfs3.gz on your HDD.
10)Elase disk the SD.

11)Copy to the SD from your HDD files. copy files are followings.
SD
├initramfs3.gz(Attention! please check this file. this file size about 3M. Old file is 2.6M)
├image3
├autoload.tbl
├mtd_jffs2.bin
└program.bin

12)Update normal firmware method.
13)Done!

Check the directry tree on your SD card.
SD
├MISC
├DCIM
│└199_WIFI
│ ├WSD00001.JPG
│ ├WSD00002.JPG
│ └WSD00003.JPG
├autorun.sh
├DPOFftp.sh
└FtpControl.sh

4.Adbance
You can edit rcS, autorun.sh and etc file. but please notice initramfs3.gz is lessthan 3M.
PQI firmware update is limited by program.bin coded on 3000000byte. if you need to morethan 3M, please edit on the program.bin binary code.

5.Note
When a trouble occurs for a hardware apparatus or the data because of the use of this software by any chance, I do not take the responsibility at all.

6.Licence
BusyBox v1.21.0 (2013-05-09 10:31:21 JST) multi-call binary.
BusyBox is copyrighted by many authors between 1998-2012.
Licensed under GPLv2. See source distribution for detailed
copyright notices.

add8arm is Licensed under GPLv2.

Please ask me without hesitation if you have a question.
my twitter is @ijime110
