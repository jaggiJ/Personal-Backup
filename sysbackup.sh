#!/bin/bash

# define user help functionality './sysbackup --help'
help()
{
    cat <<EOF
Personal backup
This example is for system backup / (root)
USAGE
./sysbackup.sh               - dryrun of daily system backup (default)
./sysbackup.sh -d nodry      - daily backup
./sysbackup.sh -w nodry      - weekly backup
EOF
}

# VARIABLES TO SETUP BY USER

# where to store daily /home backups ?
backup_daily=/home/jaggij/sysbackup
# where to store weekly /home backups ?
backup_weekly=/media/backups/weekly/system
# what need to be backed up ?
bsource=/

# MAIN PROGRAM

# check for help function
[[ $1 == --help || $1 == -h ]] && help && exit 1

# determine daily or weekly backup type
bdestination="$backup_daily"
[[ $1 == "-w" ]] && bdestination="$backup_weekly"
echo backup_path is "$bdestination `date +%d%b%Y`time`date +%H%M`" \
    | tee -a lastbackupsys.log

# main command that writes changes
if [[ $2 == nodry ]] ; then
    rsync -xaAXhv --delete-excluded \
          --log-file="logsys_`date +%d%b%Y`time`date +%H%M`" \
          --include-from=./includedsys \
          --exclude-from=./excludedsys \
          "$bsource" "$bdestination"

# main command simulation only (dryrun)
else
    rsync -xaAXhv --dry-run --delete-excluded \
          --log-file="logsys_`date +%d%b%Y`time`date +%H%M`" \
          --include-from=./includedsys \
          --exclude-from=./excludedsys \
          "$bsource" "$bdestination"
fi

# END OF PROGRAM

# ADDITIONAL NOTES

# Note: It is recommended that the backup drive has a Linux compatible file
# system as ext4. You must exclude the destination directory, if it exists in
# the local system. It will avoid the an infinite loop. A trailing slash on the
# source changes this behavior to avoid creating an additional directory level
# at the destination. You can think of a trailing / on a source as meaning "copy
# the contents of this directory" as opposed to "copy the directory by name",
# but in both cases the attributes of the containing directory are transferred
# to the containing directory on the destination.

#  -a, --archive               archive mode; equals -rlptgoD (no -H,-A,-X)
#  -v, --verbose               increase verbosity
#  -r, --recursive             recurse into directories
#  -l, --links                 copy symlinks as symlinks
#  -n, --dry-run               perform a trial run with no changes made
#      --files-from=FILE       read list of source-file names from FILE
#  -h, --human-readable        output numbers in a human-readable format
#      --progress              show progress during transfer
#      --log-file=FILE         log what we're doing to the specified FILE
#      --list-only             list the files instead of copying them
#  -p, --perms                 preserve permissions
#  -g, --group                 preserve group
#  -t, --times                 preserve modification times
#  -o, --owner                 preserve owner (super-user only)
#  -D                          same as --devices --specials
#      --devices               preserve device files (super-user only)
#      --specials              preserve special files
#  -A – preserve Access Control List. (e.g. 744)
#  -X – preserve extended attributes. (file metadata assigned by user or apps)
#  -v – It will show the progress of the backup.
#  --delete – delete all the files in the backup not present on your system.
#  --dry-run – This option simulates the backup. Useful to test. 
#  --exclude – Excludes folders and files from backup.
#  --include=PATTERN       don't exclude files matching PATTERN
#  --include-from=FILE     read include patterns from FILE

# tar -c - create new archive -z filter through gzip -p preserve permissions -f use archive file
# <filename>$(date +%d%b%Y`time`date +%H%M) - add date at file creation to end of filename

# This example is for system backup '/'
#sudo rsync -xaAXv --delete --dry-run --log-file=logB --exclude=/dev/* --exclude=/proc/* \
     #--exclude=/sys/* --exclude=/tmp/* --exclude=/run/* --exclude=/mnt/* \
     #--exclude=/media/* --exclude="swapfile" --exclude="lost+found" \
     #--exclude=".cache" --exclude="Downloads" --exclude=".VirtualBoxVMs"\
     #--exclude=".ecryptfs" / /backup_directory/
# test2

# Tar credentials
# DATE=`date +%d-%b-%Y`                  # This Command will add date in Backup File Name.
# FILENAME=fullbackup-$DATE.tar.gz       # Here I define Backup file name format.
# SRCDIR=/                               # Location of Important Data Directory (Source of backup).
# DESDIR=/example/please/change        # Destination of backup file.
# tar -cpzf $DESDIR/$FILENAME --directory=/ --exclude=proc --exclude=sys --exclude=dev/pts --exclude=$DESDIR $SRCDIR

# Firsr for backup-tar.sh
# $ sudo crontab -e
#
# Add line:
# 00 08 * * 7 /bin/bash /path/to/backup-tar.sh
# This will run the backup-tar.sh script every sunday at 08:00.
#
# Then for backup-rsync.sh
# $ crontab -e
#
# Add line:
# 00 23 * * 7 /bin/bash /home/tuukka/backup-rsync.sh

#Purpose = Sync backup files to an another server
#START

# rsync -a --bwlimit=5000 -e ssh --hard-links --inplace sourcefolder destinationuser@example.com:/full-backup

# END OF ADDITIONAL NOTES

