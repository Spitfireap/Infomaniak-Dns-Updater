# Infomaniak-Dns-Updater
 EN:
 
 Update your dynamic IPs managed by Infomaniak

## Requirements 
- glibc
- curl
- (cron)

## Security note
Your dynDNS password(s) will be in plain text in the config file. To increase security, please run this program as root or with a specific user and use `chown userYouChoose:userYouChoose IDUConfig && chmod 600`.

## Installation
- Clone the repo, download the source code or simply download the release
- Extract it where you want 
- `chmod +x dnsUpdate.bash"
- copy the sample in IDUConfig to whatever you want ending it with .conf (I suggest naming it with the host you're changing, like "a.domain.com.conf"), replicate this step for every dyndns host you have (see **Configuration**)
- `chmod -R 600 IDUConfig`
- set a cron task running whenever you want "dnsUpdate.bash" (crontab -e then `*/10 * * * * /path/to/the/script/dnsUpdate.bash`)
- DONE

## Configuration
IPV6=0,1,2 --> 0 is IPV4 only, 1 is IPV6 only, 2 is both
login=XXX --> Login you set when creating the dyndns host
password=XXX --> Password you set when creating the dyndns host
host=a.domain.com --> hostname

Create one file per host in the config folder ending it with ".conf"

## Advanced Configuration 
In dnsUpdate.bash you can set another folder by setting the CONFIGDIR variable to the config folder path you want (don't forget the Security note).
You can also set another way to get the new IPV4/IPV6 by changing CURRENTIPV4 or CURRENTIPV6.
