#!/usr/bin/perl
my $HWDEV="mlan0";
my $iwlist_scan="iwlist $HWDEV scan > /tmp/iwlist_scan.txt"; 
my $WiFi_channel;
my $Host_Switch_LEN=0;
sub wireless_scan{
    if(`$iwlist_scan`){
	}	
    open(my $WIRELESS_FILE, "<", "/tmp/iwlist_scan.txt") or die("Could not open iwlist_scan.txt");
  
    my (@WLAN_SSID);	
	$WLAN_SSID[0][0]="None";
	$WLAN_SSID[0][1]="Off";
	
	my $i=1,$j=0;
	
    while( my $line = <$WIRELESS_FILE> ){
        chomp($line);
        if($line=~/^.*ESSID:"(.*)\"/){		   		  
		   $WLAN_SSID[$i][0]=$1;		   		   
        }
        if($line=~/^.*Encryption key:(.*)/){
		   $WLAN_SSID[$i][1]=$1;		   
		   $i++;		  
		}
   }
     close(WIRELESS_FILE);
	 return (@WLAN_SSID);
}
sub login_enable{
    open(my $CONFIG_FILE, "<", "/etc/wsd.conf") or die("Could not open wsd.conf");	
	my ($LOGIN_ENABLE, $LOGIN_USER, $LOGIN_PWD);
	while( my $line = <$CONFIG_FILE> ){
        chomp($line);		
        if($line=~/Login-enable : (.*)/){		   		  
		   $LOGIN_ENABLE=$1;
           		   
        }
		if($line=~/Login-name : (.*)/){
		   $LOGIN_USER=$1;
		}
        if($line=~/Login-password : (.*)/){
		   $LOGIN_PWD=$1;
		}        
   }
   close(WIRELESS_FILE);   
   return ($LOGIN_ENABLE, $LOGIN_USER, $LOGIN_PWD);
}
sub ap_setup{
   open(my $CONFIG_FILE, "<", "/etc/wsd.conf") or die("Could not open wsd.conf");	
   my ($AP_COUNT,$AP_FIND);
   my ($i);
   while( my $line = <$CONFIG_FILE>){
       chomp($line);
	   if($line =~ /AP_ACCOUNT : (.*)/){
	      $AP_COUNT = $1;
          $AP_FIND=1;		  
	   }
	   if( $AP_FIND == 1 && $line =~ /AP_SSID : (.*)/){
	       $AP_INFO[$i]=$1;
		   $i++;
	   }
	   if( $AP_FIND == 1 && $line =~ /AP_Key : (.*)/){
	       $AP_INFO[$i]=$1;
		   $i++;
	   }
   }
   close(CONFIG_FILE);      
   return 3;
}
sub ftp_ip{
   open(my $CONFIG_FILE, "<", "/etc/wsd.conf") or die("Could not open wsd.conf");	
	my ($FTP_IP);
	while( my $line = <$CONFIG_FILE> ){
        chomp($line);		
        if($line =~ /FTP_Address : (.*)/){		   		  
		   $FTP_IP = $1;
           		   
        }
   }
   close(CONFIG_FILE);   
   return ($FTP_IP);
}

sub ftp_user{
   open(my $CONFIG_FILE, "<", "/etc/wsd.conf") or die("Could not open wsd.conf");	
	my ($FTP_USER);
	while( my $line = <$CONFIG_FILE> ){
        chomp($line);		
		if($line =~ /FTP_Port : (.*)/){
		   $FTP_USER = $1;
		}
   }
   close(CONFIG_FILE);   
   return ($FTP_USER);
}
sub ap_selected{
   open(my $CONFIG_FILE, "<", "/etc/wsd.conf") or die("Could not open wsd.conf");	
   my ($AP_COUNT);
   while( my $line = <$CONFIG_FILE>){
       chomp($line);
	   if($line =~ /AP_ACCOUNT : (.*)/){
	      $AP_COUNT = $1;
	   }
   }
   close(CONFIG_FILE);      
   return ($AP_COUNT);
}
sub sub_ip_address{
   open(my $CONFIG_FILE, "<", "/etc/wsd.conf") or die("Could not open wsd.conf");	
   my ($local_ip1, $local_ip2,$sender_ip1,$sender_ip2);
   while( my $line = <$CONFIG_FILE>){
       chomp($line);
	   if($line =~ /My IP Addr : 192.168.(.*)\./){
	      $local_ip1 = $1;
		  if($line =~ /My IP Addr : 192.168.$local_ip1.(.*)/){
		      $local_ip2 = $1;
		  }
	   }	   
	   if($line =~ /Target IP Addr : 192.168.(.*)\./){
	      $sender_ip1 = $1;
		  if($line =~ /Target IP Addr : 192.168.$local_ip1.(.*)/){
		      $sender_ip2 = $1;
		  }
	   }	   
   }
   close(CONFIG_FILE); 
   return ($local_ip1, $local_ip2, $sender_ip1, $sender_ip2); 
}

