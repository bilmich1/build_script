# build_script
Script that pull and build the main repository

This script always pulls the current branch and build from scratch by deleting the ".fbuild" directory   before each build.

# Installation
### [Stunnel](https://www.stunnel.org/ "Stunnel")
Stunnel is a SSL pass-through service. It is needed in order for blat to send emails through GMail.  
Installation procedure:  
1. Download and install Stunnel  
2. From Stunnel's installation folder, overwrite "stunnel.conf" with the following 
```    
# GLOBAL OPTIONS
client = yes
output = stunnel-log.txt
debug = 0
taskbar = no

# SERVICE-LEVEL OPTIONS
[SMTP Gmail]
accept = 127.0.0.1:1099
connect = smtp.gmail.com:465

[POP3 Gmail]
accept = 127.0.0.1:1109
connect = pop.gmail.com:995  
```
3. From the startup menu, run stunnel service install
4. From the startup menu, run stunnel service start

### [Blat](https://sourceforge.net/projects/blat/)  
Blat is a command line program SMTP mailer. It is needed in order for the script to sends emails through GMail.  
Installation procedure:  
1. Download Blat  
2. Unpack Blat in a place to be accessible for the script, or add Blat to %PATH%  
3. Configure Blat using: `blat -install smtp.gmail.com <email> -u <email> -pw <password> - - gmailsmtp`  
4. Blat can now be used to send email using: `blat -p gmailsmtp -to <destination> -subject "Subject" -body "Body" -server 127.0.0.1:1099` 

### Running the script  
The script can now be run by passing a comma separeted list of email recipient as argument, or by setting a Windows Task Scheduler.  
`build_script.bat "email1@domain.com,email2@domain.com"
