" Test listing of backups from the future. 
" (This can happen when the backup is written e.g. on a Samba share that has a
" different clock setting.) 
" Tests that negative time differences are handled gracefully and specially
" reported. 

cd $TEMP/WriteBackupTest
silent ! touch --date="+45 seconds" important.txt.20080101b

edit important.txt
echomsg 'Test: Backup from the future'
WriteBackupListVersions

call vimtest#Quit() 

