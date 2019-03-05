#!/bin/bash

# Personal backup


#  -e "^ *-
#  -v, --verbose               increase verbosity
#  -r, --recursive             recurse into directories
#  -b, --backup                make backups (see --suffix & --backup-dir)
#  -u, --update                skip files that are newer on the receiver
#      --append                append data onto shorter files
#      --append-verify         like --append, but with old data in file checksum
#  -l, --links                 copy symlinks as symlinks
#  -n, --dry-run               perform a trial run with no changes made
#  -z, --compress              compress file data during the transfer
#      --files-from=FILE       read list of source-file names from FILE
#  -h, --human-readable        output numbers in a human-readable format
#      --progress              show progress during transfer
#      --log-file=FILE         log what we're doing to the specified FILE
#      --list-only             list the files instead of copying them

# rsync -vrbulnhz --append --files-from=included --progress --log-file=logB --list-only
# test2