sub WIFI_SSID{
    open(my $CONFIG_FILE, "<", "/etc/wsd.conf") or die("Could not open wsd.conf");
    my($WiFi_SD);
    while( my $line = <$CONFIG_FILE>){
	chomp($line);
	if($line =~ /WIFISSID : (.*)/){
	    $WiFi_SD = $1;
	   }
        if($line =~ /Channel : (.*)/){
            $WiFi_channel = $1;
           }
   }
   close(CONFIG_FILE);      
   return ($WiFi_SD);
}

sub Auto_WiFi_Mode{
    open(my $CONFIG_FILE, "<", "/etc/wsd.conf") or die("Could not open wsd.conf");
    my($wifi_mode);
    while( my $line = <$CONFIG_FILE>){
	chomp($line);
	if($line =~ /Auto WiFi Mode : (.*)/){
	    $wifi_mode = $1;
	   }
   }
   close(CONFIG_FILE);      
   return ($wifi_mode);
}


sub Host_SSID{
    open(my $CONFIG_FILE, "<", "/etc/wsd.conf") or die("Could not open wsd.conf");
    my($Host_KEY);
    while( my $line = <$CONFIG_FILE>){
        chomp($line);
           if($line =~ /Host WPA2 Key : (.*)/){
            $Host_KEY = $1;
           }
   }
   close(CONFIG_FILE);      
   return ($Host_KEY);
}

sub Host_Switch{
    open(my $CONFIG_FILE, "<", "/etc/wsd.conf") or die("Could not open wsd.conf");
    my($Host_Switch);
    while( my $line = <$CONFIG_FILE>){
        chomp($line);
           if($line =~ /Host WPA2 Key : (.*)/){
            $Host_Switch = $1;
           }
   }
   close(CONFIG_FILE);      
   return ($Host_Switch);
}

