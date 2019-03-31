# Personal-Backup  

NOW FULLY FUNCTIONAL AND CAPABLE OF TOTAL BACKUP AUTOMATION after initial  
setup of PATHes and adding entries into crontab as shown in example.  
Manual restore script also working (except for tar monthly backup).  

## DISCLAIMER  

SCRIPT HAS SECURITY MEASURE THAT WRITE CHANGES TO DISK ONLY WHEN  
ARGUMENT 'NODRY' IS EXPLICITY USED ('dry' create logs and standard output).  
STILL RISK OF LOSING DATA IS HIGH FOR EXAMPLE:  

IF YOU MESS SOURCE WITH DESTINATION PATHES...  
   UPS, MASSIVE DATA LOSS.  
IF YOU USE ALREADY EXISTING DESTINATION PATH FILLED WITH SOMETHING ELSE  
THAN FOR EXAMPLE OLD BACKUP...  
   UPS, MASSIVE DATA LOSS.  
IF I MADE AN ERROR IN CODE THAT I AM NOT AWARE OF AND YOU GO FOR IT,  
   UPS, MASSIVE DATA LOSS.  
DESPITE THAT I TRY MAKE IT IDIOT PROOF AND TEST INSTANCES OF USE,  
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

## WORK IN PROGRESS TOWARD 1.0 :  

**Development**: [https://github.com/jaggiJ/Personal-Backup/projects/1](https://github.com/jaggiJ/Personal-Backup/projects/1)


## THE END
