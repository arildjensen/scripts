#!/bin/bash
  
documents_dirs=( gnucash )
dot_dirs=( ssh )
rsync_cmd='rsync -e ssh --delete --recursive --perms --checksum --compress --stats --human-readable --progress'
destination='ajensen@counter-attack.com'

# Backup Documents subdirs
for i in "${documents_dirs[@]}"; do
  ${rsync_cmd} ~/Documents/$i/ ${destination}:~/mydocuments/$i
done

# Backup dot-dirs
for i in "${dot_dirs[@]}"; do
  ${rsync_cmd} ~/.$i/ ${destination}:~/mydocuments/$i
done