sub Host_SSID_backup{
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

sub domain_name{
   open(my $CONFIG_FILE, "<", "/etc/udhcpd.conf") or die("Could not open udhcpd.conf");	
   my ($domain);
   while( my $line = <$CONFIG_FILE>){
       chomp($line);
	   if($line =~ /option  domain  (.*)/){
	      $domain = $1;
	   }
   }
   close(CONFIG_FILE);      
   return ($domain);
}
my @AP_SELECTED=&ap_setup();
print "Content-type: text/html\n\n";
print "<html>";
print "<head>";
print "<meta http-equiv=\"content-language\" content=\"zh-tw\">";
print "<meta HTTP-EQUIV=\"content-type\" CONTENT=\"text/html; charset=utf-8\">";
print "<title>Edit-Config</title>";
print "<script language=\"javascript\"> 
function myDelete(){
	var oTable = document.getElementById(\"AP_KINDS\");
	#//§R°£¸Ó¦æ
	this.parentNode.parentNode.parentNode.removeChild(this.parentNode.parentNode);
}
window.onload=function(){
	var oTable = document.getElementById(\"AP_KINDS\");
	var oTd;
	
	for(var i=0;i<oTable.rows.length;i++){
		oTd = oTable.rows[i].insertCell(2);
		#oTd.innerHTML = \"<a href='#'>delete</a>\";
		oTd.firstChild.onclick = myDelete;
	}
}
</script>";
print "<script language=\"javascript\" type=\"text/javascript\">
function control(obj)
{
document.forms['kcard_edit_form'].Host_WPA_KEY.disabled = (obj.checked)?false:true;
}
</script>";
print "<style>
<!--
body{
	background-color:#ffffff;
}
-->
</style>";
print "<SCRIPT type='text/javascript' src='../script/kcard_edit_config.js'></SCRIPT>\n";
print "</head>";
print "<body>";
print "<Form name=\"kcard_edit_form\" action=\"kcard_save_config.pl\" method=\"POST\" target=\"_self\">";
print "<h2>WiFi Information Setting</h2>";

print "<br><br><b>Hotspots  : </b>";
print "<table id=\"AP_KINDS\"><OL>";
for (my $i=1; $i<=$AP_SELECTED[0]; $i++){
print "<tr>";
print "<td>AP #$i SSID : <input type=\"text\" name=\"SSID$i\" value=\"$AP_INFO[2*$i-2]\"></td>";
print "<td>KEY : <input type=\"password\" maxlength=\"64\" name=\"KEY$i\" value=\"$AP_INFO[2*$i-1]\"></td>";
print "</tr>";
}
my $FTP_IP=&ftp_ip();
my $FTP_USER=&ftp_user();
print "</table>";
print "<br><b>FTP Server Setting</b><br>";
print "FTP Server IP Address : <input type=\"text\" name=\"FTP_IP\" Value=\"$FTP_IP\"><br>";
print "FTP Saver Port : <input type=\"text\" name=\"FTP_PORT\" Value=\"$FTP_USER\"><br>";
print "<br><b>WiFi Information</b><br>";
my $WiFi_SD=&WIFI_SSID();
my $auto_wifi_mode=&Auto_WiFi_Mode();
print "SSID : <input type=\"text\" name=\"WIFI_SSID\" Value=\"$WiFi_SD\"><br>";
my $Host_AP=&Host_SSID();
my $Host_AP_backup=&Host_SSID_backup();
my $Host_Switch=&Host_Switch();
$Host_Switch_LEN = length($Host_Switch);
if ($Host_Switch_LEN != 0 )
{
print "<font size=\"2\"><input type=\"checkbox\" name=\"ctr\" onclick=control(this) VALUE=\"true\" CHECKED>(V : Enable WiFi Password)</font>";
print "<br>WiFi Password : <input type=\"text\" name=\"Host_WPA_KEY\" maxlength=\"63\" value=\"$Host_AP\">(Please input 8 ~ 63 characters)<br>";
}
else
{
print "<font size=\"2\"><input type=\"checkbox\" name=\"ctr\" onclick=control(this)>(V : Enable WiFi Password)</font>";
print "<br>WiFi Password : <input type=\"text\" disabled name=\"Host_WPA_KEY\" maxlength=\"63\" value=\"$Host_AP_backup\">(Please input 8 ~ 63 characters)<br>";
}
print "Wireless Channel : ";
print "<select name=\"Channel_Num\">";

for ( my $i=1; $i<=11; $i++){
     if ( $i == $WiFi_channel){
	   print "<option value=\"$i\" selected='yes' >$i";	 	 
	 }  
	 else{ 
	   print "<option value=\"$i\">$i";	 	 
	 }  
}

print "</select>";
print "<br><br><b>WiFi Auto On</b><br>";
if($auto_wifi_mode eq "Disable")
{print "<input type=\"radio\" name=\"WiFi_Mode\" value=\"Disable\" checked='checked'> Disable<br>";
print "<input type=\"radio\" name=\"WiFi_Mode\" value=\"Enable\" > Enable<br>";}
else
{
print "<input type=\"radio\" name=\"WiFi_Mode\" value=\"Disable\" > Disable<br>";
print "<input type=\"radio\" name=\"WiFi_Mode\" value=\"Enable\" checked='checked'> Enable<br>";}

print "<br><br><input type=\"submit\" value=\"Submit All\">&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;";
print "<input type=\"button\" value=\"Back\" onClick=\"Back()\">&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;";
print "</form>";
print "</body>";
print "</html>";
