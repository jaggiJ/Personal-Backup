# Personal-Backup

DON'T USE THE CODE. RISK OF LOSING DATA IS MORE THAN VERY HIGH.  
IT SERVES AS AN EXAMPLE FOR PERSONALISED AUTOMATED BACKUP SYSTEM.  
IT COMES WITH ABSOLUTELY NO WARRANTY AND IS INTENDED TO VIEW NOT RUN.  

This example is for system with home directory on separate partition  
than system (root /) directory. Scripts are assumed to be located at  
`/home/jaggij/Git/Personal-Backup/`  

HOW TO MAKE THIS ALL THIS SCRIPTS INTO AUTOMATED BACKUPS ?  

1. Order cron to backup system and home files every day, every week, and every month (3 separate backups)   
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
30 13 1 * * cd "$backups" && ./sysbackup.sh -tar
```

WORK IN PROGRESS: restore.sh is not finished  

THE END
