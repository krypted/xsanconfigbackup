
# 
#!/bin/bash 
# 
# Script Name: xsan-backup.sh 
##################################################################################################
##################################################################################################
# 
# Script Details: Perform a cvgather on a given Xsan volume and do a manual backup of the "/Library/Filesystems/Xsan/config" 
# directory that can be set for daily/weekly automations using a launchd job in "Lingon" or 
# a cron job in "Cronnix" (using GUIs are loads easier than doing it manually but do whatever you want ...) 
# 
# Script Requirements: Lingon <http://lingon.sourceforge.net/>, Cronnix <http://www.abstracture.de/projects-en/cronnix>, 
# sendEmail <http://caspian.dotconf.net/menu/Software/SendEmail/> 
# 
# Additional Notes: 1) sendEmail must be installed at /usr/local/bin/ 
# 2) this script must be made executable (i.e. chmod +x /<path-to-script>/xsan-integrity.sh) 
# 
# START 
# 
# Set your variables (i.e. change the stuff between the "quotes") -- 
# 
##################################################################################################
##################################################################################################
# Volume Info -- 
XsanVol1="My_Xsan" 
# 
# Email Info -- 
emailFrom="notifications@some.nameserver.com" ## Note: this can be spoofed on SOME mail servers but NOT all 
emailTo="alerts@your.nameserver.com;alerts@their.nameserver.com" ## Note: use a comma or semicolon to separate email addresses 
emailSubject="Weekly cvgather and config folder backup for <the client's name or whatever your deem appropriate>" 
emailServer="smtp.nameserver.com" 
# 
# Uncomment out the next two lines and the '#!' from line 49 if the smtp server requires authentication -- 
# emailUserName="<username>" 
# emailUserPassword="<password>" 
# 
## 
# DON'T CHANGE THIS NEXT STUFF UNLESS YOU KNOW WHAT YOU ARE DOING OR AT LEAST THINK YOU KNOW -- 
## 
# 
# Actions -- 
/bin/mkdir -p /cvgathers/`date +%F` 
cd /cvgathers/`date +%F`/ 
/Library/Filesystems/Xsan/bin/cvgather -f $XsanVol1 > /Library/Logs/`date +%F`-integrity.log 
cd /Library/Filesystems/Xsan/ 
/usr/bin/ditto -ck --keepParent /Library/Filesystems/Xsan/config /config-files/`date +%F`.zip 
# 
# Email the logs -- 
# 
logfile=`more /Library/Logs/*-integrity.log` 
# 
/usr/local/bin/sendEmail -f "$emailFrom" -t "$emailTo" -u "$emailSubject" -m "$logfile" -s "$emailServer" #! -xu "$emailUserName" -xp "$emailUserPassword" 
# 
# END 
# 
#End Copy
