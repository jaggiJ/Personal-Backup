#!/bin/bash

# Personal backup

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

# This example is for system backup '/'
#sudo rsync -xaAXv --delete --dry-run --log-file=logB --exclude=/dev/* --exclude=/proc/* \
     #--exclude=/sys/* --exclude=/tmp/* --exclude=/run/* --exclude=/mnt/* \
     #--exclude=/media/* --exclude="swapfile" --exclude="lost+found" \
     #--exclude=".cache" --exclude="Downloads" --exclude=".VirtualBoxVMs"\
     #--exclude=".ecryptfs" / /backup_directory/

# This example is for HOME backup '/home/'
# rsync -xaAXhv --dry-run --delete-excluded \
      # --log-file="log`date +%d%b%Y`time`date +%H%M`" \
      # --include-from=included --exclude-from=excluded \
      # /home/ /home/jaggij/Backup

# This is example of `home backup restore`. Note --delete here is without -excluded
# to prevent unwanted deletions.
rsync -xaAXhv --dry-run --delete \
      --log-file="log`date +%d%b%Y`time`date +%H%M`" --exclude="lost+found" \
      --include-from=included --exclude-from=excluded \
      ~/Backup/ /home
