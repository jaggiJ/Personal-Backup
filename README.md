# Personal-Backup

## DISCLAIMER  

SCRIPT HAS SECURITY MEASURE THAT WRITE CHANGES TO DISK ONLY WHEN  
ARGUMENT 'NODRY' IS EXPLICITY USED IN ALL CASES.  
STILL RISK OF LOSING DATA IS HIGH FOR EXAMPLE:  
IF YOU MESS SOURCE WITH DESTINATION PATHES... UPS, MASSIVE DATA LOSS.  
ALSO THERE CAN BE ERRORS IN CODE, DESPITE THAT I TRY MAKE IT IDIOT PROOF  
AND TRY TEST INSTANCES OF USE.  
THEREFORE,  
THE SCRIP SERVES AS AN EXAMPLE FOR PERSONALISED AUTOMATED BACKUP SYSTEM.  
IT COMES WITH ABSOLUTELY NO WARRANTY AND IS INTENDED TO VIEW NOT RUN.  
IF YOU RUN IT YOU ARE SOLELY RESPONSIBLE FOR ANY DATA LOSS.

THE SCRIPT IS WRITTEN AND TESTED FOR SYSTEM WITH /HOME ON SEPARATE  
PARTITION THAN ROOT DIRECTORY, THEREFORE,  
IF HOME DIRECTORY IS ON SAME PARTITION AS ROOT '/' DIRECTORY  
THEN THIS SETUP NEED MORE TWEAKING AND IS NOT TESTED FOR THAT CASE:  
Minimum change:  add '/home' in sysexcluded

## PERSONALISATION  

To setup own backup paths for source and destination one need to edit  
backup.sh and sysbackup.sh and  
alter variables in section '# DEFINE BACKUP PATHS HERE'  

then one need to edit 'exclude' and 'sysexclude' to set directories or patterns  
for data that won't be backed up. 

## AUTOMATION  

Order cron to backup system files and home (personal) files every day, every week,  
and every month (3 separate backup destinations).  

type `crontab -e` and put lines below into crontab file that comes, then save&quit type `:wq`  
```  
# DAILY BACKUP  
3 9 * * 1-6 cd Git/Personal-Backup && ./backup.sh -d nodry  

# WEEKLY BACKUP  
3 9 * * 7 cd Git/Personal-Backup && ./backup.sh -w nodry  
```
type `sudo crontab -e`  and put lines below into crontab file that comes, then save&quit  
'ctrl + x' , choose 'y'  
```
# use /bin/bash to run commands, instead of the default /bin/sh
SHELL=/bin/bash

# Path to Personal Backup scripts
backups=/home/jaggij/Git/Personal-Backup
# PERSONAL BACKUPS OF SYSTEM FILES

# daily Monday-Saturday 11:05
5 11 * * 1-6 cd "$backups" && ./sysbackup.sh -d nodry

# weekly Sundays 11:05
5 11 * * 7 cd "$backups" && ./sysbackup.sh -w nodry

# monthly 1-st each month at 13:30 
30 13 1 * * cd "$backups" && ./sysbackup.sh -tar nodry
```

## WORK IN PROGRESS TOWARD 1.0 FINAL:  

**Development**: [https://github.com/jaggiJ/Personal-Backup/projects/1](https://github.com/jaggiJ/Personal-Backup/projects/1)


## THE END
