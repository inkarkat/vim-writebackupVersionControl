" Test listing of backups.

call vimtest#SkipAndQuitIf(! isdirectory($VIM), '$VIM (' . $VIM . ') does not exist')

cd $TEMP/WriteBackupTest
edit not\ important.txt
echomsg 'Test: No backups exist for this file'
WriteBackupListVersions

edit important.txt
echomsg 'Test: Listing from file''s directory'
WriteBackupListVersions

echomsg 'Test: Listing with a different CWD, new recent backup'
cd $VIM
%s/current/fifth/
WriteBackup
WriteBackupListVersions

call vimtest#Quit()

