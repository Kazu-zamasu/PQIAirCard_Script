#!/usr/bin/perl
my @SSID, @KEY;
my $AP_SET_NUMS=0;   
my $WPA_KEY_LEN=0;   
my $refresh_sd="/bin/sync; /usr/bin/refresh_sd";
my $dnsd_to_mtd="cp /etc/dnsd.conf /mnt/mtd/config";
my $udhcpd_to_mtd="cp /etc/udhcpd.conf /mnt/mtd/config";
my $backupkey=&get_backup_key();
sub get_backup_key{
    open(my $CONFIG_FILE, "<", "/etc/wsd_backup.conf") or die("Could not open wsd.conf");
    my($Host_KEY_backup);
    while( my $line = <$CONFIG_FILE>){
        chomp($line);
           if($line =~ /Host WPA2 Key Backup : (.*)/){
            $Host_KEY_backup = $1;
        }
   }
   close(CONFIG_FILE);      
   return ($Host_KEY_backup);
}


sub AP_INFO_GET{
   for (my $i=1; $i<31; $i++){
       foreach $Form_key (keys %Form) { 	   
	     if( $Form_key =~ /SSID$i/ ){
             $SSID[$AP_SET_NUMS] = $Form{$Form_key};
			 $AP_SET_NUMS += 1;
	      }
		  
	      if($Form_key =~ /KEY$i/){
	         $KEY[$i-1] = $Form{$Form_key};
	      }
       }	 
   }  
   
   return 1;
}
sub save_config{
   open(CONFIG_FILE, ">/mnt/mtd/config/wsd.conf") or die("Could not open wsd.conf");	
   print CONFIG_FILE "Login-enable : $LOGIN_SET\n";
   print CONFIG_FILE "Login-name : $LOGIN_USR\n";
   print CONFIG_FILE "Login-password : $LOGIN_PWD\n";
   print CONFIG_FILE "[LANGUAGE]\nEnglish\n";
   print CONFIG_FILE "[AP]\n";
   print CONFIG_FILE "AP_ACCOUNT : $AP_SET_NUMS\n";
   for(my $j=0; $j<$AP_SET_NUMS; $j++){
       print CONFIG_FILE "AP_SSID : $SSID[$j]\n";
	   print CONFIG_FILE "AP_Key : $KEY[$j]\n";
   }	   
   print CONFIG_FILE "[FTP]\n";
   print CONFIG_FILE "FTP_Address : $FTP_Address\n";
   print CONFIG_FILE "FTP_Port : $FTP_Port\n";
   print CONFIG_FILE "[Wi-Fi Setting]\n";
   print CONFIG_FILE "WIFISSID : $WIFI_SSID\n";
   print CONFIG_FILE "Host WPA2 Key : $Host_WPA_KEY\n";
   if($WPA_KEY_LEN >= 8)
   {
      print CONFIG_FILE "Host WPA2 Switch : on\n";
      print CONFIG_FILE "Host WPA2 Key Backup : $Host_WPA_KEY\n";
   }
   else
   {
      print CONFIG_FILE "Host WPA2 Switch : \n";
      print CONFIG_FILE "Host WPA2 Key Backup : $backupkey\n";
   }  
   print CONFIG_FILE "Channel : $CHANNEL_SET\n";
   print CONFIG_FILE "My IP Addr : 192.168.$LOCAL_SD_IP1.$LOCAL_SD_IP2\n";
   print CONFIG_FILE "Target IP Addr : 192.168.$Sender_SD_IP1.$Sender_SD_IP2\n";
   my $temp = $LOCAL_SD_IP2+50;
   print CONFIG_FILE "Receiver IP Addr : 192.168.$Sender_SD_IP1.$temp\n";
   if ($Form{WiFi_Mode}){
       print CONFIG_FILE "Auto WiFi Mode : $Form{WiFi_Mode}\n";
   }else{
       print CONFIG_FILE "Auto WiFi Mode: Enable\n";
   } 	   
   print CONFIG_FILE "[MISC]\n";
   close(CONFIG_FILE);   

   `$refresh_sd`;
   open(DNSD_FILE, ">/etc/dnsd.conf") or die("Could not open dnsd.conf");	
   print DNSD_FILE "air.card 192.168.$LOCAL_SD_IP1.$LOCAL_SD_IP2\n";
   close(DNSD_FILE);
   `$dnsd_to_mtd`;
   
   open(UDHCPD_FILE, ">/etc/udhcpd.conf") or die("Could not open udhcpd.conf");	
   $temp = $LOCAL_SD_IP2+50;
   print UDHCPD_FILE "start 192.168.$LOCAL_SD_IP1.$temp\n";
   $temp = $LOCAL_SD_IP2+250;
   print UDHCPD_FILE "end   192.168.$LOCAL_SD_IP1.$temp\n";
   print UDHCPD_FILE "max_leases      10\n";
   print UDHCPD_FILE "interface       mlan0\n";
   print UDHCPD_FILE "lease_file      /var/lib/misc/udhcpd.lease\n";
   print UDHCPD_FILE "option  subnet  255.255.255.0\n";
   print UDHCPD_FILE "option  router  192.168.$LOCAL_SD_IP1.$LOCAL_SD_IP2\n";
   print UDHCPD_FILE "option  dns     192.168.1.1\n";
   print UDHCPD_FILE "option  domain  $DOMAIN_NAME\n";
   print UDHCPD_FILE "option  lease   86400 #1 day of seconds\n";
   print UDHCPD_FILE "option  mtu     1500\n";
   close(UDHCPD_FILE);
   `$udhcpd_to_mtd`;
   system("cp /mnt/mtd/config/wsd.conf /etc/");   
   if($WPA_KEY_LEN >= 8)
   {
       system("cp /mnt/mtd/config/wsd.conf /mnt/mtd/config/wsd_backup.conf");
       system("cp /mnt/mtd/config/wsd_backup.conf /etc/wsd_backup.conf");
   }
   return 1;
}
if($ENV{'REQUEST_METHOD'} eq "POST") {
  read(STDIN, $QueryString, $ENV{'CONTENT_LENGTH'});
} else {
  $type = "display_form";
  $QueryString = $ENV{QUERY_STRING};
}
@NameValuePairs = split (/&/, $QueryString);

