#!/bin/bash

# PERSONAL BACKUP - USER HOME FILES (AS USER)
# HELP: '$bash backup.sh --help'

# user help functionality './backup --help'
function help {
   cat <<EOF

Personal Backup
This example is for HOME backup '/home/'

USAGE

./backup.sh type dryrun time
./backup.sh               - dryrun of daily home backup
./backup.sh -d nodry      - daily backup
./backup.sh -w nodry      - weekly backup

CURRENT PATHES (edit backup.sh to change them):

EOF
    echo daily backup stored in":$backup_daily"
    echo weekly backup stored in":$backup_weekly"
    echo directory to backup":$bsource"
}

# VARIABLES TO SETUP BY USER

backup_daily=/home/jaggij/Backup  # default backup path
backup_weekly=/media/backups/weekly/home
bsource=/home/

bdestination="$backup_daily"

# MAIN PROGRAM

# check for help function
[[ $1 == --help || $1 == -h ]] && help && exit 0

# determine daily or weekly backup type
[[ $1 == "-w" ]] && bdestination="$backup_weekly"
echo backup_path is "$bdestination `date +%d%b%Y`time`date +%H%M`" \
    | tee -a lastbackup.log

if [[ $2 == nodry ]] ; then
    rsync -xaAXhv --delete-excluded \
          --log-file="log`date +%d%b%Y`time`date +%H%M`" \
          --include-from=./included \
          --exclude-from=./excluded \
          "$bsource" "$bdestination"
else
    rsync -xaAXhv --dry-run --delete-excluded \
          --log-file="log`date +%d%b%Y`time`date +%H%M`" \
          --include-from=./included \
          --exclude-from=./excluded \
          "$bsource" "$bdestination"
fi

# END OF MAIN PROGRAM

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

# END OF ADDITIONAL NOTES

# THE END
