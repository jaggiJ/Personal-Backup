#!/bin/bash

# TODO:
# 1. commands for single directory restore, dryrun and normal
# 2. commands for full restore of system and home backups dry and normal.

# PERSONAL BACKUP - RESTORE OPTIONS
# MIT License
# Copyright (c) 2019 jaggiJ

# USAGE: ./restore.sh --help

# USER HELP FUNCTION
function help {
   cat <<EOF

USAGE EXAMPLES

TO RESTORE SINGLE DIRECTORY FROM BACKUP (source) TO CURRENT HOME OR SYSTEM

./restore.sh /home/jaggij/Backup/Video /home/jaggij/Video
             source                    destination
sudo ./restore.sh /media/backups/system/var /var
                  source                    destination

EOF
}

[[ $1 == "--help" || $1 == "-h" || $# == 0 ]] && help && exit 0

# This is example of `home backup restore`. Note --delete here is
# without -excluded to prevent ... disaster :D
# rsync -xaAXhv --dry-run --delete \
      # --log-file="log`date +%d%b%Y`time`date +%H%M`" --exclude="lost+found" \
      # --include-from=included --exclude-from=excluded \
      # ~/Backup/ /home

# ADDITIONAL NOTES

# RESTORE INCREMENTAL TAR BACKUP

# When extracting from the incremental backup tar
# attempts to restore the exact state the file system had when the archive was
# created. In particular, it will delete those files in the file system that did
# not exist in their directories when the archive was created.
# if we had created several levels of incremental files, then in order to
# restore the exact contents the file system had when the last level was
# created, we will need to restore from all backups in turn. At first, do
# level-0 extraction:
# tar --listed-incremental=/dev/null -xzpvf backup.tar.gz
# and then, level-1 extraction:
# tar --listed-incremental=/dev/null -xzpvf backup.1.tar.gz

# PEEK into incremental backup file

# If you want to see what is really in the incremental tar (archive managers wont
# show you the stuff its going to delete for you), you can use the --incremental
# and two verbose flags thus:
# $ tar --incremental -tvvzpf root_backup_incremental.tar.gz

# RSYNC options

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