foreach $NameValue (@NameValuePairs) {
  ($Name, $Value) = split (/=/, $NameValue);
  $Value =~ tr/+/ /;
  $Value =~ s/%([\dA-Fa-f][\dA-Fa-f])/ pack ("C",hex ($1))/eg;
  $Form{$Name} = $Value;
}

    $AP_SELECTED = $Form{SCAN_AP};
	$LOGIN_SET = $Form{Login_Enable};
	$LOGIN_USR = $Form{Yourname};
	$LOGIN_PWD = $Form{Yourpwd};
    $FTP_Address = $Form{FTP_IP};
	$FTP_Port = $Form{FTP_PORT};
	$WIFI_SSID    = $Form{WIFI_SSID};
    $Host_WPA_KEY = $Form{Host_WPA_KEY};
        $ctr = $Form{ctr};
	$LOCAL_SD_IP1   = 1;
	$LOCAL_SD_IP2   = 1;
	$Sender_SD_IP1  = 1;
	$Sender_SD_IP2  = 1;
	$CHANNEL_SET    = $Form{Channel_Num};
	$DOMAIN_NAME    = AIRCARD;
	
print "Content-type: text/html", "\n\n";
print "<html><head>";
print "<meta http-equiv=\"content-language\" content=\"zh-tw\">";
print "<meta HTTP-EQUIV=\"content-type\" CONTENT=\"text/html; charset=utf-8\">";
print "<title>Save-Config</title>";
print "<style>
<!--
body{
	background-color:#ffffff;
}
-->
</style>";
print "<SCRIPT language=\"JavaScript\">
<!--
       function Disable_Host_WPA2()
	   {
	     window.alert(\"Host WPA2 Key need greater than or equal to eight characters\");
	   }
//-->
</SCRIPT>";	   
print "</head>";
print "<body>";
&AP_INFO_GET();
print "<br><b>AP selected nums </b>$AP_SET_NUMS<br>";
for (my $i=1; $i<=$AP_SET_NUMS; $i++){
    print "Order #$i<br>";
    print "&nbsp;&nbsp;&nbsp;&nbsp;AP_SSID : $SSID[$i-1]<br>";
	print "&nbsp;&nbsp;&nbsp;&nbsp;AP_KEY  : $KEY[$i-1]<br>";
}

print "<br><b>FTP Server Information</b><br>";
print "FTP Sever IP Address: $FTP_Address<br>";
print "FTP Server Port : $FTP_Port<br>";

print "<br><b>WiFi Information</b><br>";
print "SSID :$WIFI_SSID<br>";
$WPA_KEY_LEN = length($Host_WPA_KEY);
if($WPA_KEY_LEN != 0 && $WPA_KEY_LEN >= 8 && $WPA_KEY_LEN <= 63)
{
open(FHD, ">/mnt/mtd/config/hostapd.conf") or die("Could not open hostapd.conf");
print FHD <<EndText;
interface=mlan0
logger_syslog=-1
logger_syslog_level=2
logger_stdout=-1
logger_stdout_level=2
debug=0
dump_file=/tmp/hostapd.dump
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
wpa_group_rekey=600
wpa_gmk_rekey=86400
channel=$CHANNEL_SET
ssid=$WIFI_SSID
wpa_passphrase=$Host_WPA_KEY
EndText
close(FHD);
}
else 
{
    if($WPA_KEY_LEN == 0)
	{
	   system("rm /mnt/mtd/config/hostapd.conf"); 
	}
	else
	{
	   $Host_WPA_KEY="";
	   print "<SCRIPT language=\"JavaScript\">
       <!--
       Disable_Host_WPA2();
       //-->
       </SCRIPT>";
    my $Host_keyfile = "/mnt/mtd/config/hostapd.conf";
    if(-e $Host_keyfile) 
    {
    system("rm /mnt/mtd/config/hostapd.conf");
    }
    else
    {
    } 
}
}
print "Host WPA2 Key : $Host_WPA_KEY<br>";
print "Wireless Channel : $CHANNEL_SET<br>";
if ($Form{WiFi_Mode} eq "Disable"){
print "WiFi Auto On : Disable<br>";
}else{
print "WiFi Auto On : Enable<br>";
}
my $save_result = &save_config();
if ($save_result){
   print "<br><br><h4>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; !! <I>System configureation file saved successfully. !!</I></h4><br>";
}
print "</body></html>";
