#!/bin/bash

# PERSONAL BACKUP - SYSTEM FILES
# MIT License
# Copyright (c) 2019 jaggiJ

# USAGE examples: /.sysbackup.sh --help

# HELP FUNCTION 
function help {
    cat <<EOF

Personal backup
This example is for system backup / (root)

USAGE

Remember to include sudo to backup system files by hand. When adding to crontab
with 'sudo crontab -e' do NOT include sudo since then the job will run as root.

./sysbackup.sh -d dry        - dryrun of daily system backup
./sysbackup.sh -w dry        - dryrun of weekly system backup
./sysbackup.sh -d nodry      - daily backup
./sysbackup.sh -w nodry      - weekly backup
./sysbackup.sh -tar          - monthly incremental backup (nodry)

CURRENT PATHS (edit sysbackup.sh to change them):

EOF
    echo daily backup stored in":$backup_daily"
    echo weekly backup stored in":$backup_weekly"
    echo monthly backup stored in":$backup_monthly"
    echo directory to backup":$bsource"
}

# DEFINE PATHS HERE

# where to store daily /home backups ?
backup_daily=/home/jaggij/sysbackup

# where to store weekly /home backups ?
backup_weekly=/media/backups/weekly/system

# where to store monthly home and sys backup ?
backup_monthly=/media/backups/weekly

# what need to be backed up ?
bsource=/

# END DEFINE BACKUP PATHS HERE

# MAIN PROGRAM

# check for help function
[[ $1 == --help || $1 == -h || $# == 0 ]] && help && exit 0

# check for backup source directory existence
[ ! -d "$bsource" ] && echo directory for backup source not present && exit 10

# RUN MONTHLY BACKUP CODE

if [[ $1 == "-tar" ]]; then

    # check if directory exist
    [ ! -d "$backup_monthly" ] && echo directory for backup \
                                       not present && exit 10

    # go into monthly backup directory
    cd $backup_monthly || exit 3

    # run full backup 0-level if not already present
    if [ ! -f backup0*.tar.gz ]; then
        tar --listed-incremental=snapshot.file \
            -cpzvf "backup0_`date +%d-%b-%Y`.tar.gz" home/ system/ \
            && echo Monthly backup started and stored at "$backup_monthly"

    else  # run 1-level incremental backup
        cp snapshot.file snapshot.file1 && echo snapshot file copied
        tar --listed-incremental=snapshot.file1 -cpzvf \
            backup1_"`date +%d-%b-%Y`time`date +%H%M`".tar.gz home/ system/ \
            2>&1 | tee log"$(date +%d%H%M)"
    fi
    exit 0
fi

# END OF RUN MONTHLY BACKUP CODE

# ADDITIONAL CHECKS

# DETERMINE DAILY OR WEEKLY BACKUP TYPE
bdestination="$backup_daily"
[[ $1 == "-w" ]] && bdestination="$backup_weekly"
echo backup_path is "$bdestination `date +%d%b%Y`time`date +%H%M`" \
    |tee -a lastbackupsys.log

# CHECK IF DIRECTORY FOR DAILY OR WEEKLY BACKUPS EXIST
if [[ $1 == -w || $1 == -d ]] ; then
    if [ ! -d "$bdestination" ]; then
        echo directory for backup not present && exit 10
    else
        echo Directory for the backup is OK
    fi
fi

# END OF ADDITIONAL CHECKS

# MAIN COMMAND THAT WRITES CHANGES

# RUN WEEKLY AND DAILY BACKUP
if [[ $2 == nodry ]] ; then
    rsync -xaAXhv --delete-excluded \
          --log-file="logsys_`date +%d%b%Y`time`date +%H%M`" \
          --include-from=./includedsys \
          --exclude-from=./excludedsys \
          "$bsource" "$bdestination"

# END OF MAIN COMMAND THAT WRITES CHANGES

# MAIN COMMAND SIMULATION ONLY (DRYRUN)

elif [[ $2 == dry ]]; then
    rsync -xaAXhv --dry-run --delete-excluded \
          --log-file="logsys_`date +%d%b%Y`time`date +%H%M`" \
          --include-from=./includedsys \
          --exclude-from=./excludedsys \
          "$bsource" "$bdestination"
else
    # runs help function printing usage examples
    help
    exit 0
fi

# END OF MAIN COMMAND SIMULATION ONLY (DRYRUN)

# END OF MAIN PROGRAM

# ADDITIONAL NOTES

# TAR options

# tar -c - create new archive
#     -v - verbose
#     -t - list files in archive
#     -z - filter through gzip
#     -p - preserve permissions
#     -f - use archive file

# backup name with current date and time
# foo`date +%d%b%Y`time`date +%H%M`

# CREATION OF INCREMENTAL TAR ARCHIEVE

# 0-level full backup command
# tar --listed-incremental=snapshot.file -cvzf backup.tar.gz /path/to/dir

# 1-level backup command
# tar --listed-incremental=snapshot.file -cvzf backup.1.tar.gz /path/to/dir

# if we want to make more “level-1” backups we can copy the snapshot file and
# then provide it to tar. If we don’t need that then we need to do nothing it
# will simply created another incremented archive.
# cp snapshot.file snapshot.file.1
# tar --listed-incremental=snapshot.file.1 -cvzf backup.1.tar.gz /path/to/dir

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

# END OF ADDITIONAL NOTES

# THE END
