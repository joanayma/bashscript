#!/bin/bash
# example script using lftp for syncing a remote ftp to local dir with some speed up.

which lftp || (echo "lftp not found on path." && exit 255)

HOST='origin-host.com'
USER='ftp-user'
PASS='ftp-passwd'
TARGETFOLDER='local-directory-where-storage'
SOURCEFOLDER='remote-directory-ftp'

if ps -p `cat /tmp/sync-ftp.pid` > /dev/null; then
      echo "Sync running"
          exit 1
fi

echo $$ > /tmp/sync-ftp.pid 
echo `date` > /var/log/sync-ftp.log

lftp -f "
set ftp:list-options -a
set ssl:verify-certificate off #only =>4.7.0
set ftp:sync-mode off
set ftp:mode-z-level 9 #only =>4.7.0
open $HOST
user $USER $PASS
lcd $TARGETFOLDER
mirror -vv --delete --use-cache --parallel=100 --depth-first --only-newer --exclude="som[eE]\.regex$" --exclude="^(use|regex)+" $SOURCEFOLDER $TARGETFOLDER
bye
" >> /var/log/sync-ftp.log
